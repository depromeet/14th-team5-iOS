//
//  FeedDetailCollectionViewCell.swift
//  App
//
//  Created by 마경미 on 10.12.23.
//

import UIKit
import Core
import Domain
import DesignSystem

import RxSwift

final class PostCollectionViewCell: BaseCollectionViewCell<EmojiReactor> {
    static let id = "feedDetailCollectionViewCell"
    
    private let postImageView = UIImageView()
    /// 이모지를 선택하기 위한 버튼을 모아둔 stackView
    private let selectableEmojiStackView = UIStackView()
    private let showSelectableEmojiButton = UIButton()
    /// 이모지 카운트를 보여주기 위한 stackView
    private let emojiCountStackView = UIStackView()
    
    private let reactor = EmojiReactor()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        bind(reactor: reactor)
        setupSelectableEmojiStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func bind(reactor: EmojiReactor) {
        showSelectableEmojiButton.rx.tap
            .map { Reactor.Action.tappedSelectableEmojiStackView }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isShowingSelectableEmojiStackView }
            .distinctUntilChanged()
            .withUnretained(self)
            .bind(onNext: {
                $0.0.showSelectableEmojiStackView($0.1)
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .compactMap { $0.selectedEmoji }
            .distinctUntilChanged { $0 == $1 }
            .filter { $0.0 != nil }
            .bind(onNext: { [weak self] emoji, count in
                guard let self = self,
                      let emoji = emoji else {
                    return
                }
                self.selectEmoji(emoji: emoji, count: count)
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .compactMap { $0.unselectedEmoji }
            .distinctUntilChanged { $0 == $1 }
            .filter { $0.0 != nil }
            .bind(onNext: { [weak self] emoji, count in
                guard let self = self,
                      let emoji = emoji else {
                    return
                }
                self.unselectEmoji(emoji: emoji, count: count)
            })
            .disposed(by: disposeBag)
    }
    
    
    override func setupUI() {
        super.setupUI()
        
        addSubviews(postImageView, showSelectableEmojiButton, emojiCountStackView, selectableEmojiStackView)
    }

    override func setupAutoLayout() {
        super.setupAutoLayout()

        postImageView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(postImageView.snp.width)
            $0.top.equalToSuperview().inset(82)
        }
        
        showSelectableEmojiButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(36)
            $0.width.equalTo(42)
            $0.top.equalTo(postImageView.snp.bottom).offset(12)
        }
        
        emojiCountStackView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(postImageView.snp.bottom).offset(6)
            $0.height.equalTo(36)
        }
        
        selectableEmojiStackView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
//            $0.width.equalTo(290)
            $0.top.equalTo(emojiCountStackView.snp.bottom).offset(12)
            $0.height.equalTo(62)
        }
    }
    
    override func setupAttributes() {
        super.setupAttributes()
        
        postImageView.do {
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 24
        }
        
        selectableEmojiStackView.do {
            $0.layer.cornerRadius = 31
            $0.backgroundColor = DesignSystemAsset.black.color
            $0.distribution = .fillEqually
            $0.spacing = 16
            $0.isHidden = true
            $0.layoutMargins = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
            $0.isLayoutMarginsRelativeArrangement = true
        }
        
        showSelectableEmojiButton.do {
            $0.layer.cornerRadius = 18
            $0.setImage(DesignSystemAsset.addEmoji.image, for: .normal)
            $0.backgroundColor = UIColor(red: 0.141, green: 0.141, blue: 0.153, alpha: 0.5)
        }
        
        emojiCountStackView.do {
            $0.distribution = .fillEqually
            $0.backgroundColor = .clear
            $0.spacing = 15
            $0.layer.cornerRadius = 25
        }
    }
}

extension PostCollectionViewCell {
    private func showSelectableEmojiStackView(_ isShowing: Bool) {
        selectableEmojiStackView.isHidden = !isShowing
    }
    
    private func setupSelectableEmojiStackView() {
        Emojis.allEmojis.enumerated().forEach { index, emoji in
            let selectableEmojiButton = UIButton()
            selectableEmojiButton.setImage(emoji.emojiImage, for: .normal)
            selectableEmojiButton.tag = index
            selectableEmojiStackView.addArrangedSubview(selectableEmojiButton)
            bindButton(selectableEmojiButton)
        }
    }
    
    private func bindButton(_ button: UIButton) {
        button.rx.tap
            .throttle(RxConst.throttleInterval, scheduler: MainScheduler.instance)
            .map { Reactor.Action.tappedSelectableEmojiButton(Emojis.emoji(forIndex: button.tag)) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindButton(_ button: EmojiCountButton) {
        button.rx.tap
            .throttle(RxConst.throttleInterval, scheduler: MainScheduler.instance)
            .map { Reactor.Action.tappedSelectedEmojiCountButton(Emojis.emoji(forIndex: button.tag)) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func selectEmoji(emoji: Emojis, count: Int) {
        if let targetView = emojiCountStackView.arrangedSubviews.first(where: { $0.tag == emoji.emojiIndex }) {
            guard let emojiCountButton = targetView as? EmojiCountButton else {
                return
            }
            emojiCountButton.setCountLabel(count)
        } else {
            let emojiCountButton = EmojiCountButton()
            let stackLength = emojiCountStackView.arrangedSubviews.count
            emojiCountButton.tag = emoji.emojiIndex
            emojiCountButton.setInitEmoji(emoji: EmojiData(emoji: emoji, count: count))
            bindButton(emojiCountButton)
            emojiCountStackView.insertArrangedSubview(emojiCountButton, at: stackLength - 1)
        }
    }
    
    private func unselectEmoji(emoji: Emojis, count: Int) {
        if let targetView = emojiCountStackView.arrangedSubviews.first(where: { $0.tag == emoji.emojiIndex }) {
            guard let emojiCountButton = targetView as? EmojiCountButton else {
                return
            }
            if count <= 0 {
                emojiCountStackView.removeArrangedSubview(emojiCountButton)
                emojiCountButton.removeFromSuperview()
                return
            }
        } else {
           debugPrint("Cannot find emojiCountButton")
        }
    }
}

extension PostCollectionViewCell {
    func setCell(data: PostListData) {
        postImageView.kf.setImage(with: URL(string: data.imageURL))
    }
}
