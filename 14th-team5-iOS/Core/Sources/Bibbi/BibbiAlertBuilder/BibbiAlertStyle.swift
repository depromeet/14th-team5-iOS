//
//  BibbiAlertStyle.swift
//  Core
//
//  Created by 김건우 on 4/18/24.
//

import DesignSystem
import UIKit

public enum BibbiAlertStyle {
    case missionKey
    case takeSurvival
    case pickMember(String)
    
    var mainTitle: String {
        switch self {
        case .missionKey:
            return "미션 열쇠 획득!"
        case .takeSurvival:
            return "생존신고 사진을 먼저 찍으세요!"
        case .pickMember:
            return "생존 확인하기"
        }
    }
    
    var subTitle: String {
        switch self {
        case .missionKey:
            return "열쇠를 획득해 잠금이 해제되었어요.\n미션 사진을 찍을 수 있어요!"
        case .takeSurvival:
            return "미션 사진을 올리려면\n생존신고 사진을 먼저 업로드해야해요."
        case let .pickMember(name):
            return "\(name)님의 생존 여부를 물어볼까요?\n지금 알림이 전송됩니다."
        }
    }
    
    var image: UIImage {
        switch self {
        case .missionKey:
            return DesignSystemAsset.missionKeyGraphic.image
        case .takeSurvival:
            return DesignSystemAsset.takeSurvivalGraphic.image
        case .pickMember:
            return DesignSystemAsset.exhaustedBibbiGraphic.image
        }
    }
    
    var confirmText: String {
        switch self {
        case .missionKey:
            return "미션 사진 찍기"
        case .takeSurvival:
            return "생존신고 먼저 하기"
        case .pickMember:
            return "지금 하기"
        }
    }
    
    var cancelText: String {
        switch self {
        case .missionKey:
            return "닫기"
        case .takeSurvival:
            return "다음에 하기"
        case .pickMember:
            return "다음에 하기"
        }
    }
}
