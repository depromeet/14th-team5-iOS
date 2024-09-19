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


public class BBToolTipView: UIView, BBDrawable, BBAnimatable {
    
    //MARK: Properties
    private let contentLabel: BBLabel = BBLabel()
    private let profileStackView: UIStackView = UIStackView()
    public var toolTipType: BBToolTipType = .activeCameraTime {
        didSet {
            setupToolTipContent()
            setupAutoLayout(toolTipType)
            setNeedsDisplay()
        }
    }
    
    public init() {
        super.init(frame: .zero)
        setupToolTipUI()
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
    
    //MARK: Configure
    private func setupToolTipContent() {
        
        profileStackView.do {
            $0.spacing = -4
            $0.distribution = .fillEqually
        }
        
        contentLabel.do {
            $0.text = toolTipType.configure.contentText
            $0.fontStyle = toolTipType.configure.font
            $0.textAlignment = .center
            $0.numberOfLines = 0
            $0.textColor = toolTipType.configure.foregroundColor
            $0.sizeToFit()
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
            contentLabel.snp.remakeConstraints {
                $0.left.equalToSuperview().inset(16)
                $0.right.equalToSuperview().inset(16)
                $0.top.equalToSuperview().inset((arrowHeight + textPadding))
                $0.bottom.equalToSuperview().inset(textPadding)
            }
        case let .waitingSurvivalImage(_ ,imageURL):
            setupWaittingToolTipUI(imageURL: imageURL)
            
            profileStackView.snp.remakeConstraints {
                $0.width.equalTo(24 * imageURL.count)
                $0.left.equalToSuperview().offset(16)
                $0.height.equalTo(24)
                $0.centerY.equalTo(contentLabel)
            }
            
            contentLabel.snp.remakeConstraints {
                $0.left.equalTo(profileStackView.snp.right).offset(2)
                $0.right.equalToSuperview().inset(16)
                $0.bottom.equalToSuperview().inset((arrowHeight + textPadding))
                $0.top.equalToSuperview().inset(textPadding)
            }
        default:
            contentLabel.snp.remakeConstraints {
                $0.left.equalToSuperview().inset(16)
                $0.right.equalToSuperview().inset(16)
                $0.bottom.equalToSuperview().inset((arrowHeight + textPadding))
                $0.top.equalToSuperview().inset(textPadding)
            }
        }
    }
}
