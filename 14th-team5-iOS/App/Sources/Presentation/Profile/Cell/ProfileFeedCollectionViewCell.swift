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
import RxDataSources
import ReactorKit
import SnapKit
import Then

public final class ProfileFeedCollectionViewCell: BaseCollectionViewCell<ProfileFeedCellReactor> {
    private let feedImageView: UIImageView = UIImageView()
    private let feedStackView: UIStackView = UIStackView()
    private let feedContentStackView: UIStackView = UIStackView()
    private let feedEmojiIconView: UIImageView = UIImageView()
    private let feedBadgeImageView: UIImageView = UIImageView()
    private let feedEmojiCountLabel: BBLabel = BBLabel(.body2Regular, textColor: .gray200)
    private let feedCommentImageView: UIImageView = UIImageView()
    private let feedCommentCountLabel: BBLabel = BBLabel(.body2Regular, textColor: .gray200)
    private let feedUplodeLabel: BBLabel = BBLabel(.caption, textColor: .gray400)
    private let descrptionCollectionViewLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    private lazy var descrptionCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: descrptionCollectionViewLayout)
    private let descrptionDataSources: RxCollectionViewSectionedReloadDataSource<ProfileFeedDescrptionSectionModel> = .init { dataSources, collectionView, indexPath, sectionItem in
        switch sectionItem {
        case let .feedDescrptionItem(cellReactor):
            guard let descrptionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileFeedDescrptionCell", for: indexPath) as? ProfileFeedDescrptionCell else { return UICollectionViewCell () }
            descrptionCell.reactor = cellReactor
            return descrptionCell
        }
    }
    
    
    
    
    public override func prepareForReuse() {
        feedImageView.image = nil
        feedEmojiCountLabel.text = ""
        feedUplodeLabel.text = ""
    }
    
    public override func setupUI() {
        super.setupUI()
        feedContentStackView.addArrangedSubviews(feedEmojiIconView , feedEmojiCountLabel, feedCommentImageView, feedCommentCountLabel)
        feedStackView.addArrangedSubviews(feedContentStackView, feedUplodeLabel)
        feedImageView.addSubviews(feedBadgeImageView, descrptionCollectionView)
        contentView.addSubviews(feedImageView, feedStackView)
        
        
    }
    
    public override func setupAttributes() {
        super.setupAttributes()
        feedImageView.do {
            $0.layer.cornerRadius = 24
            $0.clipsToBounds = true
            $0.contentMode = .scaleAspectFill
        }
      
        feedBadgeImageView.do {
          $0.image = DesignSystemAsset.missionBadge.image
          $0.contentMode = .scaleAspectFill
        }
        
        feedEmojiIconView.do {
            $0.image = DesignSystemAsset.emoji.image.withTintColor(DesignSystemAsset.gray400.color)
        }
        
        feedCommentImageView.do {
            $0.image = DesignSystemAsset.chat.image.withTintColor(DesignSystemAsset.gray400.color)
        }
        
        feedCommentCountLabel.do {
            $0.text = "99"
            $0.textAlignment = .left
            $0.numberOfLines = 1
        }
        
        feedContentStackView.do {
            $0.axis = .horizontal
            $0.spacing = 2
            $0.alignment = .fill
            $0.distribution = .equalCentering
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
        
        descrptionCollectionViewLayout.do {
            $0.itemSize = CGSize(width: 17, height: 27)
            $0.minimumInteritemSpacing = 2
        }
        
        descrptionCollectionView.do {
            $0.register(ProfileFeedDescrptionCell.self, forCellWithReuseIdentifier: "ProfileFeedDescrptionCell")
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
            $0.backgroundColor = .clear
            $0.isScrollEnabled = false
            $0.delegate = self
        }
        
    }
    
    public override func setupAutoLayout() {
        super.setupAutoLayout()
        feedImageView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(self.snp.width)
        }
      
        feedBadgeImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.left.equalToSuperview().offset(12)
            $0.width.height.equalTo(24)
        }
        
        descrptionCollectionView.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-10)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(27)
            $0.left.right.equalToSuperview().inset(18)
        }
        
        feedStackView.snp.makeConstraints {
            $0.top.equalTo(feedImageView.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(36)
        }
        
        feedEmojiIconView.snp.makeConstraints {
            $0.width.height.equalTo(16)
        }
        
        feedCommentImageView.snp.makeConstraints {
            $0.width.height.equalTo(16)
        }
        
    }
    
    
    public override func bind(reactor: ProfileFeedCellReactor) {
        
        Observable
            .just(())
            .map { Reactor.Action.setFeedCellUpdateLayout }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.imageURL }
            .withUnretained(self)
            .bind(onNext: { $0.0.setupProfileFeedImage($0.1)})
            .disposed(by: disposeBag)
      
        reactor.state
          .map { $0.feedType == "mission" ? false : true }
          .bind(to: feedBadgeImageView.rx.isHidden)
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
        
        reactor.state
            .map { $0.commentCount }
            .asDriver(onErrorJustReturn: "")
            .drive(feedCommentCountLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$descrptionSection)
            .asDriver(onErrorJustReturn: [])
            .drive(descrptionCollectionView.rx.items(dataSource: descrptionDataSources))
            .disposed(by: disposeBag)
    }
    
    
    
    
}


extension ProfileFeedCollectionViewCell {
    private func setupProfileFeedImage(_ url: URL) {
        self.layoutIfNeeded()
        
        let processor = DownsamplingImageProcessor(size: feedImageView.bounds.size)
        
        feedImageView.kf.indicatorType = .activity
        feedImageView
            .kf
            .setImage(
                with: url, placeholder: nil,
                options: [
                    .processor(processor),
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.fade(0.5))
                ],
                completionHandler: nil
            )
    }
}


extension ProfileFeedCollectionViewCell: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        guard let descrptionCellCount = self.reactor?.currentState.content.count else {
            return .zero
        }
        
        let cellWidth = 17 * descrptionCellCount
        let spacingWidth = 2 * (descrptionCellCount - 1)
        let cellInset = (collectionView.frame.width - CGFloat(cellWidth + spacingWidth)) / 2
        return UIEdgeInsets(top: 0, left: cellInset, bottom: 0, right: cellInset)
    }
    
}
