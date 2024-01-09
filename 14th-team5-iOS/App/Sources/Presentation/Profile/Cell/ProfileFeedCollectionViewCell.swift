//
//  ProfileFeedCollectionViewCell.swift
//  App
//
//  Created by Kim dohyun on 12/18/23.
//

import UIKit

import Core
import DesignSystem
import Kingfisher
import RxSwift
import RxCocoa
import ReactorKit
import SnapKit
import Then

public final class ProfileFeedCollectionViewCell: BaseCollectionViewCell<ProfileFeedCellReactor> {
    private let feedImageView: UIImageView = UIImageView()
    private let feedStackView: UIStackView = UIStackView()
    private let feedContentStackView: UIStackView = UIStackView()
    private let feedEmojiIconView: UIImageView = UIImageView()
    private let feedEmojiCountLabel: BibbiLabel = BibbiLabel(.body2Regular, textColor: .gray200)
    private let feedUplodeLabel: BibbiLabel = BibbiLabel(.caption, textColor: .gray400)
    
    
    public override func prepareForReuse() {
        feedImageView.image = nil
        feedEmojiCountLabel.text = ""
        feedUplodeLabel.text = ""
    }
    
    public override func setupUI() {
        super.setupUI()
        feedContentStackView.addArrangedSubviews(feedEmojiIconView , feedEmojiCountLabel)
        feedStackView.addArrangedSubviews(feedContentStackView, feedUplodeLabel)
        contentView.addSubviews(feedImageView, feedStackView)
        
        
    }
    
    public override func setupAttributes() {
        super.setupAttributes()
        feedImageView.do {
            $0.layer.cornerRadius = 24
            $0.clipsToBounds = true
        }
        
        feedEmojiIconView.do {
            $0.image = DesignSystemAsset.emoji.image.withTintColor(DesignSystemAsset.gray400.color)
        }
        
        feedContentStackView.do {
            $0.axis = .horizontal
            $0.spacing = 2
            $0.alignment = .fill
        }
        
        feedEmojiCountLabel.do {
            $0.text = "99"
            $0.textAlignment = .left
            $0.numberOfLines = 1
        }
        
        feedUplodeLabel.do {
            $0.text = "3월 7일"
            $0.textAlignment = .left
            $0.numberOfLines = 1
        }
        
        feedStackView.do {
            $0.distribution = .fillProportionally
            $0.spacing = 4
            $0.axis = .vertical
            $0.alignment = .leading
        }
        
    }
    
    public override func setupAutoLayout() {
        super.setupAutoLayout()
        feedImageView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(self.snp.width)
        }
                
        feedStackView.snp.makeConstraints {
            $0.top.equalTo(feedImageView.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(36)
        }
        
        feedEmojiIconView.snp.makeConstraints {
            $0.width.height.equalTo(16)
            
        }
        
        
    }
    
    
    public override func bind(reactor: ProfileFeedCellReactor) {
        reactor.state
            .map { $0.imageURL }
            .withUnretained(self)
            .bind(onNext: { $0.0.setupProfileFeedImage($0.1)})
            .disposed(by: disposeBag)

        
        reactor.state
            .map { $0.date }
            .asDriver(onErrorJustReturn: "")
            .drive(feedUplodeLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.emojiCount }
            .asDriver(onErrorJustReturn: "")
            .drive(feedEmojiCountLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    
    
    
}


extension ProfileFeedCollectionViewCell {
    private func setupProfileFeedImage(_ url: URL) {
        feedImageView.kf.indicatorType = .activity
        feedImageView.kf.setImage(with: url, placeholder: nil, options: [.transition(.fade(0.5))], completionHandler: nil)
    }
}
