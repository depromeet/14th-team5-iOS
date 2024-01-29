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

final class PostViewController: BaseViewController<PostReactor> {
    private let backgroundImageView: UIImageView = UIImageView()
    private let blurEffectView: UIVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffect.Style.dark))
    private var navigationView: PostNavigationView = PostNavigationView()
    private let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let collectionViewLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    private let reactionViewController: ReactionViewController = ReactionDIContainer().makeViewController(postId: "01HN9SNH3NT12SCKACBYCW16EC")
    
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
            .map(Array.init(with:))
            .bind(to: collectionView.rx.items(dataSource: createDataSource()))
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.selectedPost }
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .bind(onNext: {
                $0.0.setBackgroundView(data: $0.1)
                $0.0.reactionViewController.postId.accept($0.1.postId)
                UIView.animate(withDuration: 0.3) {
                    self.reactionViewController.view.alpha = 1.0
                }
            })
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$reactionMemberIds)
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { $0.0.showReactionSheet($0.1) })
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
        
        reactor.pulse(\.$shouldPresentPostCommentSheet)
            .withUnretained(self)
            .subscribe {
                let postCommentVC = PostCommentDIContainer(
                    postId: $0.1.0,
                    commentCount: $0.1.1
                ).makeViewController()
                $0.0.present(postCommentVC, animated: true)
            }
            .disposed(by: disposeBag)
        
        collectionView.rx.willBeginDragging
            .observe(on: MainScheduler.instance)
            .bind(onNext: { [weak self] _ in
                guard let self = self else { return }
                UIView.animate(withDuration: 0.3) {
                    self.reactionViewController.view.alpha = 0
                }
            })
            .disposed(by: disposeBag)
        
        collectionView.rx.contentOffset
            .debounce(RxConst.throttleInterval, scheduler: MainScheduler.instance)
            .map { [unowned self] in 
                UIView.animate(withDuration: 0.3) {
                    self.reactionViewController.view.alpha = 1
                }
                return self.calculateCurrentPage(offset: $0) }
            .distinctUntilChanged()
            .map { Reactor.Action.setPost($0)}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    override func setupUI() {
        super.setupUI()
        
        addChild(reactionViewController)
                
        view.addSubviews(backgroundImageView, blurEffectView, navigationView,
                         collectionView, reactionViewController.view)
        
        reactionViewController.didMove(toParent: self)
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
            $0.height.equalToSuperview().multipliedBy(0.60)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        reactionViewController.view.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom)
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
            $0.register(PostDetailCollectionViewCell.self, forCellWithReuseIdentifier: PostDetailCollectionViewCell.id)
            $0.collectionViewLayout = collectionViewLayout
            $0.contentInsetAdjustmentBehavior = .never
            $0.scrollIndicatorInsets = PostAutoLayout.CollectionView.scrollIndicatorInsets
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
        }
        
        collectionView.layoutIfNeeded()
        collectionView.scrollToItem(at: IndexPath(row: reactor?.currentState.selectedIndex ?? 1, section: 0), at: .centeredHorizontally, animated: false)
    }
}

extension PostViewController {
    private func setBackgroundView(data: PostListData) {
        guard let url = URL(string: data.imageURL) else {
            return
        }
        self.backgroundImageView.kf.setImage(with: url)
    }
    
    private func showReactionSheet(_ memberIds: [String]) {
        if memberIds.isEmpty { return }
        
        let reactionMembersViewController = ReactionMemberDIContainer().makeViewController(memberIds: memberIds)
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
    
    private func createDataSource() -> RxCollectionViewSectionedReloadDataSource<PostSection.Model> {
        return RxCollectionViewSectionedReloadDataSource<PostSection.Model>(
            configureCell: { (_, collectionView, indexPath, item) in
                switch item {
                case .main(let data):
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostDetailCollectionViewCell.id, for: indexPath) as? PostDetailCollectionViewCell else {
                        return UICollectionViewCell()
                    }
                    cell.reactor = ReactionMemberDIContainer().makeReactor(post: data)
                    cell.setCell(data: data)
                    return cell
                }
            })
    }
}

extension PostViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}
