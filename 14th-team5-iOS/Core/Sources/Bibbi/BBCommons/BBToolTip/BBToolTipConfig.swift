//
//  BBToolTipConfig.swift
//  Core
//
//  Created by Kim dohyun on 9/19/24.
//

import Foundation

import DesignSystem


public struct BBToolTipConfig {
    /// ToolTip Corner Radius
    public var cornerRadius: CGFloat
    /// TooTip TextFont Foreground Color
    public var foregroundColor: UIColor
    /// TooTip Background Color
    public var backgroundColor: UIColor
    /// ToolTip Arrow Position
    public var position: BBToolTipPosition
    /// ToolTip Text Font
    public var font: BBFontStyle
    /// ToolTip Content Text
    public var contentText: String
    /// ToolTip Arrow Width
    public var arrowWidth: CGFloat
    /// ToolTip Arrow Height
    public var arrowHeight: CGFloat
    
    public init(
        cornerRadius: CGFloat = 12,
        foregroundColor: UIColor = .bibbiBlack,
        backgroundColor: UIColor = .mainYellow,
        position: BBToolTipPosition = .top,
        font: BBFontStyle = .body2Regular,
        contentText: String = "",
        arrowWidth: CGFloat = 15,
        arrowHeight: CGFloat = 12
    ) {
        self.cornerRadius = cornerRadius
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
        self.position = position
        self.font = font
        self.contentText = contentText
        self.arrowWidth = arrowWidth
        self.arrowHeight = arrowHeight
    }
}
