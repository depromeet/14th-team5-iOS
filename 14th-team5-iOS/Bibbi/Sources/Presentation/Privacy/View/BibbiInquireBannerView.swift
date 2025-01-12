//
//  BibbiInquireBannerView.swift
//  App
//
//  Created by Kim dohyun on 10/9/24.
//

import UIKit

import Core
import DesignSystem
import SnapKit
import Then

final class BibbiInquireBannerView: UIView {
    private let mainLogoView: UIImageView = UIImageView()
    private let subLogoView: UIImageView = UIImageView()
    private let descrptionLabel: UILabel = BBLabel(.body1Bold, textAlignment: .left)
    private let subtitleLabel: UILabel = BBLabel(.caption, textAlignment: .left)
    private let arrowImageView: UIImageView = UIImageView()
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupAttributes()
        setupAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubviews(mainLogoView, subLogoView, arrowImageView, descrptionLabel, subtitleLabel)
    }
    
    private func setupAttributes() {
        
        mainLogoView.do {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            $0.image = DesignSystemAsset.inquirelogo.image
        }
        
        subLogoView.do {
            $0.contentMode = .scaleAspectFill
            $0.image = DesignSystemAsset.airplane.image
        }
        
        arrowImageView.do {
            $0.image = DesignSystemAsset.arrowRight.image.withTintColor(.blue500)
        }
        
        descrptionLabel.do {
            $0.text = "삐삐가 더 빨리 클 수 있도록 좋은 점, 아쉬운 점을 알려주세요!"
            $0.textColor = .gray900
            $0.setContentHuggingPriority(.init(998), for: .horizontal)
            $0.numberOfLines = 2
        }
        
        subtitleLabel.do {
            $0.text = "의견 남기러 가기"
            $0.textColor = .blue500
        }
    }
    
    
    private func setupAutoLayout() {
        descrptionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.width.equalTo(199)
            $0.left.equalToSuperview().offset(30)
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(descrptionLabel.snp.bottom).offset(7)
            $0.left.equalToSuperview().offset(30)
            $0.height.equalTo(14)
            $0.width.equalTo(77)
        }
        
        mainLogoView.snp.makeConstraints {
            $0.left.greaterThanOrEqualTo(descrptionLabel.snp.right).offset(39).priority(.high)
            $0.bottom.equalToSuperview()
            $0.width.equalTo(94)
        }
        
        subLogoView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(7)
            $0.width.equalTo(24)
            $0.height.equalTo(21)
            $0.centerX.equalTo(mainLogoView)
        }
        
        arrowImageView.snp.makeConstraints {
            $0.left.equalTo(subtitleLabel.snp.right).offset(4)
            $0.width.height.equalTo(11)
            $0.centerY.equalTo(subtitleLabel)
        }
    }
}




