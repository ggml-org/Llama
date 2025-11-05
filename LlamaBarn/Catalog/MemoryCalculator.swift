import Foundation

/// Handles memory-related calculations for model compatibility and context window sizing.
/// All calculations are isolated here for clarity and testability.
enum MemoryCalculator {

  /// Fraction of system memory available for models on standard configurations.
  /// Macs with ≥128 GB of RAM can safely allocate 75% to the model since they retain ample headroom.
  private static let defaultAvailableMemoryFraction: Double = 0.5
  private static let highMemoryAvailableFraction: Double = 0.75
  private static let highMemoryThresholdMb: UInt64 = 128 * 1024  // binary units to match SystemMemory

  /// We evaluate compatibility assuming a 4k-token context, which is the
  /// default llama.cpp launches with when no explicit value is provided.
  static let compatibilityCtxWindowTokens: Double = 4_096

  /// Models must support at least this context window to launch.
  static let minimumCtxWindowTokens: Double = compatibilityCtxWindowTokens

  /// Cache for compatibility checks since model properties and system memory are fixed at launch.
  /// Lives for app lifetime, never invalidated. Cache keys include context length since we check
  /// compatibility at different context windows (default 4k, max context, custom values).
  private struct CompatibilityInfo {
    let isCompatible: Bool
    let incompatibilitySummary: String?
  }

  private struct CompatibilityCacheKey: Hashable {
    let modelId: String
    let tokens: Double
  }

  private struct UsableContextCacheKey: Hashable {
    let modelId: String
    let desiredTokens: Int?
  }

  private static var compatibilityCache: [CompatibilityCacheKey: CompatibilityInfo] = [:]
  private static var usableContextCache: [UsableContextCacheKey: Int?] = [:]

  // MARK: - Public API

  /// Computes the usable context window (in tokens) that fits within the allowed memory budget.
  /// - Parameters:
  ///   - model: Catalog entry under evaluation.
  ///   - desiredTokens: Upper bound requested by the caller. When nil, defaults to the model's max.
  /// - Returns: Rounded context window (multiple of 1024) or nil when the model cannot satisfy the
  ///            minimum requirements.
  static func usableContextWindow(
    for model: CatalogEntry,
    desiredTokens: Int? = nil
  ) -> Int? {
    let cacheKey = UsableContextCacheKey(modelId: model.id, desiredTokens: desiredTokens)
    if let cached = usableContextCache[cacheKey] {
      return cached
    }

    let minimumTokens = Int(minimumCtxWindowTokens)
    guard model.ctxWindow >= minimumTokens else { return nil }

    let sysMem = Catalog.systemMemoryMb
    guard sysMem > 0 else { return nil }

    let budgetMb = memoryBudget(systemMemoryMb: sysMem)
    let fileSizeWithOverheadMb = fileSizeWithOverhead(for: model)
    if fileSizeWithOverheadMb > budgetMb { return nil }

    let effectiveDesired = desiredTokens.flatMap { $0 > 0 ? $0 : nil } ?? model.ctxWindow
    let desiredTokensDouble = Double(effectiveDesired)

    let ctxBytesPerToken = Double(model.ctxBytesPer1kTokens) / 1_000.0
    let maxTokensFromMemory: Double = {
      if ctxBytesPerToken <= 0 {
        return Double(model.ctxWindow)
      }
      let remainingMb = budgetMb - fileSizeWithOverheadMb
      if remainingMb <= 0 { return 0 }
      let remainingBytes = remainingMb * 1_048_576.0
      return remainingBytes / ctxBytesPerToken
    }()

    let cappedTokens = min(Double(model.ctxWindow), desiredTokensDouble, maxTokensFromMemory)
    if cappedTokens < minimumCtxWindowTokens { return nil }

    let floored = Int(cappedTokens)
    var rounded = (floored / 1_024) * 1_024
    if rounded < minimumTokens { rounded = minimumTokens }
    if rounded > model.ctxWindow { rounded = model.ctxWindow }

    usableContextCache[cacheKey] = rounded

    return rounded
  }

  /// Checks if a model can fit within system memory constraints
  static func isModelCompatible(
    _ model: CatalogEntry,
    ctxWindowTokens: Double = compatibilityCtxWindowTokens
  ) -> Bool {
    compatibilityInfo(for: model, ctxWindowTokens: ctxWindowTokens).isCompatible
  }

  /// If incompatible, returns a short human-readable reason showing
  /// estimated memory needed (rounded to whole GB).
  /// Example: "needs ~12 GB of mem". Returns nil if compatible.
  static func incompatibilitySummary(
    _ model: CatalogEntry,
    ctxWindowTokens: Double = compatibilityCtxWindowTokens
  ) -> String? {
    compatibilityInfo(for: model, ctxWindowTokens: ctxWindowTokens).incompatibilitySummary
  }

  static func runtimeMemoryUsage(
    for model: CatalogEntry,
    ctxWindowTokens: Double = compatibilityCtxWindowTokens
  ) -> UInt64 {
    // Memory calculations use binary units so they line up with Activity Monitor.
    let fileSizeWithOverheadMb = fileSizeWithOverhead(for: model)
    let ctxMultiplier = ctxWindowTokens / 1_000.0
    let ctxBytes = Double(model.ctxBytesPer1kTokens) * ctxMultiplier
    let ctxMb = ctxBytes / 1_048_576.0
    let totalMb = fileSizeWithOverheadMb + ctxMb
    return UInt64(ceil(totalMb))
  }

  static func availableMemoryFraction(forSystemMemoryMb systemMemoryMb: UInt64) -> Double {
    guard systemMemoryMb >= highMemoryThresholdMb else { return defaultAvailableMemoryFraction }
    return highMemoryAvailableFraction
  }

  // MARK: - Private Helpers

  /// Converts bytes to megabytes using binary units (1 MB = 2^20 bytes)
  private static func bytesToMb(_ bytes: Int64) -> Double {
    Double(bytes) / 1_048_576.0
  }

  /// Calculates file size in MB including overhead multiplier
  private static func fileSizeWithOverhead(for model: CatalogEntry) -> Double {
    let fileSizeMb = bytesToMb(model.fileSize)
    return fileSizeMb * model.overheadMultiplier
  }

  /// Calculates available memory budget in MB based on system memory
  private static func memoryBudget(systemMemoryMb: UInt64) -> Double {
    let memoryFraction = availableMemoryFraction(forSystemMemoryMb: systemMemoryMb)
    return Double(systemMemoryMb) * memoryFraction
  }

  /// Computes compatibility info for a model and caches the result
  private static func compatibilityInfo(
    for model: CatalogEntry,
    ctxWindowTokens: Double = compatibilityCtxWindowTokens
  ) -> CompatibilityInfo {
    let cacheKey = CompatibilityCacheKey(modelId: model.id, tokens: ctxWindowTokens)
    if let cached = compatibilityCache[cacheKey] { return cached }

    let minimumTokens = minimumCtxWindowTokens

    if Double(model.ctxWindow) < minimumTokens {
      let info = CompatibilityInfo(
        isCompatible: false,
        incompatibilitySummary: "requires models with ≥4k context"
      )
      compatibilityCache[cacheKey] = info
      return info
    }

    if ctxWindowTokens > 0 && ctxWindowTokens > Double(model.ctxWindow) {
      let info = CompatibilityInfo(isCompatible: false, incompatibilitySummary: nil)
      compatibilityCache[cacheKey] = info
      return info
    }

    let sysMem = Catalog.systemMemoryMb
    let estimatedMemoryUsageMb = runtimeMemoryUsage(
      for: model, ctxWindowTokens: ctxWindowTokens)

    func memoryRequirementSummary() -> String {
      let memoryFraction = availableMemoryFraction(forSystemMemoryMb: sysMem)
      let requiredTotalMb = UInt64(ceil(Double(estimatedMemoryUsageMb) / memoryFraction))
      let gb = ceil(Double(requiredTotalMb) / 1024.0)
      return String(format: "requires %.0f GB+ of memory", gb)
    }

    guard sysMem > 0 else {
      let info = CompatibilityInfo(
        isCompatible: false,
        incompatibilitySummary: memoryRequirementSummary()
      )
      compatibilityCache[cacheKey] = info
      return info
    }

    let budgetMb = memoryBudget(systemMemoryMb: sysMem)
    let isCompatible = estimatedMemoryUsageMb <= UInt64(budgetMb)

    let info = CompatibilityInfo(
      isCompatible: isCompatible,
      incompatibilitySummary: isCompatible ? nil : memoryRequirementSummary()
    )
    compatibilityCache[cacheKey] = info
    return info
  }

}
