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
    typealias Layout = PostAutoLayout.CollectionView.CollectionViewCell.EmojiCountStackView.EmojiCountButton
    
    private let emojiImageView = UIImageView()
    private let countLabel = BibbiLabel(.body1Regular, alignment: .right)
    
    var isSelected: Bool = false {
        didSet {
            if isSelected {
                setSelected()
            } else {
                setUnSelected()
            }
        }
    }
    
    convenience init(reactor: Reactor) {
        self.init(frame: .zero)
        self.reactor = reactor
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func bind(reactor: EmojiReactor) {
        self.rx.tap
            .throttle(RxConst.throttleInterval, scheduler: MainScheduler.instance)
            .map { Reactor.Action.tappedSelectedEmojiCountButton(Emojis.emoji(forIndex: self.tag)) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        self.rx.longPress
            .map { Reactor.Action.longPressedEmojiCountButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    override func setupUI() {
        addSubviews(emojiImageView, countLabel)
    }
    
    override func setupAutoLayout() {
        emojiImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(Layout.EmojiImageView.leadingInset)
            $0.size.equalTo(Layout.EmojiImageView.size)
            $0.centerY.equalToSuperview()
        }
        
        countLabel.snp.makeConstraints {
            $0.leading.equalTo(emojiImageView.snp.trailing).offset(Layout.CountLabel.leadingOffset)
            $0.trailing.equalToSuperview().inset(Layout.CountLabel.trailingInset)
            $0.width.equalTo(Layout.CountLabel.width)
            $0.centerY.equalToSuperview()
        }
    }
    
    override func setupAttributes() {
        backgroundColor =  UIColor(red: 0.141, green: 0.141, blue: 0.153, alpha: 0.5)
        layer.cornerRadius = Layout.cornerRadius
    }
}

extension EmojiCountButton {
    private func setUnSelected() {
        backgroundColor =  UIColor(red: 0.141, green: 0.141, blue: 0.153, alpha: 0.5)
        layer.borderWidth = 0
    }
    
    private func setSelected() {
        backgroundColor = .gray800
        layer.borderWidth = 1
        layer.borderColor = UIColor(red: 0.318, green: 0.318, blue: 0.333, alpha: 1).cgColor
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
