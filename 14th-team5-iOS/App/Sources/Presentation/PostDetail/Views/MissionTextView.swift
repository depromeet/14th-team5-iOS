//
//  MissionTextView.swift
//  App
//
//  Created by 김건우 on 5/7/24.
//

import Core
import DesignSystem
import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

final class MissionTextView: UIView {
    
    // MARK: - Views
    private let containerView: UIView = UIView()
    private let missionStackView: UIStackView = UIStackView()
    private let missionImageView: UIImageView = UIImageView()
    let missionLabel: BBLabel = BBLabel(.body2Regular, textAlignment: .left, textColor: .bibbiWhite)
    
    // MARK: - Helpers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupAttributes()
        setupAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        self.addSubviews(containerView)
        containerView.addSubview(missionStackView)
        missionStackView.addArrangedSubviews(missionImageView, missionLabel)
    }
    
    private func setupAutoLayout() {
        
        containerView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        containerView.addBlurEffect(style: .systemThinMaterialDark)
        
        missionStackView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(8)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        missionImageView.snp.makeConstraints {
            $0.width.equalTo(40)
            $0.height.equalTo(18)
        }
        
        missionLabel.snp.makeConstraints {
            $0.leading.equalTo(missionImageView.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().offset(-8)
        }
    }
    
    private func setupAttributes() {
        
        containerView.do {
            $0.backgroundColor = UIColor.gray800
                .withAlphaComponent(0.8)
            $0.layer.cornerRadius = 21
            $0.layer.masksToBounds = true
        }
        containerView.addBlurEffect(style: .systemThinMaterialDark)
        
        missionStackView.do {
            $0.axis = .horizontal
            $0.spacing = 10
            $0.alignment = .center
            $0.distribution = .fillProportionally
        }
        
        missionImageView.do {
            $0.image = DesignSystemAsset.missionTitleBadge.image
            $0.contentMode = .scaleAspectFit
        }
    }
}


// MARK: - Extensions

extension MissionTextView {
    
    func setHidden(hidden: Bool) {
        self.isHidden = hidden
    }
    
    func setMissionText(text: String?) {
        missionLabel.text = text
    }
    
}
