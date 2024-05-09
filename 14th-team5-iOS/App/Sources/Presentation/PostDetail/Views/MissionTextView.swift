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

final class MissionTextView: BaseView<MissionTextReactor> {
    
    // MARK: - Views
    private let containerView: UIView = UIView()
    private let missionStackView: UIStackView = UIStackView()
    private let missionImageView: UIImageView = UIImageView()
    let missionLabel: BibbiLabel = BibbiLabel(.body2Regular, textAlignment: .left, textColor: .bibbiWhite)
    
    // MARK: - Helpers
    override func bind(reactor: MissionTextReactor) {
        super.bind(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    private func bindOutput(reactor: MissionTextReactor) {
        reactor.state.map { $0.text }
            .distinctUntilChanged()
            .bind(to: missionLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    override func setupUI() {
        super.setupUI()
        
        self.addSubviews(containerView)
        containerView.addSubview(missionStackView)
        missionStackView.addArrangedSubviews(missionImageView, missionLabel)
    }
    
    override func setupAutoLayout() {
        super.setupAutoLayout()
        
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
    
    override func setupAttributes() {
        super.setupAttributes()
        
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
            $0.image = DesignSystemAsset.mission1.image
            $0.contentMode = .scaleAspectFit
        }
    }
}
