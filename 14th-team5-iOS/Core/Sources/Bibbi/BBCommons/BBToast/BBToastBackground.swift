//
//  Background.swift
//  BBToast
//
//  Created by 김건우 on 7/8/24.
//

import UIKit

extension BBToast {
    
    /// Alert 뒤의 배경 색상을 설정합니다.
    ///
    /// - Authors: 김소월
    public enum Background {
        
        /// 아무런 배경 색상을 적용하지 않습니다.
        case none
        
        /// 특정 색상을 배경 색상으로 적용합니다.
        case color(color: UIColor = defaultImageTint.withAlphaComponent(0.25))
    }
    
}
