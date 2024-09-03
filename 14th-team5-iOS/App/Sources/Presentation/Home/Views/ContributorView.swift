//
//  ContributorView.swift
//  App
//
//  Created by 마경미 on 19.04.24.
//

import UIKit

import Core
import Domain
import DesignSystem

import RxSwift
import RxCocoa

final class ContributorView: BaseView<ContributorReactor> {
    private let containerView: UIView = UIView()
    
    private let titleLabel: BBLabel = BBLabel(.head2Bold, textColor: .gray200)
    let infoButton: UIButton = UIButton()
    private let subTitleLabel: BBLabel = BBLabel(.body2Regular, textColor: .gray300)
    
    private let firstProfileView: ContributorProfileView = ContributorProfileView(reactor: ContributorProfileReactor(initialState: .init(rank: .first)))
    private let secondProfileView: ContributorProfileView = ContributorProfileView(reactor: ContributorProfileReactor(initialState: .init(rank: .second)))
    private let thirdProfileView: ContributorProfileView =  ContributorProfileView(reactor: ContributorProfileReactor(initialState: .init(rank: .third)))
    
    private let nextButton: BBButton = BBButton()
    
    let contributorRelay: BehaviorRelay<FamilyRankData> = .init(value: FamilyRankData.empty)
    
    var nextButtonTapEvent: ControlEvent<Void> {
        return nextButton.rx.tap
    }
    
    override func bind(reactor: ContributorReactor) {
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    override func setupUI() {
        addSubviews(containerView)
        containerView.addSubviews(titleLabel, infoButton, subTitleLabel,
                                  firstProfileView, secondProfileView, thirdProfileView,
                                  nextButton)
    }
    
    override func setupAutoLayout() {
        
        containerView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.top.equalToSuperview()
            $0.height.equalTo(330)
        }
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(20)
            $0.height.equalTo(25)
        }
        
        infoButton.snp.makeConstraints {
            $0.size.equalTo(28)
            $0.leading.equalTo(titleLabel.snp.trailing).offset(4)
            $0.centerY.equalTo(titleLabel)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.trailing.top.equalToSuperview().inset(20)
            $0.centerY.equalTo(titleLabel)
        }
        
        firstProfileView.snp.makeConstraints {
            $0.width.equalToSuperview().dividedBy(3.7)
            $0.height.equalTo(155)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(nextButton.snp.top).offset(-40)
        }
        
        secondProfileView.snp.makeConstraints {
            $0.width.equalToSuperview().dividedBy(4.65)
            $0.height.equalTo(128)
            $0.leading.equalToSuperview().inset(27)
            $0.bottom.equalTo(nextButton.snp.top).offset(-32)
        }
        
        thirdProfileView.snp.makeConstraints {
            $0.width.equalToSuperview().dividedBy(4.65)
            $0.height.equalTo(128)
            $0.trailing.equalToSuperview().inset(27)
            $0.bottom.equalTo(nextButton.snp.top).offset(-32)
        }
        
        nextButton.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview().inset(20)
            $0.height.equalTo(44)
        }
    }
    
    override func setupAttributes() {
        self.backgroundColor = .bibbiBlack
        
        containerView.do {
            $0.layer.cornerRadius = 24
            $0.backgroundColor = .gray900
        }
        
        titleLabel.do {
            $0.text = "이번달 최고 기여자"
        }
        
        infoButton.do {
            $0.setImage(DesignSystemAsset.infoCircleFill.image, for: .normal)
        }
        
        nextButton.do {
            $0.layer.cornerRadius = 8
            $0.setTitle("지난 날 생존신고 보기", for: .normal)
            $0.setTitleColor(.bibbiBlack, for: .normal)
            $0.setTitleFontStyle(.body1Bold)
            $0.setButtonBackgroundColor(.mainYellow, for: .normal)
            $0.setButtonBackgroundColor(.gray400, for: .disabled)
        }
    }
}

extension ContributorView {
    private func bindInput(reactor: ContributorReactor) {
        contributorRelay.map { Reactor.Action.setContributor($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: ContributorReactor) {
        reactor.pulse(\.$rank)
            .map { "\($0.month)월 생존신고 횟수" }
            .bind(to: subTitleLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$rank)
            .map { $0.firstRanker }
            .bind(to: firstProfileView.rankerRelay)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$rank)
            .map { $0.secondRanker }
            .bind(to: secondProfileView.rankerRelay)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$rank)
            .map { $0.thirdRanker }
            .bind(to: thirdProfileView.rankerRelay)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$rank)
            .map { $0.recentPostDate != nil }
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
}
