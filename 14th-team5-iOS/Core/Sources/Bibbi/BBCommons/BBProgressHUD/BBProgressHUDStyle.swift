//
//  BBProgressHUDStyle.swift
//  Core
//
//  Created by 김건우 on 8/16/24.
//

import UIKit

// MARK: - Typealias

public typealias BBProgressHUDStyle = BBProgressHUD.Style


// MARK: - Extensions

extension BBProgressHUD {
    
    public enum Style {
        case airplane
        case airplaneWithTitle(
            title: String? = "열심히 불러오는 중..",
            titleFontStyle: BBFontStyle? = .body1Regular,
            titleColor: UIColor? = .gray400
        )
    }
    
}
