//
//  CalendarPostCell.swift
//  App
//
//  Created by 김건우 on 5/7/24.
//

import Core
import Domain
import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa
import RxDataSources
import Kingfisher

final class CalendarPostCell: BaseCollectionViewCell<CalendarPostCellReactor> {
    
    // MARK: - Id
    static let id = "CalendarPostCell"
    
    // MARK: - Views
    private let authorStackView: UIStackView = UIStackView()
    private let authorImageContainerView: UIView = UIView()
    private let authorImageView: UIImageView = UIImageView()
    private let authorNameLabel: BibbiLabel = BibbiLabel(.caption, textColor: .gray200)
    private let authorFirstNameLabel: BibbiLabel = BibbiLabel(.caption, textColor: .bibbiWhite)
    private let postImageView: UIImageView = UIImageView()
    private let missionTextView: MissionTextView = MissionTextView()
    private let contentCollectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    
    // MARK: - Properties
    private lazy var datasource = prepareContentDatasource()
    private let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    
    // MARK: - Intializer
    
    
    // MARK: - LifeCycles
    override func prepareForReuse() {
        super.prepareForReuse()
        authorNameLabel.text = .unknown
        authorFirstNameLabel.text = "알"
        authorImageView.image = nil
        postImageView.image = nil
    }
    
    // MARK: - Helpers
    override func bind(reactor: CalendarPostCellReactor) {
        super.bind(reactor: reactor)
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    private func bindInput(reactor: CalendarPostCellReactor) {
        Observable<Void>.just(())
            .flatMap { _ in
                Observable<Reactor.Action>.concat(
                    Observable<Reactor.Action>.just(.displayContent),
                    Observable<Reactor.Action>.just(.requestAuthorName),
                    Observable<Reactor.Action>.just(.requestAuthorImageUrl)
                )
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        authorImageContainerView.rx.tap
            .throttle(RxConst.throttleInterval, scheduler: Schedulers.main)
            .map { Reactor.Action.writerImageButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: CalendarPostCellReactor) {
        
        let post = reactor.state.map { $0.post }
            .asDriver(onErrorDriveWith: .empty())
        
        post
            .distinctUntilChanged()
            .drive(with: self) { owner, post in
                owner.postImageView.kf.setImage(
                    with: URL(string: post.postImageUrl),
                    options: [.transition(.fade(0.15))]
                )
            }
            .disposed(by: disposeBag)
        
        post
            .map { _ in /*$0.missionContent*/ "정신차려~" }
            .distinctUntilChanged()
            .drive(missionTextView.missionLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.authorName }
            .distinctUntilChanged()
            .bind(to: authorNameLabel.rx.text)
            .disposed(by: disposeBag)

        reactor.state.compactMap { $0.authorName }
            .map { String($0.first ?? Character(" ")) }
            .distinctUntilChanged()
            .bind(to: authorFirstNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.compactMap { $0.authorImageUrl }
            .distinctUntilChanged()
            .bind(with: self) { owner, url in
                owner.authorImageView.kf.setImage(
                    with: URL(string: url)
                )
            }
            .disposed(by: disposeBag)
        
        reactor.state.compactMap { $0.content }
            .bind(to: contentCollectionView.rx.items(dataSource: datasource))
            .disposed(by: disposeBag)
    }
    
    override func setupUI() {
        super.setupUI()
        
        contentView.addSubviews(authorStackView, postImageView)
        authorImageContainerView.addSubviews(authorFirstNameLabel, authorImageView)
        authorStackView.addArrangedSubviews(authorImageContainerView, authorNameLabel)
        postImageView.addSubviews(contentCollectionView, missionTextView)
    }
    
    override func setupAutoLayout() {
        super.setupAutoLayout()
        
        authorStackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(34)
        }
        
        authorImageContainerView.snp.makeConstraints {
            $0.size.equalTo(34)
        }
        
        authorFirstNameLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        authorImageView.snp.makeConstraints {
            $0.size.equalTo(34)
        }
        
        contentCollectionView.snp.makeConstraints {
            $0.height.equalTo(41)
            $0.bottom.equalTo(postImageView.snp.bottom).offset(-20)
            $0.horizontalEdges.equalToSuperview()
        }
        
        missionTextView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.horizontalEdges.equalToSuperview().inset(32)
            $0.height.equalTo(41)
        }
        
        postImageView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(postImageView.snp.width)
            $0.top.equalTo(authorStackView.snp.bottom).offset(8)
        }
    }
    
    override func setupAttributes() {
        super.setupAttributes()
        
        authorStackView.do {
            $0.axis = .horizontal
            $0.spacing = 12
        }
        
        authorImageContainerView.do {
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = 34 / 2
            $0.backgroundColor = UIColor.gray800
            $0.isUserInteractionEnabled = true
        }
        
        authorImageView.do {
            $0.contentMode = .scaleAspectFill
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = 34 / 2
        }
        
        authorNameLabel.do {
            $0.text = String.unknown
        }
        
        authorFirstNameLabel.do {
            $0.text = "알"
        }
        
        postImageView.do {
            $0.clipsToBounds = true
            $0.backgroundColor = UIColor.gray100
            $0.contentMode = .scaleAspectFill
            $0.layer.cornerRadius = 48
        }
        
        contentCollectionView.do {
            $0.backgroundColor = .clear
            $0.isScrollEnabled = false
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
            $0.collectionViewLayout = flowLayout
            $0.register(
                DisplayEditCollectionViewCell.self,
                forCellWithReuseIdentifier: DisplayEditCollectionViewCell.id
            )
            $0.delegate = self
        }
        
        flowLayout.do {
            $0.itemSize = CGSize(width: 28, height: 41)
            $0.minimumInteritemSpacing = 2
        }
    }

}

// MARK: - Extensions
extension CalendarPostCell {
    private func prepareContentDatasource() -> RxCollectionViewSectionedReloadDataSource<DisplayEditSectionModel> {
        return RxCollectionViewSectionedReloadDataSource<DisplayEditSectionModel> { datasources, collectionView, indexPath, sectionItem in
            switch sectionItem {
            case let .fetchDisplayItem(reactor):
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: DisplayEditCollectionViewCell.id,
                    for: indexPath
                ) as? DisplayEditCollectionViewCell else {
                    return UICollectionViewCell()
                }
                cell.reactor = reactor
                return cell
            }
        }
    }
}

extension CalendarPostCell: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        guard let count = reactor?.currentState.post.postContent.count else {
            return .zero
        }
        
        let totalCellWidth = 28 * count
        let totalSpacingWidth = 2 * (count - 1)

        let leftInset = (collectionView.frame.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
        let rightInset = leftInset

        return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
    }
}
