//
//  BBAlertViewConfiguration.swift
//  BBAlert
//
//  Created by 김건우 on 8/7/24.
//

import UIKit

public struct BBAlertViewConfiguration {
    
    // MARK: - Properties
    
    public let minWidth: CGFloat
    public let minHeight: CGFloat
    
    public let titleNumberOfLines: Int
    public let subtitleNumberOfLines: Int
    
    public let backgroundColor: UIColor?
    public let cornerRadius: CGFloat?
    
    public let buttonLayout: BBAlertButtonLayout
    
    
    // MARK: - Intializer
    
    public init(
        minWidth: CGFloat = 280,
        minHeight: CGFloat = 384,
        titleNumberOfLines: Int = 1,
        subtitleNumberOfLines: Int = 10,
        backgroundColor: UIColor? = .gray900,
        cornerRadius: CGFloat? = nil,
        buttonLayout: BBAlertButtonLayout = BBAlertButtonLayout()
    ) {
        self.minWidth = minWidth
        self.minHeight = minHeight
        self.titleNumberOfLines = titleNumberOfLines
        self.subtitleNumberOfLines = subtitleNumberOfLines
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.buttonLayout = buttonLayout
    }
}
