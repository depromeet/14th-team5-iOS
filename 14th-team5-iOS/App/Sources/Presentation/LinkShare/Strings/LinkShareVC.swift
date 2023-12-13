//
//  LinkShareVC.swift
//  App
//
//  Created by 김건우 on 12/11/23.
//

import Foundation

enum LinkShareVC {
    enum Strings {
        static let navgationTitle: String = "가족"
        
        static let shareTitle: String = "가족을 초대하고 뭘 하고 있는지 확인하세요"
        static let kakaoTalkButtonTitle: String = "카카오톡"
        static let messageButtonTitle: String = "메시지"
        static let instagramButtonTitle: String = "인스타그램"
        static let moreButtonTitle: String = "더보기"
        static let copyShareLinkButtonTitle: String = "초대 링크 복사"
        
        static let familyTableHeader: String = "당신의 가족"
        
        static let successCopyInvitationUrlToPastboard: String = "링크가 복사되었습니다."
    }
    
    enum AutoLayout {
        static let defaultOffsetValue: CGFloat = 16.0
        static let shareViewTopOffsetValue: CGFloat = 8.0
        static let shareViewHeightValue: CGFloat = 140.0
        
        static let shareTitleLabelTopOffsetValue: CGFloat = 16.0

        static let copyShareLinkButtonHeight: CGFloat = 50.0
    }
    
    enum Attribute {
        static let shareViewCornerRadius: CGFloat = 10.0
        static let shareTitleFontSize: CGFloat = 16.0
        static let copyShareLinkButtonFontSize: CGFloat = 16.0
        
        static let tableHeaderFontSize: CGFloat = 20.0
    }
}
