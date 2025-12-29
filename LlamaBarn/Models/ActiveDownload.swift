import Foundation

/// Tracks the progress of a multi-file model download.
struct ActiveDownload {
  let model: CatalogEntry
  var progress: Progress
  var tasks: [Int: URLSessionDownloadTask]
  var completedFilesBytes: Int64 = 0

  mutating func addTask(_ task: URLSessionDownloadTask) {
    tasks[task.taskIdentifier] = task
    refreshProgress()
  }

  mutating func removeTask(with identifier: Int) {
    tasks.removeValue(forKey: identifier)
    refreshProgress()
  }

  mutating func markTaskFinished(_ task: URLSessionDownloadTask, fileSize: Int64) {
    tasks.removeValue(forKey: task.taskIdentifier)
    completedFilesBytes += fileSize
    refreshProgress()
  }

  mutating func refreshProgress() {
    // Calculate both active and expected bytes in a single pass.
    // Called on every didWriteData callback (even with throttling, this is still 10x/sec per download),
    // so avoiding redundant iterations over tasks.values is important for responsiveness.
    var activeBytes: Int64 = 0
    var expectedActiveBytes: Int64 = 0

    for task in tasks.values {
      let received = task.countOfBytesReceived
      activeBytes += received
      let expected = task.countOfBytesExpectedToReceive
      expectedActiveBytes += expected > 0 ? expected : received
    }

    let totalCompleted = completedFilesBytes + activeBytes
    let totalExpected = max(progress.totalUnitCount, completedFilesBytes + expectedActiveBytes)
    progress.totalUnitCount = max(totalExpected, 1)
    progress.completedUnitCount = totalCompleted
  }

  var isEmpty: Bool { tasks.isEmpty }
}
