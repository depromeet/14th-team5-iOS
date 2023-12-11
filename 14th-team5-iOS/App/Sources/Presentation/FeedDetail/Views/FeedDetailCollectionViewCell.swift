//
//  FeedDetailCollectionViewCell.swift
//  App
//
//  Created by 마경미 on 10.12.23.
//

import UIKit
import Core

import RxDataSources
import RxSwift

final class FeedDetailCollectionViewCell: BaseCollectionViewCell<EmojiReactor> {
    static let id = "feedDetailCollectionViewCell"
    
    private let stackView = UIStackView()
    private let nameLabel = UILabel()
    private let timeLabel = UILabel()
    private let imageView = UIImageView()
    private let imageTextLabel = UILabel()
    private let emojiCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewRightAlignedLayout())
    private let reactor = EmojiReactor()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        bind(reactor: reactor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupUI() {
        super.setupUI()
        
        addSubviews(stackView, imageView, emojiCollectionView)
        stackView.addArrangedSubviews(nameLabel, timeLabel)
    }
    
    override func bind(reactor: EmojiReactor) {
        Observable.just(SectionOfFeedDetail.sections)
            .bind(to: emojiCollectionView.rx.items(dataSource: createDataSource()))
            .disposed(by: disposeBag)
        
//        emojiCollectionView.rx.itemSelected
//            .withUnretained(self)
//            .bind(onNext: {
////                guard let cell = self.emojiCollectionView.cellForItem(at: $0.1) as? EmojiCollectionViewCell else {
////                    return 
////                }
////                cell.countLabel.text = "바꿨지용"
//            })
//            .disposed(by: disposeBag)
    }
    
    override func setupAutoLayout() {
        super.setupAutoLayout()
        
        stackView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(16)
        }
        
        imageView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(stackView.snp.bottom).offset(8)
        }
        
        emojiCollectionView.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    override func setupAttributes() {
        super.setupAttributes()
        
        stackView.do {
            $0.distribution = .fillEqually
            $0.spacing = 0
        }
        
        nameLabel.do {
            $0.textColor = .white
        }
        
        imageView.do {
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 24
        }
        
        emojiCollectionView.do {
            $0.delegate = self
            $0.backgroundColor = .clear
            $0.register(EmojiCollectionViewCell.self, forCellWithReuseIdentifier: EmojiCollectionViewCell.id)
        }
    }
}

extension FeedDetailCollectionViewCell {
    private func createDataSource() -> RxCollectionViewSectionedReloadDataSource<SectionModel<String, FeedDetailData>> {
        return RxCollectionViewSectionedReloadDataSource<SectionModel<String, FeedDetailData>>(
            configureCell: { dataSource, collectionView, indexPath, item in
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiCollectionViewCell.id, for: indexPath) as? EmojiCollectionViewCell else {
                    return UICollectionViewCell()
                }
                cell.setCell(emoji: item.emojis[indexPath.row])
                return cell
            })
    }
}

extension FeedDetailCollectionViewCell {
    func setCell(data: FeedDetailData) {
        nameLabel.text = data.writer
        timeLabel.text = data.time
        imageView.kf.setImage(with: URL(string: data.imageURL))
    }
}

extension FeedDetailCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 30)
    }
}
