//
//  FeedDetailCollectionViewCell.swift
//  App
//
//  Created by 마경미 on 10.12.23.
//

import UIKit
import Core
import DesignSystem

import RxSwift

final class FeedDetailCollectionViewCell: BaseCollectionViewCell<EmojiReactor> {
    static let id = "feedDetailCollectionViewCell"
    
    private let textStackView = UIStackView()
    private let nameLabel = UILabel()
    private let timeLabel = UILabel()
    private let imageView = UIImageView()
    private let imageTextLabel = UILabel()
    private let standardEmojiStackView = UIStackView()
    private let addEmojiButton = UIButton()
    private let emojiCountStackView = UIStackView()
    
    private let reactor = EmojiReactor()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        bind(reactor: reactor)
        setStandardEmojiStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupUI() {
        super.setupUI()
        
        addSubviews(textStackView, imageView, emojiCountStackView, standardEmojiStackView)
        textStackView.addArrangedSubviews(nameLabel, timeLabel)
    }
    
    override func bind(reactor: EmojiReactor) {
        addEmojiButton.rx.tap
            .map { Reactor.Action.tapAddEmojiButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isShowingStandardEmojiView }
            .distinctUntilChanged()
            .withUnretained(self)
            .bind(onNext: {
                $0.0.showStandardEmojiStackView($0.1)
            })
            .disposed(by: disposeBag)
        
//        reactor.state
//            .map { $0.emojiData }
////            .distinctUntilChanged()
//            .withUnretained(self)
//            .bind(onNext: {
////                $0.0.updateEmojiCount($0.1)
//            })
//            .disposed(by: disposeBag)
    }
    
    override func setupAutoLayout() {
        super.setupAutoLayout()
        
        textStackView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(16)
        }
        
        imageView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(textStackView.snp.bottom).offset(8)
        }
        
        emojiCountStackView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(imageView.snp.bottom).offset(6)
            $0.height.equalTo(30)
        }
        
        standardEmojiStackView.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.height.equalTo(50)
        }
    }
    
    override func setupAttributes() {
        super.setupAttributes()
        
        textStackView.do {
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
        
        standardEmojiStackView.do {
            $0.distribution = .equalCentering
            $0.spacing = 5
            $0.isHidden = true
        }
        
        addEmojiButton.do {
            $0.setImage(DesignSystemAsset.addEmoji.image, for: .normal)
            $0.backgroundColor = .blue
        }
        
        emojiCountStackView.do {
            $0.distribution = .fillEqually
            $0.backgroundColor = UIColor(red: 0.192, green: 0.192, blue: 0.192, alpha: 1)
            $0.spacing = 15
            $0.layer.cornerRadius = 25
            $0.addArrangedSubview(addEmojiButton)
        }
    }
}

extension FeedDetailCollectionViewCell {
    private func showStandardEmojiStackView(_ isShowing: Bool) {
        standardEmojiStackView.isHidden = !isShowing
    }
    
    private func setEmojiCountStackView(emojis: [EmojiData]) {
        for emoji in emojis {
            let emojiView = EmojiCountButton()
            emojiView.setInitEmoji(emoji: emoji)
            emojiCountStackView.addArrangedSubview(emojiView)
        }
    }
    
    private func setStandardEmojiStackView() {
        Emojis.allEmojis.enumerated().forEach { index, emoji in
            let button = StandardEmojiButton()
            button.setEmoji(emoji: emoji)
            button.tag = index
            standardEmojiStackView.addArrangedSubview(button)
            bindButton(button)
        }
    }
    
    private func bindButton(_ button: StandardEmojiButton) {
        button.rx.tap
            .map { Reactor.Action.standardEmojiButtonTapped(Emojis.emoji(forIndex: button.tag)) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
//        // 통신 이후에 수정하기
//        reactor.state
//            .map { $0.emojiCount }
//            .withUnretained(self)
//            .bind(onNext: {
//                print($0.1)
////                self.updateEmojiCount(index: 0, count: $0.1)
//            })
//            .disposed(by: disposeBag)
    }
    
//    private func updateEmojiCount(_ data: [EmojiData]) {
        
//    }
}

extension FeedDetailCollectionViewCell {
    func setCell(data: FeedDetailData) {
        nameLabel.text = data.writer
        timeLabel.text = data.time
        imageView.kf.setImage(with: URL(string: data.imageURL))
//        setEmojiCountStack(emojis: data.emojis)
    }
}
