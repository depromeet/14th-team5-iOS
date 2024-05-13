//
//  BalloonText.swift
//  App
//
//  Created by 마경미 on 11.05.24.
//

import Foundation

import Domain

enum BalloonType: Equatable {
    static func == (lhs: BalloonType, rhs: BalloonType) -> Bool {
        switch (lhs, rhs) {
        case (.normal, .normal):
            return true
        case (.picks, .picks):
            return true
        default:
            return false
        }
    }
    
    case normal
    case picks([Picker])
}

enum BalloonText {
    case survivalStandard
    case survivalDone
    case missionLocked
    case cantMission
    case canMission
    case missionDone
    case picker(Picker)
    case pickers([Picker])
    
    var message: String {
        switch self {
        case .survivalStandard:
            return "하루에 한 번 사진을 올릴 수 있어요"
        case .survivalDone:
            return "오늘의 생존신고는 완료되었어요"
        case .missionLocked:
            return "아직 미션 사진을 찍을 수 없어요"
        case .cantMission:
            return "생존신고 후 미션 사진을 올릴 수 있어요"
        case .canMission:
            return "미션 사진을 찍으러 가볼까요?"
        case .missionDone:
            return "오늘의 미션은 완료되었어요"
        case .picker(let picker):
            return "\(picker.displayName)님이 기다리고 있어요"
        case .pickers(let pickers):
            return "\(pickers.first?.displayName ?? "알 수 없음")님 외 \(pickers.count - 1)명이 기다리고 있어요"
        }
    }
    
    var balloonType: BalloonType {
        switch self {
        case .picker(let picker): return .picks([picker])
        case .pickers(let pickers): return .picks(pickers)
        default: return .normal
        }
    }
}
