//
//  PostViewController.swift
//  App
//
//  Created by 마경미 on 09.12.23.
//

import UIKit
import Core
import Domain

import RxDataSources
import RxSwift

// index 조회 필요 => index 조회 이후 스크롤시 이전/이후 포스트 조회 할 수 있어야함
final class PostViewController: BaseViewController<PostReactor> {
    private let backgroundImageView: UIImageView = UIImageView()
    private let blurEffectView: UIVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffect.Style.dark))
    private var navigationView: PostNavigationView = PostNavigationView()
    private let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let collectionViewLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    
    convenience init(reactor: Reactor? = nil) {
        self.init()
        self.reactor = reactor
        self.navigationView = PostNavigationView(reactor: reactor)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func bind(reactor: PostReactor) {
        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.originPostLists }
            .asObservable()
            .bind(to: collectionView.rx.items(dataSource: createDataSource()))
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.selectedPost }
            .asObservable()
            .withUnretained(self)
            .bind(onNext: {
                $0.0.setBackgroundView(data: $0.1)
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.reactionMemberIds }
            .asObservable()
            .distinctUntilChanged()
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .bind(onNext: {
                $0.0.showReactionSheet($0.1)
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isPop }
            .asObservable()
            .distinctUntilChanged()
            .withUnretained(self)
            .bind(onNext: { _ in
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        collectionView.rx
            .contentOffset
            .map { [unowned self] in self.calculateCurrentPage(offset: $0) }
            .distinctUntilChanged()
            .map { Reactor.Action.setPost($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    override func setupUI() {
        super.setupUI()
        
        view.addSubviews(backgroundImageView, blurEffectView, navigationView,
                         collectionView)
    }
    
    override func setupAutoLayout() {
        super.setupAutoLayout()
        
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        blurEffectView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        navigationView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(PostAutoLayout.NavigationView.height)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom)
            $0.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func setupAttributes() {
        super.setupAttributes()
        
        blurEffectView.do {
            $0.frame = backgroundImageView.bounds
            $0.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
        
        collectionViewLayout.do {
            $0.sectionInset = PostAutoLayout.CollectionViewLayout.sectionInset
            $0.scrollDirection = .horizontal
            $0.minimumLineSpacing = PostAutoLayout.CollectionViewLayout.minimumLineSpacing
        }
        
        collectionView.do {
            $0.isPagingEnabled = true
            $0.backgroundColor = .clear
            $0.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: PostCollectionViewCell.id)
            $0.collectionViewLayout = collectionViewLayout
            $0.contentInsetAdjustmentBehavior = .never
            $0.scrollIndicatorInsets = PostAutoLayout.CollectionView.scrollIndicatorInsets
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
        }
    }
}

extension PostViewController {
    private func createDataSource() -> RxCollectionViewSectionedReloadDataSource<SectionModel<String, PostListData>> {
        return RxCollectionViewSectionedReloadDataSource<SectionModel<String, PostListData>>(
            configureCell: { dataSource, collectionView, indexPath, post in
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCollectionViewCell.id, for: indexPath) as? PostCollectionViewCell else {
                    return UICollectionViewCell()
                }
                cell.reactor = ReactionDIContainer().makeReactor(post: post)
                cell.setCell(data: post)
                return cell
            })
    }
    
    private func setBackgroundView(data: PostListData) {
        guard let url = URL(string: data.imageURL) else {
            return
        }
        self.backgroundImageView.kf.setImage(with: url)
    }
    
    private func showReactionSheet(_ memberIds: [String]) {
        if memberIds.isEmpty { return }
        let reactionMembersViewController = ReactionDIContainer().makeViewController(memberIds: memberIds)
        if let sheet = reactionMembersViewController.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }
        present(reactionMembersViewController, animated: true)
    }
    
    private func calculateCurrentPage(offset: CGPoint) -> Int {
        guard collectionView.frame.width > 0 else {
               return 0
           }
        
        let width = collectionView.frame.width
        let currentPage = Int((offset.x + width / 2) / width)
        return currentPage
    }
}

extension PostViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}
