//
//  BBTextToolTipView.swift
//  Core
//
//  Created by 김도현 on 10/27/24.
//

import UIKit

import SnapKit
import Then


public class BBTextToolTipView: BBBaseToolTipView {
    // MARK: - Properties
    private var contentLabel: BBLabel = BBLabel()
    private let touchControl: UIControl = UIControl()
    
    // MARK: - Intializer
    public override init(toolTipType: BBToolTipType) {
        super.init(toolTipType: toolTipType)
        setupToolTipUI()
        setupToolTipContent()
        setupAutoLayount()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure
    private func setupToolTipUI() {
        addSubview(contentLabel)
        if toolTipType == .contributor || toolTipType == .monthlyCalendar {
            addTouchControl()
        }
    }
    
    private func setupToolTipContent() {
        contentLabel.do {
            $0.text = toolTipType.configure.contentText
            $0.fontStyle = toolTipType.configure.font
            $0.textAlignment = .center
            $0.numberOfLines = 0
            $0.textColor = toolTipType.configure.foregroundColor
            $0.sizeToFit()
        }
        
        touchControl.do {
            $0.frame = UIScreen.main.bounds
        }
        
        self.do {
            $0.backgroundColor = .clear
        }
    }
    
    private func setupAutoLayount() {
        let position = toolTipType.configure.yPosition
        let arrowHeight: CGFloat = toolTipType.configure.arrowHeight
        let textPadding: CGFloat = 10
        
        switch position {
        case .bottom:
            contentLabel.snp.makeConstraints {
                $0.horizontalEdges.equalToSuperview().inset(16)
                $0.bottom.equalToSuperview().inset((arrowHeight + textPadding))
                $0.top.equalToSuperview().inset(textPadding)
            }
        case .top:
            contentLabel.snp.makeConstraints {
                $0.horizontalEdges.equalToSuperview().inset(16)
                $0.top.equalToSuperview().inset((arrowHeight + textPadding))
                $0.bottom.equalToSuperview().inset(textPadding)
            }
        }
    }
    
    private func addTouchControl() {

        BBHelper.topMostController()?.view.addSubview(self.touchControl)
        self.touchControl.addTarget(self, action: #selector(didTappedContainerView), for: .touchDown)
    }
    
    @objc private func didTappedContainerView() {
        self.touchesBeganHide()
    }
    
    private func touchesBeganHide(
        duration: TimeInterval = 0.3,
        options: UIView.AnimationOptions = [.curveEaseInOut],
        transform: CGAffineTransform = CGAffineTransform(scaleX: 0.1, y: 0.1),
        alpha: CGFloat = 0
    ) {
        UIView.animate(withDuration: duration, delay: 0, options: options, animations: { [weak self] in
            guard let self = self else { return }
            self.transform = transform
            self.alpha = 0
        }, completion: { _ in
            self.removeFromSuperview()
            self.touchControl.removeFromSuperview()
            self.transform = .identity
        })

        self.layoutIfNeeded()
    }
    
}
