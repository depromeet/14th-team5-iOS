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

import Kingfisher
import RxSwift
import RxDataSources

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
    
    private let contentCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    private let collectionViewFlowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    private lazy var contentDatasource = createContentDataSource()
    
//    let reactor: EmojiReactor? = nil
    
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
            .take(1)
            .map { Reactor.Action.fetchEmojiList }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        Observable.just(())
            .take(1)
            .map { Reactor.Action.fetchDisplayContent(reactor.currentState.post.content) }
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
            .map { $0.post }
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe {
                $0.0.postImageView.kf.setImage(
                    with: URL(string: $0.1.imageURL),
                    options: [
                        .transition(.fade(0.15))
                    ]
                )
                
                guard let author = $0.1.author else { return }
                guard let profileImageUrl = $0.1.author?.profileImageURL else { return }
                $0.0.nickNameLabel.text = author.name
                $0.0.profileImageView.kf.setImage(
                    with: URL(string: profileImageUrl),
                    options: [
                        .transition(.fade(0.15))
                    ]
                )
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.fetchedDisplayContent }
            .bind(to: contentCollectionView.rx.items(dataSource: contentDatasource))
            .disposed(by: disposeBag)
    }
    
    
    override func setupUI() {
        super.setupUI()
        addSubviews(profileStackView, postImageView, showSelectableEmojiButton, emojiCountStackView, selectableEmojiStackView)
        profileStackView.addArrangedSubviews(profileImageView, nickNameLabel)
        postImageView.addSubview(contentCollectionView)
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
        
        contentCollectionView.snp.makeConstraints {
            $0.height.equalTo(41)
            $0.bottom.equalTo(postImageView.snp.bottom).offset(-20)
            $0.horizontalEdges.equalToSuperview()
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
            $0.text = "(알 수 없음)"
        }
        
        postImageView.do {
            $0.clipsToBounds = true
            $0.layer.cornerRadius = Layout.PostImageView.cornerRadius
        }
        
        contentCollectionView.do {
            $0.backgroundColor = .clear
            $0.isScrollEnabled = false
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
            $0.collectionViewLayout = collectionViewFlowLayout
            $0.register(DisplayEditCollectionViewCell.self, forCellWithReuseIdentifier: "DisplayEditCollectionViewCell")
            $0.delegate = self
        }
        
        collectionViewFlowLayout.do {
            $0.itemSize = CGSize(width: 28, height: 41)
            $0.minimumInteritemSpacing = 2
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
    private func createContentDataSource() -> RxCollectionViewSectionedReloadDataSource<DisplayEditSectionModel> {
        return RxCollectionViewSectionedReloadDataSource<DisplayEditSectionModel> { datasources, collectionView, indexPath, sectionItem in
            switch sectionItem {
            case let .fetchDisplayItem(cellReactor):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DisplayEditCollectionViewCell", for: indexPath) as? DisplayEditCollectionViewCell else {
                    return UICollectionViewCell()
                }
                cell.reactor = cellReactor
                return cell
            }
        }
    }
}

extension PostCollectionViewCell: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        guard let cellCount = reactor?.currentState.post.content.count else {
            return .zero
        }
        
        let totalCellWidth = 28 * cellCount
        let totalSpacingWidth = 2 * (cellCount - 1)

        let leftInset = (collectionView.frame.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
        let rightInset = leftInset

        return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
    }
}

extension PostCollectionViewCell {
    func setCell(data: PostListData) {
        postImageView.kf.setImage(with: URL(string: data.imageURL))
    }
}
