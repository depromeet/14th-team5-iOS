//
//  EmojiView.swift
//  App
//
//  Created by 마경미 on 10.12.23.
//

import UIKit
import Core
import Domain

import RxSwift
import RxCocoa

/// 포스트 자세히 보기 - 추가된 이모지 (해제만 가능)
final class EmojiCountButton: BaseView<EmojiReactor> {
    private let emojiImageView = UIImageView()
    private let countLabel = UILabel()
    
    override func setupUI() {
        addSubviews(emojiImageView, countLabel)
    }
    
    override func bind(reactor: EmojiReactor) {
        
    }
    
    override func setupAutoLayout() {
        emojiImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(9)
            $0.width.equalTo(16)
            $0.centerY.equalToSuperview()
        }
        
        countLabel.snp.makeConstraints {
            $0.leading.equalTo(emojiImageView.snp.trailing)
            $0.trailing.equalToSuperview().inset(5)
            $0.width.equalTo(20)
            $0.centerY.equalToSuperview()
        }
    }
    
    override func setupAttributes() {
        backgroundColor =  UIColor(red: 0.192, green: 0.192, blue: 0.192, alpha: 1)
        layer.cornerRadius = 15
        
        countLabel.do {
            $0.textColor = .white
        }
    }
}

extension EmojiCountButton {
    func setInitEmoji(emoji: EmojiData) {
        emojiImageView.image = emoji.emoji.emojiImage
        countLabel.text = "\(emoji.count)"
    }
    
    func setCountLabel(_ count: Int) {
        countLabel.text = "\(count)"
    }
}

