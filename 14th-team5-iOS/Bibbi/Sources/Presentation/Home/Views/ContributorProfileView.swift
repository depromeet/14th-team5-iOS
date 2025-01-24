//
//  ProfileView.swift
//  App
//
//  Created by 마경미 on 05.12.23.
//

import UIKit

import Core
import Domain
import DesignSystem

import Kingfisher
import RxCocoa
import RxSwift

final class ContributorProfileView: BaseView<ContributorProfileReactor> {
    private let nameLabel = BBLabel(.body2Bold, textAlignment: .center, textColor: .gray200)
    private let countLabel = BBLabel(.body2Regular, textAlignment: .center, textColor: .gray300)
    private let defaultNameLabel = BBLabel(.head1, textAlignment: .center, textColor: .gray200)
    private let imageView = UIImageView()
    private let questionView = UIImageView()
    private let badgeView = UIImageView()
    
    let rankerRelay: BehaviorRelay<RankerData?> = BehaviorRelay(value: nil)
    
    override func bind(reactor: ContributorProfileReactor) {
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    override func setupUI() {
        addSubviews(imageView, nameLabel, countLabel, 
                    defaultNameLabel, questionView, badgeView)
    }
    
    override func setupAutoLayout() {
        imageView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalToSuperview()
            $0.height.equalTo(self.snp.width)
        }
        
        questionView.snp.makeConstraints {
            $0.center.equalTo(imageView)
            $0.height.equalTo(26)
            $0.width.equalTo(18)
        }
        
        defaultNameLabel.snp.makeConstraints {
            $0.edges.equalTo(questionView)
        }
        
        badgeView.snp.makeConstraints {
            $0.width.equalTo(imageView.snp.width).dividedBy(3.5)
            $0.height.equalTo(imageView.snp.height).dividedBy(2.8)
            $0.top.equalTo(imageView.snp.bottom).offset(-16)
            $0.centerX.equalTo(imageView)
        }
        
        nameLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(10)
            $0.top.equalTo(badgeView.snp.bottom).offset(7)
            $0.height.equalTo(18)
        }
        
        countLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.top.equalTo(nameLabel.snp.bottom).offset(4)
            $0.height.equalTo(18)
        }
    }
    
    override func setupAttributes() {
        imageView.do {
            $0.clipsToBounds = true
            $0.layer.borderWidth = 4
            $0.tintColor = .gray400
            $0.contentMode = .scaleAspectFill
        }
        
        nameLabel.do {
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 4
        }
        
        countLabel.do {
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 4
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.layer.cornerRadius = self.frame.size.width / 2
    }
}

extension ContributorProfileView {
    private func bindInput(reactor: ContributorProfileReactor) {
        rankerRelay.map { Reactor.Action.getRanker($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: ContributorProfileReactor) {
        reactor.pulse(\.$ranker)
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .bind(onNext: { $0.0.setProfile($0.1) })
            .disposed(by: disposeBag)
    }
    
    private func setProfile(_ data: RankerData?) {
        if let data = data {
            nameLabel.backgroundColor = .clear
            nameLabel.text = data.name
            countLabel.backgroundColor = .clear
            countLabel.text = "\(data.survivalCount)회"
            
            questionView.isHidden = true
            imageView.layer.borderColor = reactor?.currentState.rank.borderColor.cgColor
            
            badgeView.image = reactor?.currentState.rank.badgeImage
            
            guard let url = data.imageURL else {
                imageView.image = nil
                defaultNameLabel.text = "\(data.name.first ?? "알")"
                return
            }
            imageView.kf.setImage(with: URL(string: url))
        } else {
            nameLabel.backgroundColor = .gray600
            countLabel.backgroundColor = .gray700
            
            imageView.layer.borderColor = UIColor.gray600.cgColor
            questionView.isHidden = false
            questionView.image = DesignSystemAsset.question.image
            
            badgeView.image = reactor?.currentState.rank.grayBadgeImage
        }
    }
}
