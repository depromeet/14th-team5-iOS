//
//  BBAlertViewConfiguration.swift
//  BBAlert
//
//  Created by 김건우 on 8/7/24.
//

import UIKit

// MARK: - Typealias

public typealias BBAlertButtonAxis = NSLayoutConstraint.Axis

public struct BBAlertViewConfiguration {
    
    // MARK: - Properties
    
    public let minWidth: CGFloat
    public let minHeight: CGFloat
    
    public let buttons: [BBAlert.Button]
    public let buttonsAxis: BBAlertButtonAxis
    public let buttonHeight: CGFloat
    
    public let titleNumberOfLines: Int
    public let subtitleNumberOfLines: Int
    
    public let backgroundColor: UIColor?
    public let cornerRadius: CGFloat?
    
    
    // MARK: - Intializer
    
    public init(
        minWidth: CGFloat = 280,
        minHeight: CGFloat = 384,
        buttons: [BBAlert.Button] = [.normal(title: "확인", titleColor: .bibbiBlack, backgroundColor: .mainYellow), .cancel],
        buttonsAxis: BBAlertButtonAxis = .horizontal,
        buttonHeight: CGFloat = 44,
        titleNumberOfLines: Int = 1,
        subtitleNumberOfLines: Int = 10,
        backgroundColor: UIColor? = .gray900,
        cornerRadius: CGFloat? = nil
    ) {
        self.minWidth = minWidth
        self.minHeight = minHeight
        self.buttons = buttons
        self.buttonsAxis = buttonsAxis
        self.buttonHeight = buttonHeight
        self.titleNumberOfLines = titleNumberOfLines
        self.subtitleNumberOfLines = subtitleNumberOfLines
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
    }
}
