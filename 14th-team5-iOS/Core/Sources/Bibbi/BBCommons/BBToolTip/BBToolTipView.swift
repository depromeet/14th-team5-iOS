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


public class BBThumbnailToolTipView: BBBaseToolTipView {
    private let stackView: UIStackView = UIStackView()
    
    public override init(toolTipType: BBToolTipType) {
        super.init(toolTipType: toolTipType)
        guard case let .waitingSurvivalImage(_, imageURLs) = toolTipType else {
            return
        }
        setupThumbnailImageView(imageURL: imageURLs)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public override func setupToolTipUI() {
        super.setupToolTipUI()
        addSubview(stackView)
    }
    
    
    public override func setupAutoLayount() {
        super.setupAutoLayount()
        let arrowHeight: CGFloat = toolTipType.configure.arrowHeight
        let textPadding: CGFloat = 10
        guard case let .waitingSurvivalImage(contentText, imageURLs) = toolTipType else {
            return
        }
        
        stackView.snp.makeConstraints {
            $0.width.equalTo(24 * imageURLs.count)
            $0.height.equalTo(24)
            $0.left.equalToSuperview().inset(16)
            $0.centerY.equalTo(contentLabel)
        }
        
        
        contentLabel.snp.makeConstraints {
            $0.left.equalTo(stackView.snp.right).offset(22)
            $0.right.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(arrowHeight + textPadding)
            $0.top.equalToSuperview().inset(textPadding)
        }
        
        
    }
    
    public override func setupToolTipContent() {
        super.setupToolTipContent()
        stackView.do {
            $0.spacing = -4
            $0.distribution = .fillEqually
        }
    }
    
    
    private func setupThumbnailImageView(imageURL: [URL]) {
        imageURL.forEach {
            let imageView: UIImageView = UIImageView(frame: .init(x: 0, y: 0, width: 20, height: 20))
            imageView.contentMode = .scaleAspectFill
            imageView.layer.borderColor = UIColor.mainYellow.cgColor
            imageView.layer.borderWidth = 2
            imageView.layer.cornerRadius = 10
            imageView.clipsToBounds = true
            imageView.kf.setImage(with: $0)
            stackView.addArrangedSubview(imageView)
        }
    }
    
}


public class BBBaseToolTipView: UIView, BBDrawable {
    
    public private(set) var toolTipType: BBToolTipType {
        didSet {
            setupToolTipContent()
            setupAutoLayount()
        }
    }
    public private(set) var contentLabel: BBLabel = BBLabel()
    
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
    
    public func setupToolTipUI() {
        addSubview(contentLabel)
    }
    
    public func setupToolTipContent() {
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
    
    public func setupAutoLayount() {
        let arrowHeight: CGFloat = toolTipType.configure.arrowHeight
        let textPadding: CGFloat = 10
        contentLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.top.equalToSuperview().inset(arrowHeight + textPadding)
            $0.bottom.equalToSuperview().inset(textPadding)
        }
    }
}


public final class BBToolTip: AnyObject, BBComponentPresentable {

    
    
    public var contentView: UIView?
    private let superview: UIView?
    public var configure: BBToolTipType {
        didSet {
            switch configure {
            case .waitingSurvivalImage:
                contentView = createThumbnailToolTipView()
            default:
                contentView = createTextToolTipView()
            }
        }
    }
    
    
    public init(configure: BBToolTipType, superView: UIView) {
        self.configure = configure
        self.superview = superView
    }
    
    private func updateConstraints() {
        guard let superview else {
            fatalError("SuperView not Created")
        }
        
        switch configure {
        case .contributor, .monthlyCalendar:
            contentView?.snp.makeConstraints {
                $0.top.equalTo(superview.snp.bottom)
                $0.left.equalToSuperview().offset(20)
            }
        case .familyNameEdit:
            contentView?.snp.makeConstraints {
                $0.bottom.equalTo(superview.snp.top)
                $0.left.equalToSuperview()
            }
        default:
            contentView?.snp.makeConstraints {
                $0.bottom.equalTo(superview.snp.top)
                $0.centerX.equalToSuperview()
            }
        }
    }
    
    private func createTextToolTipView() -> BBBaseToolTipView {
        return BBBaseToolTipView(toolTipType: configure)
    }
    
    private func createThumbnailToolTipView() -> BBThumbnailToolTipView {
        return BBThumbnailToolTipView(toolTipType: configure)
    }
    
}
