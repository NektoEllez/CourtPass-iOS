import Foundation
import os.log

enum LogLevel: String, CaseIterable {
    case debug = "🔍 DEBUG"
    case info = "ℹ️ INFO"
    case warning = "⚠️ WARNING"
    case error = "❌ ERROR"
    case critical = "🚨 CRITICAL"
    
    var osLogType: OSLogType {
        switch self {
        case .debug: return .debug
        case .info: return .info
        case .warning: return .default
        case .error: return .error
        case .critical: return .fault
        }
    }
}

protocol Logging {
    func debug(_ message: String, category: LogCategory, file: String, function: String, line: Int)
    func info(_ message: String, category: LogCategory, file: String, function: String, line: Int)
    func warning(_ message: String, category: LogCategory, file: String, function: String, line: Int)
    func error(_ message: String, category: LogCategory, file: String, function: String, line: Int)
    func critical(_ message: String, category: LogCategory, file: String, function: String, line: Int)
}

enum LogCategory: String, CaseIterable {
    case network = "Network"
    case ui = "UI"
    case auth = "Auth"
    case search = "Search"
    case filters = "Filters"
    case session = "Session"
    case general = "General"
    
    var subsystem: String {
        return "com.courtai.app"
    }
}

final class AppLogger: Logging {
    static let shared = AppLogger()
    
    private var loggers: [LogCategory: os.Logger] = [:]
    
    #if DEBUG
    private let isLoggingEnabled = true
    #else
    private let isLoggingEnabled = false
    #endif
    
    private init() {
        setupLoggers()
    }
    
    private func setupLoggers() {
        for category in LogCategory.allCases {
            loggers[category] = os.Logger(subsystem: category.subsystem, category: category.rawValue)
        }
    }
    
    private func log(_ level: LogLevel, _ message: String, category: LogCategory, file: String, function: String, line: Int) {
        guard isLoggingEnabled else { return }
        
        let logger = loggers[category] ?? os.Logger(subsystem: category.subsystem, category: category.rawValue)
        let fileName = (file as NSString).lastPathComponent
        let logMessage = "\(level.rawValue) [\(fileName):\(line)] \(function) - \(message)"
        
        logger.log(level: level.osLogType, "\(logMessage)")
    }
    
    func debug(_ message: String, category: LogCategory = .general, file: String = #file, function: String = #function, line: Int = #line) {
        log(.debug, message, category: category, file: file, function: function, line: line)
    }
    
    func info(_ message: String, category: LogCategory = .general, file: String = #file, function: String = #function, line: Int = #line) {
        log(.info, message, category: category, file: file, function: function, line: line)
    }
    
    func warning(_ message: String, category: LogCategory = .general, file: String = #file, function: String = #function, line: Int = #line) {
        log(.warning, message, category: category, file: file, function: function, line: line)
    }
    
    func error(_ message: String, category: LogCategory = .general, file: String = #file, function: String = #function, line: Int = #line) {
        log(.error, message, category: category, file: file, function: function, line: line)
    }
    
    func critical(_ message: String, category: LogCategory = .general, file: String = #file, function: String = #function, line: Int = #line) {
        log(.critical, message, category: category, file: file, function: function, line: line)
    }
}

extension AppLogger {
    static func debug(_ message: String, category: LogCategory = .general, file: String = #file, function: String = #function, line: Int = #line) {
        shared.debug(message, category: category, file: file, function: function, line: line)
    }
    
    static func info(_ message: String, category: LogCategory = .general, file: String = #file, function: String = #function, line: Int = #line) {
        shared.info(message, category: category, file: file, function: function, line: line)
    }
    
    static func warning(_ message: String, category: LogCategory = .general, file: String = #file, function: String = #function, line: Int = #line) {
        shared.warning(message, category: category, file: file, function: function, line: line)
    }
    
    static func error(_ message: String, category: LogCategory = .general, file: String = #file, function: String = #function, line: Int = #line) {
        shared.error(message, category: category, file: file, function: function, line: line)
    }
    
    static func critical(_ message: String, category: LogCategory = .general, file: String = #file, function: String = #function, line: Int = #line) {
        shared.critical(message, category: category, file: file, function: function, line: line)
    }
}

extension AppLogger {
    static func logError(_ error: Error, message: String = "Error occurred", category: LogCategory = .general, file: String = #file, function: String = #function, line: Int = #line) {
        shared.error("\(message): \(error.localizedDescription)", category: category, file: file, function: function, line: line)
    }
    
    static func logPerformance<T>(_ operationName: String, category: LogCategory = .general, operation: () throws -> T) rethrows -> T {
        let startTime = CFAbsoluteTimeGetCurrent()
        let result = try operation()
        let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
        shared.debug("\(operationName) took \(String(format: "%.3f", timeElapsed))s", category: category)
        return result
    }
    
    static func logAsyncPerformance<T>(_ operationName: String, category: LogCategory = .general, operation: () async throws -> T) async rethrows -> T {
        let startTime = CFAbsoluteTimeGetCurrent()
        let result = try await operation()
        let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
        shared.debug("\(operationName) took \(String(format: "%.3f", timeElapsed))s", category: category)
        return result
    }
}
