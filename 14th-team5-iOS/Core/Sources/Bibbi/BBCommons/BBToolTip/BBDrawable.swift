//
//  BBDrawable.swift
//  Core
//
//  Created by Kim dohyun on 9/19/24.
//

import UIKit


protocol BBDrawable {
    func drawToolTip(_ frame: CGRect, type: BBToolTipType, context: CGContext)
    func drawToolTipArrowShape(_ frame: CGRect, type: BBToolTipType, path: CGMutablePath)
    func drawToolTipBottomShape(_ frame: CGRect, toolTipType: BBToolTipType, cornerRadius: CGFloat, path: CGMutablePath)
    func drawToolTipTopShapee(_ frame: CGRect, toolTipType: BBToolTipType, cornerRadius: CGFloat, path: CGMutablePath)
}


extension BBDrawable {
    
    func drawToolTip(_ frame: CGRect, type: BBToolTipType, context: CGContext) {
        let toolTipPath = CGMutablePath()
        
        switch type {
        case .contributor, .monthlyCalendar:
            drawToolTipArrowShape(frame, type: type, path: toolTipPath)
            drawToolTipTopShapee(frame, toolTipType: type, cornerRadius: type.configure.cornerRadius, path: toolTipPath)
        default:
            drawToolTipArrowShape(frame, type: type, path: toolTipPath)
            drawToolTipBottomShape(frame, toolTipType: type, cornerRadius: type.configure.cornerRadius, path: toolTipPath)
        }
        
        toolTipPath.closeSubpath()
        context.addPath(toolTipPath)
        context.setFillColor(type.configure.backgroundColor.cgColor)
        context.fillPath()
    }
    
    func drawToolTipTopShapee(_ frame: CGRect, toolTipType: BBToolTipType, cornerRadius: CGFloat, path: CGMutablePath) {
        path.addArc(tangent1End: CGPoint(x: frame.maxX, y: toolTipType.configure.arrowHeight), tangent2End: CGPoint(x: frame.maxX, y: frame.maxY + frame.height), radius: cornerRadius)
        path.addArc(tangent1End: CGPoint(x: frame.maxX, y: frame.maxY), tangent2End: CGPoint(x: frame.minX, y: frame.maxY), radius: cornerRadius)
        
        path.addArc(tangent1End: CGPoint(x: frame.minX, y: frame.maxY), tangent2End: CGPoint(x: frame.minX, y: toolTipType.configure.arrowHeight), radius: cornerRadius)
        path.addArc(tangent1End: CGPoint(x: frame.minX, y: toolTipType.configure.arrowHeight), tangent2End: CGPoint(x: frame.maxX, y: toolTipType.configure.arrowHeight), radius: cornerRadius)
    }
    
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
    
    func drawToolTipBottomShape(_ frame: CGRect, toolTipType: BBToolTipType, cornerRadius: CGFloat, path: CGMutablePath) {
        path.addArc(tangent1End: CGPoint(x: frame.maxX, y: frame.height - toolTipType.configure.arrowHeight), tangent2End: CGPoint(x: frame.maxX, y: 0), radius: cornerRadius)
        path.addArc(tangent1End: CGPoint(x: frame.maxX, y: 0), tangent2End: CGPoint(x: frame.minX, y: 0), radius: cornerRadius)
        path.addArc(tangent1End: CGPoint(x: frame.minX, y: 0), tangent2End: CGPoint(x: frame.minX, y: frame.height - toolTipType.configure.arrowHeight), radius: cornerRadius)
        path.addArc(tangent1End: CGPoint(x: frame.minX, y: frame.height - toolTipType.configure.arrowHeight), tangent2End: CGPoint(x: frame.maxX, y: frame.height - toolTipType.configure.arrowHeight), radius: cornerRadius)
    }
}
