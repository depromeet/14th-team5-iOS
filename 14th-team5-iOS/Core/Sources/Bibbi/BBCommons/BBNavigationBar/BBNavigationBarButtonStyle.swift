//
//  BBNavigationBarButtonStyle.swift
//  Core
//
//  Created by 김건우 on 6/5/24.
//

import DesignSystem
import UIKit


// MARK: - Typealias

public typealias BBNavigationTitleStyle = BBNavigationBar.Style.Title
public typealias BBNavigationButtonStyle = BBNavigationBar.Style.Button


// MARK: - Extensions

extension BBNavigationBar {
    
    public enum Style {
        
        public enum Title {
            case bibbi
        }
        
        public enum Button {
            @available(*, deprecated, renamed: "person")
            case addPerson
            
            case person(new: Bool)
            case arrowLeft
            case refresh
            case calendar
            case setting
            case xmark
        }
        
    }
    
}

extension BBNavigationTitleStyle {
    
    var image: UIImage? {
        switch self {
        case .bibbi:
            return DesignSystemAsset.bibbiLogo.image
        }
    }
    
}

extension BBNavigationButtonStyle {
    
    var image: UIImage? {
        switch self {
        case .addPerson, .person:
            return DesignSystemAsset.addPerson.image
        case .arrowLeft:
            return DesignSystemAsset.arrowLeft.image
        case .refresh:
            return DesignSystemAsset.familyNameChange.image
        case .calendar:
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


extension BBNavigationTitleStyle: Equatable { }

extension BBNavigationButtonStyle: Equatable { }
