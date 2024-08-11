//
//  BBNavigationBarButtonStyle.swift
//  Core
//
//  Created by 김건우 on 6/5/24.
//

import DesignSystem
import UIKit


// MARK: - Typealias

public typealias TitleStyle = BBNavigationBarView.TitleStyle
public typealias TopBarButtonStyle = BBNavigationBarView.TopBarButtonStyle


// MARK: - Extensions

public extension BBNavigationBarView {
    
    enum TitleStyle {
        case bibbi
    }
    
    enum TopBarButtonStyle {
        case addPerson
        case arrowLeft
        case change
        case heartCalendar
        case setting
        case xmark
        case none
    }
    
}

extension TitleStyle {
    
    var image: UIImage? {
        switch self {
        case .bibbi:
            return DesignSystemAsset.bibbiLogo.image
        }
    }
    
}

extension TopBarButtonStyle {
    
    var image: UIImage? {
        switch self {
        case .addPerson:
            return DesignSystemAsset.addPerson.image
        case .arrowLeft:
            return DesignSystemAsset.arrowLeft.image
        case .change:
            return DesignSystemAsset.familyNameChange.image
        case .heartCalendar:
            return DesignSystemAsset.heartCalendar.image
        case .setting:
            return DesignSystemAsset.setting.image
        case .xmark:
            return DesignSystemAsset.xmark.image
        @unknown default:
            return nil
        }
    }
    
}
