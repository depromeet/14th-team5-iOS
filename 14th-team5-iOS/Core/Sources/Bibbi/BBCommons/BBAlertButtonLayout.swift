//
//  BBAlertButtonConfiguration.swift
//  Core
//
//  Created by 김건우 on 8/9/24.
//

import UIKit

// MARK: - Typealias

public typealias BBAlertButtonAxis = NSLayoutConstraint.Axis

public struct BBAlertButtonLayout {
     
    // MARK: - Properties
    
    public let buttons: [BBAlert.Button]
    public let axis: BBAlertButtonAxis
    public let height: CGFloat
    
    
    // MARK: - Intializer
    
    public init(
        buttons: [BBAlert.Button] = [
            .normal(title: "확인", titleColor: .bibbiBlack, backgroundColor: .mainYellow),
            .cancel
        ],
        axis: BBAlertButtonAxis = .vertical,
        height: CGFloat = 44
    ) {
        self.buttons = buttons
        self.axis = axis
        self.height = height
    }
    
}
