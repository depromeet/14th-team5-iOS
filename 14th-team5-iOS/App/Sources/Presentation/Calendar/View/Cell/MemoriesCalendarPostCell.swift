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

final class MemoriesCalendarPostCell: BaseCollectionViewCell<MemoriesCalendarPostCellReactor> {
    
    // MARK: - Typealias
    
    typealias RxDataSource = RxCollectionViewSectionedReloadDataSource<DisplayEditSectionModel>
    
    
    // MARK: - Id
    
    static let id = "CalendarPostCell"
    
    
    // MARK: - Views
    
    private lazy var headerView = makeMemoriesCalendarPostHeaderView()
    private lazy var postImageView = makeMemoriesCalendarPostImageView()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    
    // MARK: - Properties
    
    private lazy var datasource = prepareContentDatasource()
    

    // MARK: - LifeCycles
    
    override func prepareForReuse() {
        super.prepareForReuse()
        headerView.prepareForReuse()
        postImageView.prepareForReuse()
    }
    
    
    // MARK: - Helpers
    
    override func bind(reactor: MemoriesCalendarPostCellReactor) {
        super.bind(reactor: reactor)
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    private func bindInput(reactor: MemoriesCalendarPostCellReactor) {
        Observable.just(())
            .map { Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
            
        headerView.rx.didTapProfileImageButton
            .throttle(RxInterval._300milliseconds, scheduler: RxScheduler.main)
            .map { Reactor.Action.didTapProfileImageButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: MemoriesCalendarPostCellReactor) {
        let dailyPost = reactor.state.map { $0.dailyPost }
          .asDriver(onErrorDriveWith: .empty())
        
        dailyPost
            .distinctUntilChanged()
            .compactMap { $0.missionContent }
            .drive(with: self, onNext: { $0.postImageView.setMissionText(text: $1) })
            .disposed(by: disposeBag)
        
        dailyPost
            .distinctUntilChanged()
            .drive(with: self, onNext: { $0.postImageView.setPostImage(imageUrl: $1.postImageUrl) })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.memberName }
            .distinctUntilChanged()
            .bind(with: self) { $0.headerView.setMemberName(text: $1) }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.profileImageUrl }
            .distinctUntilChanged()
            .compactMap { $0 }
            .bind(with: self) { $0.headerView.setProfileImage(imageUrl: $1) }
            .disposed(by: disposeBag)
        
        reactor.state.compactMap { $0.contentDatasource }
            .bind(to: collectionView.rx.items(dataSource: datasource))
            .disposed(by: disposeBag)
    }
    
    override func setupUI() {
        super.setupUI()
        
        contentView.addSubviews(headerView, postImageView, collectionView)
    }
    
    override func setupAutoLayout() {
        super.setupAutoLayout()
        
        headerView.snp.makeConstraints {
            $0.top.equalTo(self.snp.top).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(34)
        }
        
        collectionView.snp.makeConstraints {
            $0.height.equalTo(41)
            $0.bottom.equalTo(postImageView.snp.bottom).offset(-20)
            $0.horizontalEdges.equalToSuperview()
        }
        
        postImageView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(postImageView.snp.width)
            $0.horizontalEdges.equalToSuperview().inset(1)
            $0.top.equalTo(headerView.snp.bottom).offset(8)
        }
    }
    
    override func setupAttributes() {
        super.setupAttributes()
        
        collectionView.do {
            $0.backgroundColor = .clear
            $0.isScrollEnabled = false
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
            $0.collectionViewLayout = UICollectionViewFlowLayout()
            $0.register(DisplayEditCollectionViewCell.self, forCellWithReuseIdentifier: DisplayEditCollectionViewCell.id)
            $0.delegate = self
        }
    }

}


// MARK: - Extensions

extension MemoriesCalendarPostCell {
    
    private func prepareContentDatasource() -> RxDataSource {
        return RxDataSource { datasources, collectionView, indexPath, sectionItem in
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

extension MemoriesCalendarPostCell {
    
    func makeMemoriesCalendarPostHeaderView() -> MemoriesCalendarPostHeaderView {
        return MemoriesCalendarPostHeaderView(reactor: MemoriesCalendarPostHeaderReactor())
    }
    
    func makeMemoriesCalendarPostImageView() -> MemoriesCalendarPostImageView {
        return MemoriesCalendarPostImageView(reactor: MemoriesCalendarPostImageReactor())
    }
    
}

extension MemoriesCalendarPostCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 28, height: 41)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        guard let count = reactor?.currentState.dailyPost.postContent?.count else {
            return .zero
        }
        
        let totalCellWidth = 28 * count
        let totalSpacingWidth = 2 * (count - 1)

        let leftInset = (collectionView.frame.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
        let rightInset = leftInset

        return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
    }
    
}
