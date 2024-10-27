//
//  BBToolTipType.swift
//  Core
//
//  Created by Kim dohyun on 9/19/24.
//

import UIKit

import DesignSystem

/// BBToolTip의 Style을 설정하기 위한  Nested types입니다.
/// 해당 **BBToolTipType** 을 통해 BBToolTip의 Layout을 구성합니다.
public enum BBToolTipType: Equatable {
    /// 홈 화면 inactive Camera Button State ToolTip Type
    case inactiveCameraTime
    /// 홈 화면 active Camera Button State ToolTip Type
    case activeCameraTime
    /// 가족 방 화면 Family Name Setting ToolTip Type
    case familyNameEdit
    /// 홈 화면 생존 신고 이전 Mission Camera Button inactive State Tool Tip
    case inactiveSurvivalCameraNoUpload
    /// 홈 화면 미션 이미지 업로드 이후 Camera Button inactive State Tool Tip
    case inactiveMissionCameraPostUpload
    /// 홈 화면 inactive Mission Camera Button State Tool Tip
    case inactiveMissionCamera
    /// 홈 화면 active Mission Camera Button State Tool Tip
    case activeMissionCamera
    /// 컨트리뷰터 화면 Description Button Touch Tool Tip
    case contributor
    /// 추억 캘린더 화면 Description Button Touch Tool Tip
    case monthlyCalendar
    /// 홈 화면 생존 신고 알림 Tool Tip
    case waitingSurvivalImage(contentText: String, imageURL:[URL])
    
    
    var xPosition: BBToolTipHorizontalPosition {
        switch self {
        case .monthlyCalendar, .contributor:
            return .midLeft
        case .familyNameEdit:
            return .right
        default:
            return .center
        }
    }
    
    
    var configure: BBToolTipConfiguration {
        switch self {
        case .inactiveCameraTime:
            return .init(
                foregroundColor: .bibbiWhite,
                backgroundColor: .gray700,
                yPosition: .bottom,
                xPosition: .center,
                contentText: "오늘의 생존신고는 완료되었어요"
            )
        case .activeCameraTime:
            return .init(
                foregroundColor: .bibbiWhite,
                backgroundColor: .gray700,
                yPosition: .bottom,
                xPosition: .center,
                contentText: "하루에 한 번 사진을 올릴 수 있어요"
            )
        case .familyNameEdit:
            return .init(
                foregroundColor: .bibbiBlack,
                backgroundColor: .mainYellow,
                yPosition: .bottom,
                xPosition: .right,
                contentText: "가족 방 이름을 변경해보세요!"
            )
        case .inactiveSurvivalCameraNoUpload:
            return .init(
                foregroundColor: .bibbiWhite,
                backgroundColor: .gray700,
                yPosition: .bottom,
                xPosition: .center,
                contentText: "생존신고 후 미션 사진을 올릴 수 있어요"
            )
        case .inactiveMissionCameraPostUpload:
            return .init(
                foregroundColor: .bibbiWhite,
                backgroundColor: .gray700,
                yPosition: .bottom,
                xPosition: .center,
                contentText: "오늘의 미션은 완료되었어요"
            )
        case .inactiveMissionCamera:
            return .init(
                foregroundColor: .bibbiWhite,
                backgroundColor: .gray700,
                yPosition: .bottom,
                xPosition: .center,
                contentText: "아직 미션 사진을 찍을 수 없어요"
            )
        case .activeMissionCamera:
            return .init(
                foregroundColor: .bibbiWhite,
                backgroundColor: .gray700,
                yPosition: .bottom,
                xPosition: .center,
                contentText: "미션 사진을 찍으러 가볼까요?"
            )
        case .contributor:
            return .init(
                foregroundColor: .bibbiWhite,
                backgroundColor: .gray700,
                yPosition: .top,
                xPosition: .midLeft,
                contentText: "생존신고 횟수가 동일한 경우\n이모지, 댓글 수를 합산해서 등수를 정해요"
            )
        case .monthlyCalendar:
            return .init(
                foregroundColor: .bibbiWhite,
                backgroundColor: .gray700,
                yPosition: .top,
                xPosition: .midLeft,
                contentText: "모두가 참여한 날과 업로드한 사진 수로\n이 달의 친밀도를 측정합니다"
            )
        case let .waitingSurvivalImage(contentText, profile):
            return .init(
                foregroundColor: .bibbiBlack,
                backgroundColor: .mainYellow,
                yPosition: .bottom,
                xPosition: .center,
                contentText: "\(contentText)님 외 \(profile.count - 1)명이 기다리고 있어요"
            )
        }
    }
}
