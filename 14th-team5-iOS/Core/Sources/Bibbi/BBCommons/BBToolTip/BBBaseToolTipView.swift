//
//  BBBaseToolTipView.swift
//  Core
//
//  Created by 김도현 on 10/27/24.
//

import UIKit

import SnapKit
import Then

public class BBBaseToolTipView: UIView {
    // MARK: - Properties
    public var toolTipType: BBToolTipType
    
    // MARK: - Intializer
    public init(toolTipType: BBToolTipType) {
        self.toolTipType = toolTipType
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.saveGState()
        drawToolTip(rect, type: toolTipType, context: context)
        context.restoreGState()
    }
    
    // MARK: - Configure
    private func drawToolTip(_ frame: CGRect, type: BBToolTipType, context: CGContext) {
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

    private func drawToolTipArrowShape(_ frame: CGRect, type: BBToolTipType, path: CGMutablePath) {
        let margin: CGFloat = 16
        let arrowTipXPosition = type.configure.xPosition.rawValue * frame.width
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

    private func drawToolTipTopShape(_ frame: CGRect, toolTipType: BBToolTipType, cornerRadius: CGFloat, path: CGMutablePath) {
        path.addArc(tangent1End: CGPoint(x: frame.maxX, y: toolTipType.configure.arrowHeight), tangent2End: CGPoint(x: frame.maxX, y: frame.maxY + frame.height), radius: cornerRadius)
        path.addArc(tangent1End: CGPoint(x: frame.maxX, y: frame.maxY), tangent2End: CGPoint(x: frame.minX, y: frame.maxY), radius: cornerRadius)
        
        path.addArc(tangent1End: CGPoint(x: frame.minX, y: frame.maxY), tangent2End: CGPoint(x: frame.minX, y: toolTipType.configure.arrowHeight), radius: cornerRadius)
        path.addArc(tangent1End: CGPoint(x: frame.minX, y: toolTipType.configure.arrowHeight), tangent2End: CGPoint(x: frame.maxX, y: toolTipType.configure.arrowHeight), radius: cornerRadius)
    }
    
    private func drawToolTipBottomShape(_ frame: CGRect, toolTipType: BBToolTipType, cornerRadius: CGFloat, path: CGMutablePath) {
        path.addArc(tangent1End: CGPoint(x: frame.maxX, y: frame.height - toolTipType.configure.arrowHeight), tangent2End: CGPoint(x: frame.maxX, y: 0), radius: cornerRadius)
        path.addArc(tangent1End: CGPoint(x: frame.maxX, y: 0), tangent2End: CGPoint(x: frame.minX, y: 0), radius: cornerRadius)
        path.addArc(tangent1End: CGPoint(x: frame.minX, y: 0), tangent2End: CGPoint(x: frame.minX, y: frame.height - toolTipType.configure.arrowHeight), radius: cornerRadius)
        path.addArc(tangent1End: CGPoint(x: frame.minX, y: frame.height - toolTipType.configure.arrowHeight), tangent2End: CGPoint(x: frame.maxX, y: frame.height - toolTipType.configure.arrowHeight), radius: cornerRadius)
    }
    
}
