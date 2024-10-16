//
//  BBLogger.swift
//  Core
//
//  Created by 김도현 on 10/16/24.
//

import Foundation
import os

import RxSwift

/// LogLevel은 **OSLogType** 기준으로 정의를 했습니다.
/// 해당 **LogLevel** 을 통해서 BBLogger의  출력 메세지를 지정 할 수 있습니다.
private enum LogLevel {
    /// 일반적인 정보를 조회할 때 사용하는 Type
    /// ex) 네트워크 요청 시 Response 값 조회
    case info
    /// 코드 디버깅할 때 사용하는 Type
    case debug
    /// 경고 오류가 발생했을 때 사용하는 Type
    case error
    /// 크래시를 유발하는 오류 나타낼 때 사용하는 Type
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
    /// 일반적인 정보를 조회할때 사용하는 메서드 입니다.
    /// - Parameters:
    ///   - function: logInfo 메서드를 호출한 함수명
    ///   - fileName: logInfo 메서드를 호출한 파일명
    ///   - category: 로그의 카테고리 예) "Network", "UI", "UseCase",
    ///   - message:  로그 메세지
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
    
    /// 코드 디버깅할때 사용하는 메서드 입니다..
    /// - Parameters:
    ///   - function: logInfo 메서드를 호출한 함수명
    ///   - fileName: logInfo 메서드를 호출한 파일명
    ///   - category: 로그의 카테고리 예) "Network", "UI", "UseCase",
    ///   - message:  로그 메세지
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
   
    /// 경고 오류를 기록 및 추적할 때 사용하는 메서드입니다.
    /// - Parameters:
    ///   - function: logInfo 메서드를 호출한 함수명
    ///   - fileName: logInfo 메서드를 호출한 파일명
    ///   - category: 로그의 카테고리 예) "Network", "UI", "UseCase",
    ///   - message:  로그 메세지
    public static func logError(
        function: String = #function,
        fileName: String = #file,
        category: String = "",
        message: String = ""
    ) {
        guard let bundleId = Bundle.main.bundleIdentifier else {
            fatalError("Bundle ID value not found")
        }
        
        let errorMessage = createLoggerMessage(
            level: LogLevel.error,
            message: message,
            function: function,
            fileName: fileName
        )
        
        Logger(subsystem: bundleId, category: category)
            .error("\(errorMessage)")
    }
    
    /// 크래시 오류를 추적 및 기록할 때 사용하는 메서드입니다.
    /// - Parameters:
    ///   - function: logInfo 메서드를 호출한 함수명
    ///   - fileName: logInfo 메서드를 호출한 파일명
    ///   - category: 로그의 카테고리 예) "Network", "UI", "UseCase",
    ///   - message:  로그 메세지
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
    
    /// 로그 메서드 내부 출력 구문을 생성하기 위한 메서드입니다.
    /// - Parameters:
    ///   - level: LogLevel Type
    ///   - message: 로그 메세지
    ///   - function: logInfo 메서드를 호출한 함수명
    ///   - fileName: logInfo 메서드를 호출한 파일명
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
    /// RxSwift에서 제공되는. debug 연산자와 동일하게 element를 로깅 하는 연산자입니다.
    /// 해당 연산자를 통해서 BBLogger를 사용하여 로깅을 할 수 있습니다.
    /// - Parameters:
    ///    - category: 로그의 카테고리 예) "Network", "UI", "UseCase",
    public func log(_ category: String) -> Observable<Element> {
        return self.do(onNext: { element in
            BBLogger.logDebug(category: category, message: "\(element)")
        })
    }
}
