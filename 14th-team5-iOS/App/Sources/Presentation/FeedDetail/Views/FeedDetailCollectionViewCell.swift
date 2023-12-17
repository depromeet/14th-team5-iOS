//
//  FeedDetailCollectionViewCell.swift
//  App
//
//  Created by 마경미 on 10.12.23.
//

import UIKit
import Core

import RxSwift

final class FeedDetailCollectionViewCell: BaseCollectionViewCell<EmojiReactor> {
    static let id = "feedDetailCollectionViewCell"
    
    private let textStackView = UIStackView()
    private let nameLabel = UILabel()
    private let timeLabel = UILabel()
    private let imageView = UIImageView()
    private let imageTextLabel = UILabel()
    private let emojiStackView = UIStackView()
    private let selectEmojiView = UIStackView()
    
    private let reactor = EmojiReactor()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        bind(reactor: reactor)
        setStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupUI() {
        super.setupUI()
        
        addSubviews(textStackView, imageView, emojiStackView, selectEmojiView)
        textStackView.addArrangedSubviews(nameLabel, timeLabel)
    }
    
    override func bind(reactor: EmojiReactor) {
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
        
        emojiStackView.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.top.equalTo(imageView.snp.bottom).offset(6)
            $0.height.equalTo(30)
        }
        
        selectEmojiView.snp.makeConstraints {
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
        
        emojiStackView.do {
            $0.distribution = .equalCentering
            $0.spacing = 5
        }
        
        selectEmojiView.do {
            //            $0.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            $0.distribution = .fillEqually
            $0.backgroundColor = UIColor(red: 0.192, green: 0.192, blue: 0.192, alpha: 1)
            $0.spacing = 15
            $0.layer.cornerRadius = 25
        }
    }
}

extension FeedDetailCollectionViewCell {
    private func setEmojiCountStack(emojis: [EmojiData]) {
        for emoji in emojis {
            let emojiView = EmojiView()
            emojiView.setInitEmoji(emoji: emoji)
            emojiStackView.addArrangedSubview(emojiView)
        }
    }
    
    private func setStackView() {
        Emojis.allEmojis.enumerated().forEach { index, emoji in
            let button = EmojiButton()
            button.setEmoji(emoji: emoji)
            button.tag = index
            selectEmojiView.addArrangedSubview(button)
            bindButton(button)
        }
    }
    
    private func bindButton(_ button: EmojiButton) {
        button.rx.tap
            .map { Reactor.Action.emojiButtonTapped(button.tag) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 통신 이후에 수정하기
        reactor.state
            .map { $0.emojiCount }
            .withUnretained(self)
            .bind(onNext: {
                print($0.1)
//                self.updateEmojiCount(index: 0, count: $0.1)
            })
            .disposed(by: disposeBag)
    }
    
//    private func updateEmojiCount(index: Int, count: Int) {
//        guard let emojiView = emojiStackView.arrangedSubviews[index] as? EmojiView else {
//            return
//        }
//        emojiView.setCountLabel(count)
//    }
}

extension FeedDetailCollectionViewCell {
    func setCell(data: FeedDetailData) {
        nameLabel.text = data.writer
        timeLabel.text = data.time
        imageView.kf.setImage(with: URL(string: data.imageURL))
        setEmojiCountStack(emojis: data.emojis)
    }
}
