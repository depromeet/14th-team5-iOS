//
//  EmojiView.swift
//  App
//
//  Created by 마경미 on 10.12.23.
//

import UIKit
import Core

import RxSwift

final class EmojiView: BaseView<EmojiReactor> {
    private let emojiLabel = UILabel()
    private let countLabel = UILabel()
    
    private let tapSubject = PublishSubject<Void>()
    lazy var tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
    
    var tapObservable: Observable<Void> {
        return tapSubject.asObservable()
    }
    
    override func setupUI() {
        addSubviews(emojiLabel, countLabel)
        addGestureRecognizer(tapGesture)
    }
    
    override func bind(reactor: EmojiReactor) {
        
    }
    
    override func setupAutoLayout() {
        emojiLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(9)
            $0.width.equalTo(16)
            $0.centerY.equalToSuperview()
        }
        
        countLabel.snp.makeConstraints {
            $0.leading.equalTo(emojiLabel.snp.trailing)
            $0.trailing.equalToSuperview().inset(5)
            $0.width.equalTo(20)
            $0.centerY.equalToSuperview()
        }
    }
    
    override func setupAttributes() {
        isUserInteractionEnabled = true
        backgroundColor =  UIColor(red: 0.192, green: 0.192, blue: 0.192, alpha: 1)
        layer.cornerRadius = 15
        
        countLabel.do {
            $0.textColor = .white
        }
    }
}

extension EmojiView {
    @objc private func handleTap() {
        tapSubject.onNext(())
    }
}

extension EmojiView {
    func setInitEmoji(emoji: EmojiData) {
        emojiLabel.text = emoji.emoji
        countLabel.text = "\(emoji.count)"
    }
}
