//
//  CheckSurvivalTimeUseCase.swift
//  Domain
//
//  Created by 마경미 on 30.09.24.
//

import Foundation

public protocol CheckSurvivalTimeUseCaseProtocol {
    func execute() -> (isIntime: Bool, remainTIme: Int)
}

public final class CheckSurvivalTimeUseCase: CheckSurvivalTimeUseCaseProtocol {
    public func execute() -> (isIntime: Bool, remainTIme: Int) {
        let calendar = Calendar.current
        let currentTime = Date()
        
        let currentHour = calendar.component(.hour, from: currentTime)
        
        if currentHour >= 10 {
            if let nextMidnight = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: currentTime.addingTimeInterval(24 * 60 * 60)) {
                let timeDifference = calendar.dateComponents([.second], from: currentTime, to: nextMidnight)
                return (true, max(0, timeDifference.second ?? 0))
            }
        } else {
            if let nextMidnight = calendar.date(bySettingHour: 12, minute: 0, second: 0, of: currentTime) {
                let timeDifference = calendar.dateComponents([.second], from: currentTime, to: nextMidnight)
                return (false, max(0, timeDifference.second ?? 0))
            }
        }
        
        return (false, 1000)
    }
}
