//
//  FamilyCollectionViewCell.swift
//  App
//
//  Created by 마경미 on 05.12.23.
//

import UIKit

import Core
import Domain
import DesignSystem

import RxSwift

final class MainFamilyCollectionViewCell: BaseCollectionViewCell<MainFamilyCellReactor> {
    typealias Layout = HomeAutoLayout.ProfileView
    static let id: String = "familyCollectionViewCell"
    
    private let defaultNameLabel = BBLabel(.head1, textAlignment: .center, textColor: .gray200)
    private let imageView: UIImageView = UIImageView()
    private let nameLabel: UILabel = UILabel()
    private let rankBadge: UIImageView = UIImageView()
    private let birthdayBadge: UIImageView = UIImageView()
    private let pickButton: UIButton = UIButton()
    
    override func bind(reactor: MainFamilyCellReactor) {
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    override func setupUI() {
        addSubviews(imageView, nameLabel, defaultNameLabel,
                    birthdayBadge, rankBadge, pickButton)
    }
    
    override func prepareForReuse() {
        imageView.image = nil
        rankBadge.image = nil
        birthdayBadge.image = nil
        imageView.layer.borderWidth = 0
        imageView.layer.borderColor = UIColor.clear.cgColor
    }

    override func setupAutoLayout() {
        imageView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.width.height.equalTo(64)
            $0.top.leading.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(Layout.NameLabel.topOffset)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        defaultNameLabel.snp.makeConstraints {
            $0.center.equalTo(imageView)
        }
        
        birthdayBadge.snp.makeConstraints {
            $0.size.equalTo(20)
            $0.top.trailing.equalToSuperview().offset(-4)
        }
        
        rankBadge.snp.makeConstraints {
            $0.width.equalTo(20)
            $0.height.equalTo(24)
            $0.leading.bottom.equalTo(imageView)
        }
        
        pickButton.snp.makeConstraints {
            $0.size.equalTo(32)
            $0.bottom.trailing.equalTo(imageView).offset(4)
        }
    }
    
    override func setupAttributes() {
        nameLabel.do {
            $0.font = UIFont.style(.caption)
            $0.textAlignment = .center
            $0.textColor = .gray300
            
            $0.numberOfLines = 1
            $0.lineBreakMode = .byTruncatingTail
        }
        
        imageView.do {
            $0.clipsToBounds = true
            $0.contentMode = .scaleAspectFill
            $0.layer.cornerRadius = 64 / 2
            $0.backgroundColor = .gray800
        }
        
        birthdayBadge.do {
            $0.image = DesignSystemAsset.birthday.image
            $0.isHidden = true
        }
        
        rankBadge.do {
            $0.isHidden = true
        }
        
        pickButton.do {
            $0.isHidden = true
            $0.setImage(DesignSystemAsset.paperPlane.image, for: .normal)
            $0.contentMode = .scaleToFill
            $0.backgroundColor = .gray100
            $0.layer.cornerRadius = 16
            $0.clipsToBounds = true
            $0.layer.borderWidth = 4
            $0.layer.borderColor = UIColor.bibbiBlack.cgColor
        }
    }
}

extension MainFamilyCollectionViewCell {
    private func bindInput(reactor: MainFamilyCellReactor) {
        Observable.just(())
            .map { Reactor.Action.fetchData}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        pickButton.rx.tap
            .throttle(RxInterval._300milliseconds, scheduler: RxScheduler.main)
            .map { Reactor.Action.didTapPickButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: MainFamilyCellReactor) {
        reactor.state.map { $0.profile }
            .distinctUntilChanged({ $0.0 })
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .bind(onNext: { $0.0.setupImageView(imageUrl: $0.1.0, name: $0.1.1) })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.rank }
            .distinctUntilChanged()
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .bind(onNext: { $0.0.setRankBadge(rank: $0.1) })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isShowBirthdayBadge }
            .distinctUntilChanged()
            .map { !$0 }
            .bind(to: birthdayBadge.rx.isHidden)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.hiddenPickButton }
            .distinctUntilChanged()
            .bind(to: pickButton.rx.isHidden)
            .disposed(by: disposeBag)
    }
}

extension MainFamilyCollectionViewCell {
    private func setupImageView(imageUrl: String?, name: String) {
        if let profileImageURL = imageUrl,
           let url = URL(string: profileImageURL), !profileImageURL.isEmpty {
            imageView.kf.setImage(with: url)
            defaultNameLabel.isHidden = true
        } else {
            guard let name = name.first else {
                return
            }
            defaultNameLabel.isHidden = false
            defaultNameLabel.text = "\(name)"
        }
        nameLabel.text = name
    }
    
    private func setRankBadge(rank: Int?) {
        guard let rank = rank else {
            imageView.alpha = 0.5
            defaultNameLabel.alpha = 0.5
            imageView.layer.borderWidth = 0
            pickButton.isHidden = false
            return
        }
        
        imageView.alpha = 1
        defaultNameLabel.alpha = 1
        imageView.layer.borderWidth = 1
        rankBadge.isHidden = false
        
        switch RankBadge(rawValue: rank) {
        case .one:
            imageView.layer.borderColor = UIColor.mainYellow.cgColor
            rankBadge.image = DesignSystemAsset.rank1.image
        case .two:
            imageView.layer.borderColor = UIColor.graphicGreen.cgColor
            rankBadge.image = DesignSystemAsset.rank2.image
        case .three:
            imageView.layer.borderColor = UIColor.graphicOrange.cgColor
            rankBadge.image = DesignSystemAsset.rank3.image
        case .none:
            rankBadge.isHidden = true
        }
    }
}
