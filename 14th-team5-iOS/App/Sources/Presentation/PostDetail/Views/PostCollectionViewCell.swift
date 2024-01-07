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
import Kingfisher

final class PostCollectionViewCell: BaseCollectionViewCell<EmojiReactor> {
    typealias Layout = PostAutoLayout.CollectionView.CollectionViewCell
    static let id = "postCollectionViewCell"
    
    private let profileStackView = UIStackView()
    private let profileImageView = UIImageView()
    private let nickNameLabel = BibbiLabel(.caption, textColor: .gray200)
    
    private let postImageView = UIImageView()
    /// 이모지를 선택하기 위한 버튼을 모아둔 stackView
    private let selectableEmojiStackView = UIStackView()
    private let showSelectableEmojiButton = UIButton()
    /// 이모지 카운트를 보여주기 위한 stackView
    private let emojiCountStackView = UIStackView()
    
    let reactor: EmojiReactor? = nil
    
    convenience init(reacter: EmojiReactor? = nil) {
        self.init(frame: .zero)
        self.reactor = reacter
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func bind(reactor: EmojiReactor) {
        
        setupSelectableEmojiStackView(reactor: reactor)
        
        showSelectableEmojiButton.rx.tap
            .map { Reactor.Action.tappedSelectableEmojiStackView }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        Observable.just(())
            .map { Reactor.Action.fetchEmojiList }
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
            .compactMap { $0.fetchedEmojiList }
            .distinctUntilChanged { $0.emojis_memberIds == $1.emojis_memberIds }
            .withUnretained(self)
            .bind(onNext: {
                $0.0.setEmojiCountStackView(reactor: reactor, emojiList: $0.1)
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.type }
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe {
                if $0.1 == .calendar {
                    $0.0.profileStackView.isHidden = false
                    
                    $0.0.profileStackView.snp.updateConstraints {
                        $0.top.equalToSuperview()
                    }
                }
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .debug("============================ 이미지 처리")
            .map { $0.imageUrl }
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe {
                $0.0.postImageView.kf.setImage(
                    with: URL(string: $0.1),
                    options: [
                        .transition(.fade(0.15))
                    ]
                )
            }
            .disposed(by: disposeBag)
        
        // TODO: - MemeberId에 맞게 프로필 이미지 및 닉네임 집어넣기
    }
    
    
    override func setupUI() {
        super.setupUI()
        addSubviews(profileStackView, postImageView, showSelectableEmojiButton, emojiCountStackView, selectableEmojiStackView)
        profileStackView.addArrangedSubviews(profileImageView, nickNameLabel)
    }

    override func setupAutoLayout() {
        super.setupAutoLayout()

        profileStackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.top.equalToSuperview().offset(Layout.PostImageView.topInset - (34 + 8))
            $0.height.equalTo(34)
        }
        
        profileImageView.snp.makeConstraints {
            $0.width.height.equalTo(34)
        }
        
        postImageView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(postImageView.snp.width)
            $0.top.equalTo(profileStackView.snp.bottom).offset(8)
        }
        
        showSelectableEmojiButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(Layout.ShowSelectableEmojiButton.trailingInset)
            $0.height.equalTo(Layout.ShowSelectableEmojiButton.height)
            $0.width.equalTo(Layout.ShowSelectableEmojiButton.width)
            $0.top.equalTo(postImageView.snp.bottom).offset(Layout.ShowSelectableEmojiButton.topOffset)
        }
        
        emojiCountStackView.snp.makeConstraints {
            $0.trailing.equalTo(showSelectableEmojiButton.snp.leading).offset(Layout.EmojiCountStackView.trailingOffset)
            $0.top.equalTo(postImageView.snp.bottom).offset(Layout.EmojiCountStackView.topOffset)
            $0.height.equalTo(Layout.EmojiCountStackView.height)
        }
        
        selectableEmojiStackView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(Layout.SelectableEmojiStackView.trailingInset)
            $0.top.equalTo(emojiCountStackView.snp.bottom).offset(Layout.SelectableEmojiStackView.topOffset)
            $0.height.equalTo(Layout.SelectableEmojiStackView.height)
        }
    }
    
    override func setupAttributes() {
        super.setupAttributes()
        
        profileStackView.do {
            $0.axis = .horizontal
            $0.spacing = 12.0
            $0.isHidden = true
        }
        
        profileImageView.do {
            $0.image = DesignSystemAsset.emoji1.image
            $0.contentMode = .scaleAspectFill
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = 34.0 / 2.0
        }
        
        nickNameLabel.do {
            $0.text = "김건우"
        }
        
        postImageView.do {
            $0.clipsToBounds = true
            $0.layer.cornerRadius = Layout.PostImageView.cornerRadius
        }
        
        selectableEmojiStackView.do {
            $0.layer.cornerRadius = Layout.SelectableEmojiStackView.cornerRadius
            $0.backgroundColor = DesignSystemAsset.black.color
            $0.distribution = .fillEqually
            $0.spacing = Layout.SelectableEmojiStackView.spacing
            $0.isHidden = true
            $0.layoutMargins = Layout.SelectableEmojiStackView.layoutMargins
            $0.isLayoutMarginsRelativeArrangement = true
        }
        
        showSelectableEmojiButton.do {
            $0.layer.cornerRadius = Layout.ShowSelectableEmojiButton.cornerRadius
            $0.setImage(DesignSystemAsset.addEmoji.image, for: .normal)
            $0.backgroundColor = UIColor(red: 0.141, green: 0.141, blue: 0.153, alpha: 0.5)
        }
        
        emojiCountStackView.do {
            $0.distribution = .fillEqually
            $0.backgroundColor = .clear
            $0.spacing = Layout.EmojiCountStackView.spacing
            $0.layer.cornerRadius = Layout.EmojiCountStackView.cornerRadius
        }
    }
}

extension PostCollectionViewCell {
    private func showSelectableEmojiStackView(_ isShowing: Bool) {
        selectableEmojiStackView.isHidden = !isShowing
    }
    
    private func setupSelectableEmojiStackView(reactor: EmojiReactor) {
        Emojis.allEmojis.enumerated().forEach { index, emoji in
            let selectableEmojiButton = UIButton()
            selectableEmojiButton.setImage(emoji.emojiImage, for: .normal)
            selectableEmojiButton.tag = index + 1
            selectableEmojiStackView.addArrangedSubview(selectableEmojiButton)
            bindButton(reactor: reactor, selectableEmojiButton)
        }
    }
    
    private func bindButton(reactor: EmojiReactor, _ button: UIButton) {
        button.rx.tap
            .throttle(RxConst.throttleInterval, scheduler: MainScheduler.instance)
            .map { Reactor.Action.tappedSelectableEmojiButton(Emojis.emoji(forIndex: button.tag)) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func setEmojiCountStackView(reactor: EmojiReactor, emojiList: FetchEmojiDataList) {
        for subview in emojiCountStackView.subviews {
            subview.removeFromSuperview()
        }
        
        for (index, emojiData) in emojiList.emojis_memberIds.enumerated() {
            if emojiData.count == 0 {
                continue
            }
            
            let emojiCountButton = EmojiCountButton(reactor: reactor)
            emojiCountButton.tag = index + 1
            emojiCountButton.isSelected = emojiData.isSelfSelected
            emojiCountButton.setInitEmoji(emoji: EmojiData(emoji: Emojis.emoji(forIndex: index+1), count: emojiData.count))
            emojiCountStackView.addArrangedSubview(emojiCountButton)
        }
    }
}

extension PostCollectionViewCell {
    func setCell(data: PostListData) {
        postImageView.kf.setImage(with: URL(string: data.imageURL))
    }
}
