//
//  BBProgressHUDViewConfiguration.swift
//  BBProgressHUD
//
//  Created by 김건우 on 8/16/24.
//

import UIKit

public struct BBProgressHUDViewConfiguration {
    
    // MARK: - Properties
    
    public let minWidth: CGFloat
    public let minHeight: CGFloat
    
    public let xOffset: CGFloat
    public let yOffset: CGFloat
    
    public let animationColor: UIColor?
    public let backgroundColor: UIColor?
    
    public let cornerRadius: CGFloat?
    
    
    // MARK: - Intializer
    
    public init(
        minWidth: CGFloat = 130,
        minHeight: CGFloat = 130,
        offsetFromCenterX xOffset: CGFloat = 0,
        offsetFromCenterY yOffset: CGFloat = 0,
        animationColor: UIColor? = .mainYellow,
        backgroundColor: UIColor? = nil,
        cornerRadius: CGFloat? = 30
    ) {
        self.minWidth = minWidth
        self.minHeight = minHeight
        self.xOffset = xOffset
        self.yOffset = yOffset
        self.animationColor = animationColor
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
    }
    
}
