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
        case newBibbi
    }
    
    enum TopBarButtonStyle {
        case addPerson
        case arrowLeft
        case heartCalendar
        case setting
        case xmark
    }
    
}

extension TitleStyle {
    
    var image: UIImage? {
        switch self {
        case .bibbi:
            return DesignSystemAsset.bibbiLogo.image
        case .newBibbi:
            return DesignSystemAsset.bibbiLogo.image
        }
    }
    
}

extension TopBarButtonStyle {
    
    var barButtonImage: UIImage? {
        switch self {
        case .addPerson:
            return DesignSystemAsset.addPerson.image
        case .arrowLeft:
            return UIImage(systemName: "chevron.backward")
        case .heartCalendar:
            return DesignSystemAsset.heartCalendar.image
        case .setting:
            return DesignSystemAsset.setting.image
        case .xmark:
            return DesignSystemAsset.xmark.image
        }
    }
    
}
