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
        
        addSubviews(textStackView, imageView, emojiStackView)
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
    }
}

extension FeedDetailCollectionViewCell {
    private func setStack(emojis: [EmojiData]) {
        for emoji in emojis {
            let emojiView = EmojiView()
            emojiView.setInitEmoji(emoji: emoji)
            emojiStackView.addArrangedSubview(emojiView)
        }
    }
}

extension FeedDetailCollectionViewCell {
    func setCell(data: FeedDetailData) {
        nameLabel.text = data.writer
        timeLabel.text = data.time
        imageView.kf.setImage(with: URL(string: data.imageURL))
        setStack(emojis: data.emojis)
    }
}
