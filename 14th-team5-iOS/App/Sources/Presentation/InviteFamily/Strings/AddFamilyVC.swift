//
//  LinkShareVC.swift
//  App
//
//  Created by 김건우 on 12/11/23.
//

import UIKit

enum AddFamilyVC {
    enum Strings {
        static let navgationTitle: String = "가족"
        static let addFamilyTitle: String = "삐삐에 가족 초대하기"
        static let invitationUrlText: String = "https://no5ing.kr/"
        static let tableTitle: String = "당신의 가족"
        static let tableSubTitle: String = "0"
        static let successCopyInvitationUrl: String = "링크가 복사되었어요"
    }
    
    enum AutoLayout {
        static let defaultOffsetValue: CGFloat = 16.0
        static let backgroundViewTopOffsetValue: CGFloat = 8.0
        static let backgroundViewHeightValue: CGFloat = 90.0
        static let imageBackgroundViewHeightValue: CGFloat = 50.0
        static let envelopeImageViewHeightValue: CGFloat = 28.0
        static let shareInvitationUrlButtonTrailingOffsetValue: CGFloat = 24.0
        static let dividerViewTopOffsetValue: CGFloat = 24.0
        static let tableHeaderStackViewTopOffsetValue: CGFloat = 28.0
        static let tableViewTopOffsetValue: CGFloat = 8.0
    }
    
    enum Attribute {
        static let backgroundViewCornerRadius: CGFloat = 16.0
        static let invitationTitleFontSize: CGFloat = 19.0
        static let invitationUrlFontSize: CGFloat = 14.0
        
        static let tableTitleFontSize: CGFloat = 24.0
        static let tableCountFontSize: CGFloat = 16.0
        static let tableContentInset: UIEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
    }
}
