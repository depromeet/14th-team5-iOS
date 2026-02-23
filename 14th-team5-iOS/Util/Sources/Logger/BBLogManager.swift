//
//  BBLogManager.swift
//  Core
//
//  Created by 김도현 on 12/12/24.
//

import Foundation
import FirebaseAnalytics
import FirebaseCrashlytics

// MARK: - Log Types

public struct BBUploadSuccessLog: BBAnalyticsLogType {
    public var name: String = "image_upload_success"
    public var params: [String: Any]?
    
    public init(imageSize: Int, duration: TimeInterval) {
        self.params = [
            "image_size_bytes": imageSize,
            "image_size_mb": Double(imageSize) / 1024.0 / 1024.0,
            "duration_seconds": duration,
            "upload_speed_mbps": Double(imageSize * 8) / duration / 1_000_000
        ]
    }
}

public struct BBUploadFailureLog: BBAnalyticsLogType {
    public var name: String = "image_upload_failure"
    public var params: [String: Any]?
    
    public init(errorCode: Int, imageSize: Int, duration: TimeInterval) {
        self.params = [
            "error_code": errorCode,
            "image_size_bytes": imageSize,
            "duration_seconds": duration
        ]
    }
}

public struct BBUploadRetryLog: BBAnalyticsLogType {
    public var name: String = "image_upload_retry"
    public var params: [String: Any]?
    
    public init(attempt: Int, maxRetries: Int, errorCode: Int) {
        self.params = [
            "attempt": attempt,
            "max_retries": maxRetries,
            "error_code": errorCode
        ]
    }
}

public struct BBImageCompressionLog: BBAnalyticsLogType {
    public var name: String = "image_compression"
    public var params: [String: Any]?
    
    public init(originalSize: Int, compressedSize: Int, duration: TimeInterval) {
        let ratio = Double(compressedSize) / Double(originalSize)
        self.params = [
            "original_size_mb": Double(originalSize) / 1024.0 / 1024.0,
            "compressed_size_mb": Double(compressedSize) / 1024.0 / 1024.0,
            "compression_ratio": ratio,
            "size_reduction_percent": (1.0 - ratio) * 100,
            "duration_seconds": duration
        ]
    }
}

// MARK: - BBLogManager

public enum BBLogManager {
    
    public static func setMemberId(
        _ memberId: String,
        function: String = #function,
        fileName: String = #file
    ) {
        Crashlytics.crashlytics().setUserID(memberId)
        Analytics.setUserID(memberId)
        
        BBLogger.logDebug(
            function: function,
            fileName: fileName,
            category: "Analytics",
            message: "Firebase 멤버 ID 설정: \(memberId)"
        )
    }
    
    public static func analytics(
        logType: any BBAnalyticsLogType
    ) {
        Analytics.logEvent(logType.name, parameters: logType.params)
    }
    
    public static func sendError(
        message: String,
        function: String = #function,
        fileName: String = #file
    ) {
        Crashlytics.crashlytics().log(message)
        
        BBLogger.logError(
            function: function,
            fileName: fileName,
            category: "Analytics Error",
            message: message
        )
    }
    
    public static func sendError(
        error: any Error,
        function: String = #function,
        fileName: String = #file
    ) {
        Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(true)
        Crashlytics.crashlytics().record(error: error)
        
        BBLogger.logError(
            function: function,
            fileName: fileName,
            category: "Analytics Error",
            message: error.localizedDescription
        )
    }
}

