//
//  BBDrawable.swift
//  Core
//
//  Created by Kim dohyun on 9/19/24.
//

import UIKit

/// **UIBezierPath**, ** CALayer**, **CGMutablePath**을  활용한 draw 메서드를 정의하는 Protocol입니다.
protocol BBDrawable {
    func drawToolTip(_ frame: CGRect, type: BBToolTipType, context: CGContext)
    func drawToolTipArrowShape(_ frame: CGRect, type: BBToolTipType, path: CGMutablePath)
    func drawToolTipBottomShape(_ frame: CGRect, toolTipType: BBToolTipType, cornerRadius: CGFloat, path: CGMutablePath)
    func drawToolTipTopShape(_ frame: CGRect, toolTipType: BBToolTipType, cornerRadius: CGFloat, path: CGMutablePath)
}


extension BBDrawable {
    
    
    /// drawToolTip 메서드 호출 시 **BBToolTipType** 에 해당하는 ToolTip Layout을 **CGContext** 내에서 드로잉 하는 메서드입니다.
    ///
    /// drawToolTip에 frame은 UIView의 **draw(_: )**  메서드에서 호출되고 있습니다.
    /// ToolTip Layout을 변경할 경우 **setNeedsDisplay** 메서드를 호출하시면 됩니다.
    func drawToolTip(_ frame: CGRect, type: BBToolTipType, context: CGContext) {
        let toolTipPath = CGMutablePath()
        
        switch type {
        case .contributor, .monthlyCalendar:
            drawToolTipArrowShape(frame, type: type, path: toolTipPath)
            drawToolTipTopShape(frame, toolTipType: type, cornerRadius: type.configure.cornerRadius, path: toolTipPath)
        default:
            drawToolTipArrowShape(frame, type: type, path: toolTipPath)
            drawToolTipBottomShape(frame, toolTipType: type, cornerRadius: type.configure.cornerRadius, path: toolTipPath)
        }
        
        toolTipPath.closeSubpath()
        context.addPath(toolTipPath)
        context.setFillColor(type.configure.backgroundColor.cgColor)
        context.fillPath()
    }
    
    /// drawToolTipArrowShape 메서드 호출 시 ToolTip에 Arrow 모양을 드로잉 하도록 실행합니다.
    ///
    /// **BBToolTipType** 에 따라 Arrow의 위치가 배치됩니다.
    func drawToolTipArrowShape(_ frame: CGRect, type: BBToolTipType, path: CGMutablePath) {
        let margin: CGFloat = 16
        let arrowTipXPosition = type.xPosition.rawValue * frame.width
        let adjustedArrowTipXPosition = min(max(arrowTipXPosition, margin + type.configure.arrowWidth / 2), frame.width - margin - type.configure.arrowWidth / 2)
        let arrowLeft = adjustedArrowTipXPosition - type.configure.arrowWidth / 2
        let arrowRight = adjustedArrowTipXPosition + type.configure.arrowWidth / 2
        
        switch type {
        case .contributor, .monthlyCalendar:
            path.move(to: CGPoint(x: arrowLeft, y: type.configure.arrowHeight))
            path.addLine(to: CGPoint(x: adjustedArrowTipXPosition, y: 0))
            path.addLine(to: CGPoint(x: arrowRight, y: type.configure.arrowHeight))
        default:
            path.move(to: CGPoint(x: arrowLeft, y: frame.height - type.configure.arrowHeight))
            path.addLine(to: CGPoint(x: adjustedArrowTipXPosition, y: frame.height))
            path.addLine(to: CGPoint(x: arrowRight, y: frame.height - type.configure.arrowHeight))
        }
    }
    
    /// drawToolTipTopShape  메서드 실행 시 ToolTip의 **ContentShape** 영역들을 드로잉 하도록 실행합니다.
    ///
    /// Note: - 해당 메서드는 **BBToolTipVerticalPosition** 이 Top일 경우 실행합니다.
    func drawToolTipTopShape(_ frame: CGRect, toolTipType: BBToolTipType, cornerRadius: CGFloat, path: CGMutablePath) {
        path.addArc(tangent1End: CGPoint(x: frame.maxX, y: toolTipType.configure.arrowHeight), tangent2End: CGPoint(x: frame.maxX, y: frame.maxY + frame.height), radius: cornerRadius)
        path.addArc(tangent1End: CGPoint(x: frame.maxX, y: frame.maxY), tangent2End: CGPoint(x: frame.minX, y: frame.maxY), radius: cornerRadius)
        
        path.addArc(tangent1End: CGPoint(x: frame.minX, y: frame.maxY), tangent2End: CGPoint(x: frame.minX, y: toolTipType.configure.arrowHeight), radius: cornerRadius)
        path.addArc(tangent1End: CGPoint(x: frame.minX, y: toolTipType.configure.arrowHeight), tangent2End: CGPoint(x: frame.maxX, y: toolTipType.configure.arrowHeight), radius: cornerRadius)
    }
    
    /// drawToolTipBottomShape  메서드 실행 시 ToolTip의 **ContentShape** 영역들을 드로잉 하도록 실행합니다.
    ///
    /// Note: - 해당 메서드는 **BBToolTipVerticalPosition** 이 Bottom일 경우 실행합니다.
    func drawToolTipBottomShape(_ frame: CGRect, toolTipType: BBToolTipType, cornerRadius: CGFloat, path: CGMutablePath) {
        path.addArc(tangent1End: CGPoint(x: frame.maxX, y: frame.height - toolTipType.configure.arrowHeight), tangent2End: CGPoint(x: frame.maxX, y: 0), radius: cornerRadius)
        path.addArc(tangent1End: CGPoint(x: frame.maxX, y: 0), tangent2End: CGPoint(x: frame.minX, y: 0), radius: cornerRadius)
        path.addArc(tangent1End: CGPoint(x: frame.minX, y: 0), tangent2End: CGPoint(x: frame.minX, y: frame.height - toolTipType.configure.arrowHeight), radius: cornerRadius)
        path.addArc(tangent1End: CGPoint(x: frame.minX, y: frame.height - toolTipType.configure.arrowHeight), tangent2End: CGPoint(x: frame.maxX, y: frame.height - toolTipType.configure.arrowHeight), radius: cornerRadius)
    }
}
