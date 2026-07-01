import AppKit

/// A slim, subtle horizontal progress bar used on downloading model rows.
/// Replaces the inline "42%" text: keeping progress in a fixed-width bar on the
/// right lets the row's size-on-disk readout stay put on the left instead of
/// shifting to make room for a percentage that grows/shrinks as it counts up.
///
/// Drawn with two layers — a full-width rounded track and a fill sublayer whose
/// width is a fraction of the track. Both colors are resolved for the current
/// appearance so the bar adapts to light/dark like the rest of the menu.
final class ProgressBarView: NSView {
  /// Fixed footprint. Narrow and short so it reads as an accent, not a control;
  /// the capsule radius is half the height so the ends are fully rounded.
  static let barWidth: CGFloat = 44
  static let barHeight: CGFloat = 4

  private let fillLayer = CALayer()

  /// Current progress in 0...1. Clamped on set; drives the fill layer's width.
  var fraction: Double = 0 {
    didSet { needsLayout = true }
  }

  override init(frame frameRect: NSRect) {
    super.init(frame: frameRect)
    wantsLayer = true
    // The view's own layer is the track; the fill rides on top of it.
    layer?.cornerRadius = Self.barHeight / 2
    fillLayer.cornerRadius = Self.barHeight / 2
    layer?.addSublayer(fillLayer)
    applyColors()

    translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      widthAnchor.constraint(equalToConstant: Self.barWidth),
      heightAnchor.constraint(equalToConstant: Self.barHeight),
    ])
  }

  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

  override func layout() {
    super.layout()
    // Position the fill within the track. Disable the implicit animation so the
    // bar snaps to each progress sample rather than lagging behind with a fade.
    CATransaction.begin()
    CATransaction.setDisableActions(true)
    let clamped = CGFloat(max(0, min(1, fraction)))
    // Floor the fill at its own height so it's never a bare track: at ~0% the
    // capsule collapses to a dot, reading as "a progress bar just starting"
    // rather than an empty rectangle.
    let width = max(bounds.height, bounds.width * clamped)
    fillLayer.frame = CGRect(x: 0, y: 0, width: width, height: bounds.height)
    CATransaction.commit()
  }

  override func viewDidChangeEffectiveAppearance() {
    super.viewDidChangeEffectiveAppearance()
    applyColors()
  }

  /// Track and fill both use existing subtle theme colors so the bar sits quietly
  /// in the row: a faint track (same weight as the highlight background) with a
  /// secondary-text fill that's visible without competing with the model name.
  private func applyColors() {
    layer?.setBackgroundColor(Theme.Colors.subtleBackground, in: self)
    fillLayer.setBackgroundColor(Theme.Colors.textSecondary, in: self)
  }
}
