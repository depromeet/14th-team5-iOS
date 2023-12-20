//
//  ProfileFeedCollectionViewCell.swift
//  App
//
//  Created by Kim dohyun on 12/18/23.
//

import UIKit

import Core
import RxSwift
import RxCocoa
import ReactorKit
import SnapKit
import Then

public final class ProfileFeedCollectionViewCell: BaseCollectionViewCell<ProfileFeedCellReactor> {
    private let feedImageView: UIImageView = UIImageView()
    private let feedStackView: UIStackView = UIStackView()
    private let feedTitleLabel: UILabel = UILabel()
    private let feedUplodeLabel: UILabel = UILabel()
    
    public override func setupUI() {
        super.setupUI()
        
        feedStackView.addArrangedSubviews(feedTitleLabel, feedUplodeLabel)
        contentView.addSubviews(feedImageView, feedStackView)
        
    }
    
    public override func setupAttributes() {
        super.setupAttributes()
        feedImageView.do {
            $0.layer.cornerRadius = 24
            $0.clipsToBounds = true
        }
        
        feedTitleLabel.do {
            $0.text = "99"
            $0.textColor = .darkGray
            $0.font = .systemFont(ofSize: 14)
            $0.textAlignment = .left
            $0.numberOfLines = 1
        }
        
        feedUplodeLabel.do {
            $0.text = "3월 7일"
            $0.textColor = .darkGray
            $0.font = .systemFont(ofSize: 12)
            $0.textAlignment = .left
            $0.numberOfLines = 1
        }
        
        feedStackView.do {
            $0.axis = .vertical
            $0.spacing = 4
            $0.alignment = .leading
        }
        
    }
    
    public override func setupAutoLayout() {
        super.setupAutoLayout()
        feedImageView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
        }
        
        feedStackView.snp.makeConstraints {
            $0.top.equalTo(feedImageView.snp.bottom)
            $0.left.right.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview()
        }
        
        feedTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
        }
        
        
    }
    
    
    public override func bind(reactor: ProfileFeedCellReactor) {
        reactor.state
            .map { $0.imageURL }
            .compactMap { URL(string: $0) }
            .observe(on: MainScheduler.asyncInstance)
            .compactMap { try UIImage(data: Data(contentsOf: $0)) }
            .asDriver(onErrorJustReturn: UIImage())
            .drive(feedImageView.rx.image)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.date }
            .asDriver(onErrorJustReturn: "")
            .drive(feedUplodeLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.title }
            .asDriver(onErrorJustReturn: "")
            .drive(feedTitleLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    
    
    
}
