//
//  BBToolTipConfiguration.swift
//  Core
//
//  Created by Kim dohyun on 9/19/24.
//

import UIKit

import DesignSystem

/// BBToolTip에 (UI, Width, Height) Properties를 설정하기 위한 구조체입니다.
public struct BBToolTipConfiguration {
    /// ToolTip Corner Radius
    public let cornerRadius: CGFloat
    /// TooTip TextFont Foreground Color
    public let foregroundColor: UIColor
    /// TooTip Background Color
    public let backgroundColor: UIColor
    /// ToolTip Arrow YPosition
    public let yPosition: BBToolTipVerticalPosition
    /// ToolTip Arrow XPosition
    public let xPosition: BBToolTipHorizontalPosition
    /// ToolTip Text Font
    public let font: BBFontStyle
    /// ToolTip Content Text
    public let contentText: String
    /// ToolTip Arrow Width
    public let arrowWidth: CGFloat
    /// ToolTip Arrow Height
    public let arrowHeight: CGFloat
    
    public init(
        cornerRadius: CGFloat = 12,
        foregroundColor: UIColor = .bibbiBlack,
        backgroundColor: UIColor = .mainYellow,
        yPosition: BBToolTipVerticalPosition = .bottom,
        xPosition: BBToolTipHorizontalPosition = .center,
        font: BBFontStyle = .body2Regular,
        contentText: String = "",
        arrowWidth: CGFloat = 15,
        arrowHeight: CGFloat = 12
    ) {
        self.cornerRadius = cornerRadius
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
        self.xPosition = xPosition
        self.yPosition = yPosition
        self.font = font
        self.contentText = contentText
        self.arrowWidth = arrowWidth
        self.arrowHeight = arrowHeight
    }
}
