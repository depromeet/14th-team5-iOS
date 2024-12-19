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
    
    // MARK: - Intializer
    public override var intrinsicContentSize: CGSize {
        let contentWidth = contentLabel.intrinsicContentSize.width + 32
        let contentHeight = contentLabel.intrinsicContentSize.height + toolTipType.configure.arrowHeight + 20
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    
    public override init(toolTipType: BBToolTipType) {
        super.init(toolTipType: toolTipType)
        setupToolTipUI()
        setupToolTipContent()
        setupAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure
    private func setupToolTipUI() {
        addSubview(contentLabel)
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
        
        self.do {
            $0.backgroundColor = .clear
        }
    }
    
    private func setupAutoLayout() {
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
}
