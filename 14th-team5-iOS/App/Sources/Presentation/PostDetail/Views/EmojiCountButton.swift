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
    
    private enum GestureType {
        case tap
        case longPress
    }
    
    private let emojiImageView = UIImageView()
    private let countLabel = BibbiLabel(.body1Regular, alignment: .right)
    private let tapGesture = UITapGestureRecognizer()
    private let longPressGesture = UILongPressGestureRecognizer()
    
    let selectedRelay: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    convenience init(reactor: Reactor) {
        self.init(frame: .zero)
        self.reactor = reactor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addGestureRecognizer(tapGesture)
        self.addGestureRecognizer(longPressGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func bind(reactor: EmojiReactor) {
        tapGesture.rx.event
            .throttle(RxConst.throttleInterval, scheduler: MainScheduler.instance)
            .map { _ in Reactor.Action.tappedSelectedEmojiCountButton(Emojis.emoji(forIndex: self.tag)) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        longPressGesture.rx.event
            .map { _ in Reactor.Action.longPressedEmojiCountButton(self.tag) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        longPressGesture.rx.event
            .asObservable()
            .map { $0.state }
            .withUnretained(self) { ($0, $1) }
            .bind(onNext: { $0.0.tapGesture.isEnabled = $0.1 == .ended })
            .disposed(by: disposeBag)
        
        selectedRelay
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .bind(onNext: { $0.0.setSelected($0.1) })
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
    private func setSelected(_ isSelected: Bool) {
        let alpha = isSelected ? 1: 0.5
        let borderWidth: CGFloat = isSelected ? 1 : 0
        
        backgroundColor =  UIColor(red: 0.141, green: 0.141, blue: 0.153, alpha: alpha)
        layer.borderWidth = borderWidth
        layer.borderColor = UIColor(red: 0.908, green: 0.908, blue: 0.908, alpha: 1).cgColor
    }
}

extension EmojiCountButton {
    func setInitEmoji(emoji: EmojiData) {
        emojiImageView.image = emoji.emoji.emojiImage
        countLabel.text = "\(emoji.count)"
    }
}
