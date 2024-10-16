//
//  BBLogger.swift
//  Core
//
//  Created by 김도현 on 10/16/24.
//

import Foundation
import os

import RxSwift


private enum LogLevel {
    case info
    case debug
    case error
    case fault
    
    
    var label: String {
        switch self {
        case .info: return "[INFO ⚪]"
        case .debug: return "[DEBUG 🟢]"
        case .error: return "[ERROR 🟠]"
        case .fault: return "[FAULT 🔴]"
        }
    }
}


public struct BBLogger {
    public static func logInfo(
        function: String = #function,
        fileName: String = #file,
        category: String = "",
        message: String = ""
    ) {
        guard let bundleId = Bundle.main.bundleIdentifier else {
            fatalError("Bundle ID value not found")
        }
        
        let infotMessage = createLoggerMessage(
            level: LogLevel.info,
            message: message,
            function: function,
            fileName: fileName
        )
        
        Logger(subsystem: bundleId, category: category)
            .info("\(infotMessage)")
    }
    
    
    public static func logDebug(
        function: String = #function,
        fileName: String = #file,
        category: String = "",
        message: String = ""
    ) {
        
        guard let bundleId = Bundle.main.bundleIdentifier else {
            fatalError("Bundle ID value not found")
        }
        
        let debugMessage = createLoggerMessage(
            level: LogLevel.debug,
            message: message,
            function: function,
            fileName: fileName
        )
        
        Logger(subsystem: bundleId, category: category)
            .debug("\(debugMessage)")
    
    }
    
    
    public static func logError(
        function: String = #function,
        fileName: String = #file,
        category: String = "",
        message: String = ""
    ) {
        guard let bundleId = Bundle.main.bundleIdentifier else {
            fatalError("Bundle ID value not found")
        }
        
        let errortMessage = createLoggerMessage(
            level: LogLevel.error,
            message: message,
            function: function,
            fileName: fileName
        )
        
        Logger(subsystem: bundleId, category: category)
            .error("\(errortMessage)")
    }
    
    public static func logFault(
        function: String = #function,
        fileName: String = #file,
        category: String = "",
        message: String = ""
    ) {
        guard let bundleId = Bundle.main.bundleIdentifier else {
            fatalError("Bundle ID value not found")
        }
        
        let faultMessage = createLoggerMessage(
            level: LogLevel.fault,
            message: message,
            function: function,
            fileName: fileName
        )
        
        Logger(subsystem: bundleId, category: category)
            .fault("\(faultMessage)")
    }
}


extension BBLogger {
    
    private static func createLoggerMessage(
        level: LogLevel,
        message: String,
        function: String = #function,
        fileName: String = #file
    ) -> String {
        
        let timestamp: String = "🕖 \(Date().toFormatString(with: .ahhmmss))"
        let functionName: String = "#️⃣ \(function)"
        let filename: String = URL(fileURLWithPath: fileName).lastPathComponent
        let message: String = "\n\(message)"
        
        return Array(arrayLiteral: level.label, timestamp, filename, functionName, message).joined(separator: "|")
    }
}



extension ObservableType {
    public func log(_ category: String) -> Observable<Element> {
        return self.do(onNext: { element in
            BBLogger.logDebug(category: category, message: "\(element)")
        })
    }
}
