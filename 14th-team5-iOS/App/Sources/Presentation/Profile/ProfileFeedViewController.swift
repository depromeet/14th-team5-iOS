//
//  ProfileFeedViewController.swift
//  App
//
//  Created by Kim dohyun on 5/4/24.
//

import UIKit

import Core
import ReactorKit
import RxDataSources
import RxCocoa

final class ProfileFeedViewController: BaseViewController<ProfileFeedViewReactor> {
    
    private let profileFeedCollectionViewLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    private lazy var profileFeedCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: profileFeedCollectionViewLayout)
    
    private let profileFeedDataSources: RxCollectionViewSectionedReloadDataSource<ProfileFeedSectionModel> = .init { dataSources, collectionView, indexPath, sectionItem in
        switch sectionItem {
        case let .feedCategoryItem(cellReactor):
            guard let profileFeedCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileFeedCollectionViewCell", for: indexPath) as? ProfileFeedCollectionViewCell else { return UICollectionViewCell() }
            profileFeedCell.reactor = cellReactor
            return profileFeedCell
            
        case let .feedCateogryEmptyItem(cellReactor):
            guard let profileFeedEmptyCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileFeedEmptyCollectionViewCell", for: indexPath) as? ProfileFeedEmptyCollectionViewCell else { return UICollectionViewCell() }
            profileFeedEmptyCell.reactor = cellReactor
            return profileFeedEmptyCell
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupUI() {
        super.setupUI()
        view.addSubview(profileFeedCollectionView)
    }
    
    override func setupAttributes() {
        super.setupAttributes()
        profileFeedCollectionViewLayout.do {
            $0.scrollDirection = .vertical
        }
        
        profileFeedCollectionView.do {
            $0.register(ProfileFeedCollectionViewCell.self, forCellWithReuseIdentifier: "ProfileFeedCollectionViewCell")
            $0.register(ProfileFeedEmptyCollectionViewCell.self, forCellWithReuseIdentifier: "ProfileFeedEmptyCollectionViewCell")
            $0.showsVerticalScrollIndicator = true
            $0.showsHorizontalScrollIndicator = false
            $0.backgroundColor = .clear
        }
    }
    
    override func setupAutoLayout() {
        super.setupAutoLayout()
        
        profileFeedCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }
    
    
    override func bind(reactor: ProfileFeedViewReactor) {
        
        Observable.just(())
            .map { Reactor.Action.reloadFeedItems }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        
        profileFeedCollectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$feedSection)
            .asDriver(onErrorJustReturn: [])
            .drive(profileFeedCollectionView.rx.items(dataSource: profileFeedDataSources))
            .disposed(by: disposeBag)
        
        profileFeedCollectionView.rx
            .prefetchItems
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .compactMap(\.last?.item)
            .withLatestFrom(reactor.state.compactMap { $0.feedItems})
            .filter { !$0.isLast }
            .map { _ in Reactor.Action.fetchMoreFeedItems}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        profileFeedCollectionView.rx
            .itemSelected
            .withLatestFrom(reactor.pulse(\.$feedPaginationItems)) { indexPath, feedItems in
                return (indexPath, feedItems)
            }
            .debounce(.milliseconds(100), scheduler: MainScheduler.instance)
            .map { Reactor.Action.didTapProfileFeedItem($0.0, $0.1)}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        Observable
            .combineLatest(
                reactor.pulse(\.$feedDetailItem),
                reactor.pulse(\.$selectedIndex)
            )
            .withUnretained(self)
            .filter { !$0.1.0.items.isEmpty }
            .debounce(.milliseconds(300), scheduler: MainScheduler.asyncInstance)
            .bind {
                guard let indexPath = $0.1.1 else { return }
                let vc = PostDetailViewControllerWrapper(
                    selectedIndex: indexPath.row,
                    originPostLists: $0.1.0
                ).makeViewController()
                $0.0.navigationController?.pushViewController(vc, animated: true)
            }.disposed(by: disposeBag)
        
        reactor.state
            .compactMap { $0.feedItems?.postLists.isEmpty }
            .map { !$0 }
            .bind(to: profileFeedCollectionView.rx.isScrollEnabled)
            .disposed(by: disposeBag)
        
        
    }
}

extension ProfileFeedViewController: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch profileFeedDataSources[indexPath] {
        case .feedCategoryItem:
            return CGSize(width: (collectionView.frame.size.width / 2) - 4, height: 243)
        case .feedCateogryEmptyItem:
            return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
        }
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
}

