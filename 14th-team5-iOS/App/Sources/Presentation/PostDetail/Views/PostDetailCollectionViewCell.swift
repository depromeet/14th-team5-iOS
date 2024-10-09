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

final class PostDetailCollectionViewCell: BaseCollectionViewCell<PostDetailViewReactor> {
    typealias Layout = PostAutoLayout.CollectionView.CollectionViewCell
    static let id = "postCollectionViewCell"
    
    private let profileStackView = UIStackView()
    private let containerView = UIView()
    private let profileImageView = UIImageView()
    private let firstNameLabel = BBLabel(.caption, textColor: .bibbiWhite)
    private let userNameLabel = BBLabel(.caption, textColor: .gray200)
    private let postImageView = UIImageView(image: DesignSystemAsset.emptyCaseGraphicEmoji.image)
    private let missionTextView = MissionTextView()
    private let contentCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let collectionViewFlowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    
    private lazy var contentDatasource = createContentDataSource()
    
    convenience init(reacter: PostDetailViewReactor? = nil) {
        self.init(frame: .zero)
        self.reactor = reacter
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        userNameLabel.text = .unknown
        firstNameLabel.text = "알"
        profileImageView.image = nil
        postImageView.image = nil
    }
    
    override func bind(reactor: PostDetailViewReactor) {
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    
    override func setupUI() {
        super.setupUI()
        addSubviews(profileStackView, postImageView)
        containerView.addSubviews(firstNameLabel, profileImageView)
        profileStackView.addArrangedSubviews(containerView, userNameLabel)
        postImageView.addSubviews(contentCollectionView, missionTextView)
    }
    
    override func setupAutoLayout() {
        super.setupAutoLayout()
        
        profileStackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.top.equalToSuperview().offset(Layout.PostImageView.topInset - (34 + 8))
            $0.height.equalTo(34)
        }
        
        containerView.snp.makeConstraints {
            $0.size.equalTo(34)
        }
        
        firstNameLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        profileImageView.snp.makeConstraints {
            $0.size.equalTo(34)
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
        
        missionTextView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.horizontalEdges.equalToSuperview().inset(32)
            $0.height.equalTo(41)
        }
    }
    
    override func setupAttributes() {
        super.setupAttributes()
        
        profileStackView.do {
            $0.axis = .horizontal
            $0.spacing = 12.0
            $0.isHidden = true
        }
        
        containerView.do {
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = 34 / 2
            $0.backgroundColor = UIColor.gray800
            $0.isUserInteractionEnabled = true
        }
        
        profileImageView.do {
            $0.contentMode = .scaleAspectFill
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = 34.0 / 2.0
        }
        
        userNameLabel.do {
            $0.text = .unknown
        }
        
        firstNameLabel.do {
            $0.text = "알"
        }
        
        postImageView.do {
            $0.clipsToBounds = true
            $0.backgroundColor = .gray100
            $0.contentMode = .scaleAspectFill
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
    }
}

extension PostDetailCollectionViewCell {
    private func bindInput(reactor: PostDetailViewReactor) {
        Observable.just(())
            .take(1)
            .map { Reactor.Action.fetchDisplayContent(reactor.currentState.post.content ?? "") }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        containerView.rx.tap
            .throttle(RxConst.milliseconds300Interval, scheduler: RxSchedulers.main)
            .map { Reactor.Action.didTapProfileImageView }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
    }
    
    private func bindOutput(reactor: PostDetailViewReactor) {
        
        reactor.state.map { $0.missionContent }
            .distinctUntilChanged()
            .bind(to: missionTextView.missionLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.missionContent.isEmpty }
            .distinctUntilChanged()
            .bind(to: missionTextView.rx.isHidden)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.post }
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe { $0.0.setupProfileNameAndImage(post: $0.1) }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.fetchedDisplayContent }
            .bind(to: contentCollectionView.rx.items(dataSource: contentDatasource))
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.post.author.name[0] ?? "알" }
            .distinctUntilChanged()
            .bind(to: firstNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.type }
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
        
        reactor.pulse(\.$shouldPushProfileViewController)
            .compactMap { $0 }
            .bind(with: self) { owner, memberId in
                
            }
            .disposed(by: disposeBag)
    }
}

extension PostDetailCollectionViewCell {
    private func setupProfileNameAndImage(post: PostEntity) {
        postImageView.kf.setImage(
            with: URL(string: post.imageURL),
            options: [
                .transition(.fade(0.15))
            ]
        )
        
        if let imageUrl = post.author.profileImageURL {
            profileImageView.kf.setImage(
                with: URL(string: imageUrl),
                options: [
                    .transition(.fade(0.15))
                ]
            )
        }
        
        userNameLabel.text = post.author.name
        
    }
}

extension PostDetailCollectionViewCell {
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

extension PostDetailCollectionViewCell: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        guard let cellCount = reactor?.currentState.post.content?.count else {
            return .zero
        }
        
        let totalCellWidth = 28 * cellCount
        let totalSpacingWidth = 2 * (cellCount - 1)
        
        let leftInset = (collectionView.frame.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
        let rightInset = leftInset
        
        return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
    }
}



extension PostDetailCollectionViewCell {
    func setCell(data: PostEntity) {
        postImageView.kf.setImage(with: URL(string: data.imageURL))
    }
}
