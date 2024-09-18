//
//  BBToolTipView.swift
//  Core
//
//  Created by Kim dohyun on 9/13/24.
//

import UIKit

import DesignSystem
import Kingfisher
import SnapKit
import Then


public enum BBToolTipXPosition: CGFloat {
    case left = 0.0
    case midLeft = 0.25
    case center = 0.5
    case midRight = 0.75
    case right = 1.0
}

public enum BBToolTipPosition {
    case top
    case bottom
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
    case waitingSurvivalImage(contentText: String, imageURL:[URL])
    
    
    var xPosition: BBToolTipXPosition {
        switch self {
        case .monthlyCalendar, .contributor:
            return .midLeft
        case .familyNameEdit:
            return .right
        default:
            return .center
        }
    }
    
    
    var configure: BBToolTipConfig {
        switch self {
        case .inactiveCameraTime:
            return .init(
                foregroundColor: .bibbiWhite,
                backgroundColor: .gray700,
                position: .bottom,
                contentText: "오늘의 생존신고는 완료되었어요"
            )
        case .activeCameraTime:
            return .init(
                foregroundColor: .bibbiWhite,
                backgroundColor: .gray700,
                position: .bottom,
                contentText: "하루에 한 번 사진을 올릴 수 있어요"
            )
        case .familyNameEdit:
            return .init(
                foregroundColor: .bibbiBlack,
                backgroundColor: .mainYellow,
                position: .bottom,
                contentText: "가족 방 이름을 변경해보세요!"
            )
        case .inactiveSurvivalCameraNoUpload:
            return .init(
                foregroundColor: .bibbiWhite,
                backgroundColor: .gray700,
                position: .bottom,
                contentText: "생존신고 후 미션 사진을 올릴 수 있어요"
            )
        case .inactiveMissionCameraPostUpload:
            return .init(
                foregroundColor: .bibbiWhite,
                backgroundColor: .gray700,
                position: .bottom,
                contentText: "오늘의 미션은 완료되었어요"
            )
        case .inactiveMissionCamera:
            return .init(
                foregroundColor: .bibbiWhite,
                backgroundColor: .gray700,
                position: .bottom,
                contentText: "아직 미션 사진을 찍을 수 없어요"
            )
        case .activeMissionCamera:
            return .init(
                foregroundColor: .bibbiWhite,
                backgroundColor: .gray700,
                position: .bottom,
                contentText: "미션 사진을 찍으러 가볼까요?"
            )
        case .contributor:
            return .init(
                foregroundColor: .bibbiWhite,
                backgroundColor: .gray700,
                position: .top,
                contentText: "생존신고 횟수가 동일한 경우\n이모지, 댓글 수를 합산해서 등수를 정해요"
            )
        case .monthlyCalendar:
            return .init(
                foregroundColor: .bibbiWhite,
                backgroundColor: .gray700,
                position: .top,
                contentText: "모두가 참여한 날과 업로드한 사진 수로\n이 달의 친밀도를 측정합니다"
            )
        case let .waitingSurvivalImage(contentText, profile):
            return .init(
                foregroundColor: .bibbiBlack,
                backgroundColor: .mainYellow,
                position: .bottom,
                contentText: "\(contentText)님 외 \(profile.count - 1)명이 기다리고 있어요"
            )
        }
    }
}


public final class BBToolTipView: UIView {
    
    private let contentLabel: BBLabel = BBLabel()
    private let profileStackView: UIStackView = UIStackView()
    public var toolTipType: BBToolTipType = .activeCameraTime {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public init() {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.saveGState()
        setupToolTipUI()
        setupToolTipContent()
        drawToolTip(rect, type: toolTipType, context: context)
        context.restoreGState()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
    }

    private func drawToolTip(_ frame: CGRect, type: BBToolTipType, context: CGContext) {
        
        let toolTipPath = CGMutablePath()
        
        switch type {
        case .contributor, .monthlyCalendar:
            drawBBToolTipArrowShape(frame, type: type, path: toolTipPath)
            drawBBToolTipTopShape(frame, cornerRadius: type.configure.cornerRadius, path: toolTipPath)
            setupAutoLayout(type)
        default:
            drawBBToolTipArrowShape(frame, type: type, path: toolTipPath)
            drawBBToolTipBottomShape(frame, cornerRadius: type.configure.cornerRadius, path: toolTipPath)
            setupAutoLayout(type)
        }
        
        toolTipPath.closeSubpath()
        context.addPath(toolTipPath)
        context.setFillColor(toolTipType.configure.backgroundColor.cgColor)
        context.fillPath()
    }
    
    
    private func drawBBToolTipArrowShape(_ frame : CGRect, type: BBToolTipType, path: CGMutablePath) {
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
        
        profileStackView.do {
            $0.spacing = -8
            $0.distribution = .fillEqually
        }
        
        contentLabel.do {
            $0.text = toolTipType.configure.contentText
            $0.fontStyle = toolTipType.configure.font
            $0.textAlignment = .center
            $0.numberOfLines = 0
            $0.textColor = toolTipType.configure.foregroundColor
        }
        
        self.do {
            $0.backgroundColor = .clear
        }
    }
    
    private func setupToolTipUI() {
        addSubviews(contentLabel, profileStackView)
    }
    
    
    private func setupWaittingToolTipUI(imageURL: [URL]) {
        imageURL.forEach {
            createProfileImageView(imageURL: $0)
        }
    }
    
    private func createProfileImageView(imageURL: URL) {
        let imageView = UIImageView(frame: .init(x: 0, y: 0, width: 20, height: 20))
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderColor = UIColor.mainYellow.cgColor
        imageView.layer.borderWidth = 2
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.kf.setImage(with: imageURL)
        profileStackView.addArrangedSubview(imageView)
    }
    
    private func setupAutoLayout(_ type: BBToolTipType) {
        let arrowHeight = toolTipType.configure.arrowHeight
        let textPadding: CGFloat = 10
        
        switch type {
        case .monthlyCalendar, .contributor:
            contentLabel.snp.makeConstraints {
                $0.left.equalToSuperview().inset(16)
                $0.right.equalToSuperview().inset(16)
                $0.top.equalToSuperview().inset((arrowHeight + textPadding))
                $0.bottom.equalToSuperview().inset(textPadding)
            }
        case let .waitingSurvivalImage(_ ,imageURL):
            setupWaittingToolTipUI(imageURL: imageURL)
            
            profileStackView.snp.makeConstraints {
                $0.width.equalTo(24 * imageURL.count)
                $0.left.equalToSuperview().inset(16)
                $0.height.equalTo(24)
                $0.centerY.equalTo(contentLabel)
            }
            
            contentLabel.snp.makeConstraints {
                $0.left.equalTo(profileStackView.snp.right).offset(2)
                $0.right.equalToSuperview().inset(16)
                $0.bottom.equalToSuperview().inset((arrowHeight + textPadding))
                $0.top.equalToSuperview().inset(textPadding)
            }
        default:
            contentLabel.snp.makeConstraints {
                $0.left.equalToSuperview().inset(16)
                $0.right.equalToSuperview().inset(16)
                $0.bottom.equalToSuperview().inset((arrowHeight + textPadding))
                $0.top.equalToSuperview().inset(textPadding)
            }
        }
    }
}
