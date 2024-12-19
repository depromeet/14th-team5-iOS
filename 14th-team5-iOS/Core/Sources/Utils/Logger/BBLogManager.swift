//
//  BBLogManager.swift
//  Core
//
//  Created by 김도현 on 12/12/24.
//

import FirebaseCrashlytics
import FirebaseAnalytics


public enum BBLogManager {
    
    public static func setMemberId(
        memberId: String,
        function: String = #function,
        fileName: String = #file
    ) {
        Crashlytics.crashlytics().setUserID(memberId)
        Analytics.setUserID(memberId)
        
        BBLogger.logDebug(
            function: function,
            fileName: fileName,
            category: "Analytics",
            message: "Firebase 멤버 ID 설정"
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

