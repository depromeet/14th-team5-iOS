//
//  TimerModel.swift
//  App
//
//  Created by 마경미 on 18.12.23.
//

import Foundation

enum TimerStatus {
    /// 12:00AM ~ 12:00PM
    case beforeNoon
    /// 12:00PM ~ 12:00AM
    case afterNoon
    /// 가족 모두가 참여한 날
    case allUploaded
    /// 마감 1시간 전
    case oneHourLeft
}
