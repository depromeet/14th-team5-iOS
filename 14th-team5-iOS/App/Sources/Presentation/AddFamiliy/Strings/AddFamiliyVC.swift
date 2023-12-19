//
//  LinkShareVC.swift
//  App
//
//  Created by 김건우 on 12/11/23.
//

import UIKit

enum AddFamiliyVC {
    enum Strings {
        static let navgationTitle: String = "가족"
        static let addFamiliyTitle: String = "초대 링크 복사"
        static let addFamiliySubTitle: String = "bibbi.com"
        static let tableTitle: String = "당신의 가족"
        static let tableSubTitle: String = "0"
        static let successCopyInvitationUrl: String = "링크가 복사되었어요"
    }
    
    enum AutoLayout {
        static let defaultOffsetValue: CGFloat = 16.0
        static let backgroundViewTopOffsetValue: CGFloat = 8.0
        static let backgroundViewHeightValue: CGFloat = 90.0
        static let imageBackgroundViewHeightValue: CGFloat = 50.0
        static let envelopeImageViewHeightValue: CGFloat = 20.0
        static let shareInvitationUrlButtonTrailingOffsetValue: CGFloat = 24.0
        static let dividerViewTopOffsetValue: CGFloat = 24.0
        static let tableHeaderStackViewTopOffsetValue: CGFloat = 28.0
        static let tableViewTopOffsetValue: CGFloat = 8.0
    }
    
    enum Attribute {
        static let backgroundViewCornerRadius: CGFloat = 20.0
        static let addFamiliyTitleFontSize: CGFloat = 20.0
        static let addFamiliySubTitleFontSize: CGFloat = 14.0
        
        static let tableHeaderTitleFontSize: CGFloat = 24.0
        static let tableHeaderCountFontSize: CGFloat = 16.0
        static let tableContentInset: UIEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
    }
}
