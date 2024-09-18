//
//  BBToolTipView.swift
//  Core
//
//  Created by Kim dohyun on 9/13/24.
//

import UIKit
import DesignSystem
import SnapKit
import Then


public enum BBToolTipPosition {
    public enum BBToolTipXPosition: CGFloat {
        case left = 0.0
        case midLeft = 0.25
        case center = 0.5
        case midRight = 0.75
        case right = 1.0
    }
    case top(BBToolTipXPosition)
    case bottom(BBToolTipXPosition)
}

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
        cornerRadius: CGFloat = 12.0,
        foregroundColor: UIColor = .bibbiBlack,
        backgroundColor: UIColor = .mainYellow,
        position: BBToolTipPosition = .top(.left),
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


public enum BBToolTipType {
    /// 홈 화면 inactive Camera Button State ToolTip Type
    case inactiveCameraTime
    /// 홈 화면 active Camera Button State ToolTip Type
    case activeCameraTime
    /// 가족 방 화면 Family Name Setting ToolTip Type
    case familyNameEdit
    /// 홈 화면 생존 신고 이전 Mission Camera Button inactive State Tool Tip
    case inactiveSurvivalCameraNoUpload
    /// 홈 화면 미션 이미지 업로드 이후 Camera Button inactive State Tool Tip
    case inactiveMissionCameraPostUpload
    /// 홈 화면 inactive Mission Camera Button State Tool Tip
    case inactiveMissionCamera
    /// 홈 화면 active Mission Camera Button State Tool Tip
    case activeMissionCamera
    /// 컨트리뷰터 화면 Description Button Touch Tool Tip
    case contributor
    /// 추억 캘린더 화면 Description Button Touch Tool Tip
    case monthlyCalendar
    /// 홈 화면 생존 신고 알림 Tool Tip
    case waitingSurvivalImage(contentText: String, profile:[UIImage])
    
    var configure: BBToolTipConfig {
        switch self {
        case .inactiveCameraTime:
            return .init(
                foregroundColor: .bibbiBlack,
                backgroundColor: .gray700,
                position: .bottom(.center),
                contentText: "오늘의 생존신고는 완료되었어요"
            )
        case .activeCameraTime:
            return .init(
                foregroundColor: .bibbiWhite,
                backgroundColor: .gray700,
                position: .bottom(.center),
                contentText: "하루에 한 번 사진을 올릴 수 있어요"
            )
        case .familyNameEdit:
            return .init(
                foregroundColor: .bibbiBlack,
                backgroundColor: .mainYellow,
                position: .bottom(.right),
                contentText: "가족 방 이름을 변경해보세요!"
            )
        case .inactiveSurvivalCameraNoUpload:
            return .init(
                foregroundColor: .bibbiWhite,
                backgroundColor: .gray700,
                position: .bottom(.center),
                contentText: "생존신고 후 미션 사진을 올릴 수 있어요"
            )
        case .inactiveMissionCameraPostUpload:
            return .init(
                foregroundColor: .bibbiWhite,
                backgroundColor: .gray700,
                position: .bottom(.center),
                contentText: "오늘의 미션은 완료되었어요"
            )
        case .inactiveMissionCamera:
            return .init(
                foregroundColor: .bibbiBlack,
                backgroundColor: .gray700,
                position: .bottom(.center),
                contentText: "아직 미션 사진을 찍을 수 없어요"
            )
        case .activeMissionCamera:
            return .init(
                foregroundColor: .bibbiBlack,
                backgroundColor: .gray700,
                position: .bottom(.center),
                contentText: "미션 사진을 찍으러 가볼까요?"
            )
        case .contributor:
            return .init(
                foregroundColor: .bibbiWhite,
                backgroundColor: .gray700,
                position: .top(.midLeft),
                contentText: "생존신고 횟수가 동일한 경우\n이모지, 댓글 수를 합산해서 등수를 정해요"
                
            )
        case .monthlyCalendar:
            return .init(
                foregroundColor: .bibbiWhite,
                backgroundColor: .gray700,
                position: .top(.midLeft),
                contentText: "모두가 참여한 날과 업로드한 사진 수로\n이 달의 친밀도를 측정합니다"
            )
        case let .waitingSurvivalImage(contentText, profile):
            return .init(
                foregroundColor: .bibbiBlack,
                backgroundColor: .mainYellow,
                position: .bottom(.center),
                contentText: "\(contentText)님 외 \(profile.count - 1)명이 기다리고 있어요"
            )
        }
    }
}


public final class BBToolTipView: UIView {
    
    private let contentLabel: BBLabel = BBLabel()
    private let toolTipType: BBToolTipType
    
    public init(toolTipType: BBToolTipType) {
        self.toolTipType = toolTipType
        super.init(frame: .zero)
        setupToolTipUI()
        setupToolTipContent()
    }
    
    //TODO: Positions, Text, Color, Font 는 Setter 할 수 있도록 수정
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.saveGState()
        drawToolTip(rect, arrowPosition: toolTipType.configure.position, context: context)
        context.restoreGState()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
    }

    private func drawToolTip(_ frame: CGRect, arrowPosition: BBToolTipPosition, context: CGContext) {
        
        let toolTipPath = CGMutablePath()
        let toolTipCornerRadius = toolTipType.configure.cornerRadius
        let arrowWidth = toolTipType.configure.arrowWidth
        let arrowHeight = toolTipType.configure.arrowHeight
        
        switch arrowPosition {
        case let .top(xPosition):
            let arrowTipXPosition = xPosition.rawValue * frame.width
            let arrowBaseYPosition = arrowHeight
            
            let margin: CGFloat = 16
            let adjustedArrowTipXPosition = min(max(arrowTipXPosition, margin + arrowWidth / 2), frame.width - margin - arrowWidth / 2)
            let arrowLeft = adjustedArrowTipXPosition - arrowWidth / 2
            let arrowRight = adjustedArrowTipXPosition + arrowWidth / 2

            toolTipPath.move(to: CGPoint(x: arrowLeft, y: arrowBaseYPosition))
            toolTipPath.addLine(to: CGPoint(x: adjustedArrowTipXPosition, y: 0))
            toolTipPath.addLine(to: CGPoint(x: arrowRight, y: arrowBaseYPosition))
            
            drawBBToolTipTopShape(frame, cornerRadius: toolTipCornerRadius, path: toolTipPath)
            setupAutoLayout()
            
        case let .bottom(xPosition):
            let arrowTipXPosition = xPosition.rawValue * frame.width
            let arrowBaseYPosition = frame.height - arrowHeight
            let margin: CGFloat = 16
            let adjustedArrowTipXPosition = min(max(arrowTipXPosition, margin + arrowWidth / 2), frame.width - margin - arrowWidth / 2)
            let arrowLeft = adjustedArrowTipXPosition - arrowWidth / 2
            let arrowRight = adjustedArrowTipXPosition + arrowWidth / 2


            toolTipPath.move(to: CGPoint(x: arrowLeft, y: arrowBaseYPosition))
            toolTipPath.addLine(to: CGPoint(x: adjustedArrowTipXPosition, y: frame.height))
            toolTipPath.addLine(to: CGPoint(x: arrowRight, y: arrowBaseYPosition))
            
            drawBBToolTipBottomShape(frame, cornerRadius: toolTipCornerRadius, path: toolTipPath)
            setupAutoLayout()
        }
        
        toolTipPath.closeSubpath()
        context.addPath(toolTipPath)
        context.setFillColor(toolTipType.configure.backgroundColor.cgColor)
        context.fillPath()
    }
    
    private func drawBBToolTipBottomShape(_ frame: CGRect, cornerRadius: CGFloat, path: CGMutablePath) {
        
        path.addArc(tangent1End: CGPoint(x: frame.maxX, y: frame.height - toolTipType.configure.arrowHeight), tangent2End: CGPoint(x: frame.maxX, y: 0), radius: cornerRadius)
        path.addArc(tangent1End: CGPoint(x: frame.maxX, y: 0), tangent2End: CGPoint(x: frame.minX, y: 0), radius: cornerRadius)
        path.addArc(tangent1End: CGPoint(x: frame.minX, y: 0), tangent2End: CGPoint(x: frame.minX, y: frame.height - toolTipType.configure.arrowHeight), radius: cornerRadius)
        path.addArc(tangent1End: CGPoint(x: frame.minX, y: frame.height - toolTipType.configure.arrowHeight), tangent2End: CGPoint(x: frame.maxX, y: frame.height - toolTipType.configure.arrowHeight), radius: cornerRadius)
    }
    
    
    private func drawBBToolTipTopShape(_ frame: CGRect, cornerRadius: CGFloat, path: CGMutablePath) {
        
        path.addArc(tangent1End: CGPoint(x: frame.maxX, y: toolTipType.configure.arrowHeight), tangent2End: CGPoint(x: frame.maxX, y: frame.maxY + frame.height), radius: cornerRadius)
        path.addArc(tangent1End: CGPoint(x: frame.maxX, y: frame.maxY), tangent2End: CGPoint(x: frame.minX, y: frame.maxY), radius: cornerRadius)
        
        path.addArc(tangent1End: CGPoint(x: frame.minX, y: frame.maxY), tangent2End: CGPoint(x: frame.minX, y: toolTipType.configure.arrowHeight), radius: cornerRadius)
        path.addArc(tangent1End: CGPoint(x: frame.minX, y: toolTipType.configure.arrowHeight), tangent2End: CGPoint(x: frame.maxX, y: toolTipType.configure.arrowHeight), radius: cornerRadius)
    }
    
    private func setupToolTipContent() {
        contentLabel.do {
            $0.text = toolTipType.configure.contentText
            $0.fontStyle = toolTipType.configure.font
            $0.textColor = toolTipType.configure.foregroundColor
        }
        
        self.do {
            $0.backgroundColor = .clear
        }
    }
    
    private func setupToolTipUI() {
        addSubview(contentLabel)
    }
    
    
    private func setupAutoLayout() {
        let arrowHeight = toolTipType.configure.arrowHeight
        let textPadding: CGFloat = 10
        
        
    }
}
