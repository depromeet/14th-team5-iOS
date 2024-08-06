//
//  ToastViewConfiguration.swift
//  BBToast
//
//  Created by 김건우 on 7/8/24.
//

import UIKit

public struct BBToastViewConfiguration {
    
    // MARK: - Properties
    
    public let minWidth: CGFloat
    public let minHeight: CGFloat
    
    public let minButtonWidth: CGFloat
    public let minButtonHeight: CGFloat
    
    public let backgroundColor: UIColor
    
    public let titleNumberOfLines: Int
    public let subtitleNumberOfLines: Int
    
    public let cornerRadius: CGFloat?
    
    
    // MARK: - Intializer
    
    public init(
        minWidth: CGFloat = 300,
        minHeight: CGFloat = 56,
        minButtonWidth: CGFloat = 50,
        minButtonHeight: CGFloat = 36,
        backgroundColor: UIColor = .gray900,
        titleNumberOfLines: Int = 1,
        subtitleNumberOfLines: Int = 1,
        cornerRadius: CGFloat? = nil
    ) {
        self.minWidth = minWidth
        self.minHeight = minHeight
        self.minButtonWidth = minButtonWidth
        self.minButtonHeight = minButtonHeight
        self.backgroundColor = backgroundColor
        self.titleNumberOfLines = titleNumberOfLines
        self.subtitleNumberOfLines = subtitleNumberOfLines
        self.cornerRadius = cornerRadius
    }
    
}
