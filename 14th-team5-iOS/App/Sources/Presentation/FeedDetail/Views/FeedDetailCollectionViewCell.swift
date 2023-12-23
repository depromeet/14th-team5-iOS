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
    
    private let postImageView = UIImageView()
    private let postDescriptionLabel = UILabel()
    /// 이모지를 선택하기 위한 버튼을 모아둔 stackView
    private let selectableEmojiStackView = UIStackView()
    private let showSelectableEmojiButton = UIButton()
    /// 이모지 카운트를 보여주기 위한 stackView
    private let emojiCountStackView = UIStackView()
    
    private let reactor = EmojiReactor()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        bind(reactor: reactor)
        setupSelectedEmojiCountStackView()
        setupSelectableEmojiStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupUI() {
        super.setupUI()
        
        addSubviews(postImageView, emojiCountStackView, selectableEmojiStackView)
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
            .map { $0.selectedEmoji }
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
            .map { $0.unselectedEmoji }
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
    
    override func setupAutoLayout() {
        super.setupAutoLayout()

        postImageView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalToSuperview().inset(82)
        }
        
        emojiCountStackView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(postImageView.snp.bottom).offset(6)
            $0.height.equalTo(30)
        }
        
        selectableEmojiStackView.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.height.equalTo(50)
        }
    }
    
    override func setupAttributes() {
        super.setupAttributes()
        
        postImageView.do {
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 24
        }
        
        selectableEmojiStackView.do {
            $0.distribution = .equalCentering
            $0.spacing = 5
            $0.isHidden = true
        }
        
        showSelectableEmojiButton.do {
            $0.setImage(DesignSystemAsset.addEmoji.image, for: .normal)
            $0.backgroundColor = .blue
        }
        
        emojiCountStackView.do {
            $0.distribution = .fillEqually
            $0.backgroundColor = UIColor(red: 0.192, green: 0.192, blue: 0.192, alpha: 1)
            $0.spacing = 15
            $0.layer.cornerRadius = 25
        }
    }
}

extension FeedDetailCollectionViewCell {
    private func showSelectableEmojiStackView(_ isShowing: Bool) {
        selectableEmojiStackView.isHidden = !isShowing
    }
    
    private func setupSelectedEmojiCountStackView() {
        emojiCountStackView.addArrangedSubview(showSelectableEmojiButton)
    }
    
    private func setupSelectableEmojiStackView() {
        Emojis.allEmojis.enumerated().forEach { index, emoji in
            let selectableEmojiButton = SelectableEmojiButton()
            selectableEmojiButton.setEmoji(emoji: emoji)
            selectableEmojiButton.tag = index + 1
            selectableEmojiStackView.addArrangedSubview(selectableEmojiButton)
            bindButton(selectableEmojiButton)
        }
    }
    
    private func bindButton(_ button: SelectableEmojiButton) {
        button.rx.tap
            .debug("selectable")
            .throttle(RxConst.throttleInterval, scheduler: MainScheduler.instance)
            .map { Reactor.Action.tappedSelectableEmojiButton(Emojis.emoji(forIndex: button.tag)) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindButton(_ button: EmojiCountButton) {
        button.rx.tap
            .debug("selected")
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

extension FeedDetailCollectionViewCell {
    func setCell(data: FeedDetailData) {
        //        nameLabel.text = data.writer
        //        timeLabel.text = data.time
        postImageView.kf.setImage(with: URL(string: data.imageURL))
        //        setEmojiCountStack(emojis: data.emojis)
    }
}
