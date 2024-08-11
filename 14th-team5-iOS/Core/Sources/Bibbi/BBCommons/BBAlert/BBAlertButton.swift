//
//  Button.swift
//  BBAlert
//
//  Created by 김건우 on 8/7/24.
//

import UIKit

extension BBAlert {
    
    public enum Button {
        case normal(
            title: String? = "확인",
            titleFontStyle: BBFontStyle? = nil,
            titleColor: UIColor? = nil,
            backgroundColor: UIColor? = nil,
            action: BBAlertAction = nil
        )
        case confirm(
            title: String? = "확인",
            action: BBAlertAction = nil
        )
        case cancel(title: String = "취소")
    }
    
}
