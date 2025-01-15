//
//  PostViewController.swift
//  App
//
//  Created by 마경미 on 09.12.23.
//

import UIKit
import Core
import Domain
import Util

import RxDataSources
import RxSwift
import RxCocoa

final class PostViewController: BaseViewController<PostReactor> {
    private let backgroundImageView: UIImageView = UIImageView()
    private let blurEffectView: UIVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffect.Style.dark))
    private var navigationView: PostNavigationView = PostNavigationView()
    private let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let collectionViewLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    private let reactionViewController: ReactionViewController = ReactionViewControllerWrapper(type: .post, postListData: .empty).makeViewController()
    
    convenience init(reactor: Reactor? = nil) {
        self.init()
        self.reactor = reactor
        self.navigationView = PostNavigationView(reactor: reactor)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BBLogManager.analytics(logType: BBEventAnalyticsLog.viewPage(pageName: .postDetail))
        self.navigationController?.navigationBar.isHidden = true
    }

    override func bind(reactor: PostReactor) {
        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)

        NotificationCenter.default
            .rx.notification(.didTapSelectableCameraButton)
            .compactMap { notification -> Emojis? in
                guard let type =  notification.userInfo?["type"] as? Emojis else { return nil }
                return type
            }
            .withUnretained(self)
            .observe(on: MainScheduler.asyncInstance)
            .bind { owner, entity in
                let cameraViewController = CameraViewControllerWrapper(cameraType: .realEmoji, realEmojiType: entity).viewController
                owner.navigationController?.pushViewController(cameraViewController, animated: true)
            }.disposed(by: disposeBag)
        
        
        Observable.zip(
            collectionView.rx.didEndDisplayingCell.map { $0.at.item }.distinctUntilChanged(),
            reactor.state.map { $0.selectedIndex }.distinctUntilChanged()
        )
        .filter { $0.0 == $0.1 }
        .withUnretained(self)
        .subscribe { owner, indexPath in
            owner.collectionView.reloadItems(at: [.init(row: indexPath.1, section: 0)])
        }.disposed(by: disposeBag)
        
        reactor.state.map { $0.originPostLists }
            .map(Array.init(with:))
            .distinctUntilChanged()
            .bind(to: collectionView.rx.items(dataSource: createDataSource()))
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.selectedPost }
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .bind(onNext: {
                $0.0.setBackgroundView(data: $0.1)
                $0.0.reactionViewController.postListData.accept($0.1)
                UIView.animate(withDuration: 0.3) {
                    self.reactionViewController.view.alpha = 1.0
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isPop }
            .filter { $0 }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind(onNext: { $0.0.navigationController?.popViewController(animated: true) })
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$shouldPushProfileViewController)
            .compactMap { $0 }
            .bind(with: self) { owner, id in
                owner.pushProfileViewController(memberId: id)
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
            .debounce(RxConst.milliseconds300Interval, scheduler: MainScheduler.instance)
            .map { [unowned self] in 
                UIView.animate(withDuration: 0.3) {
                    self.reactionViewController.view.alpha = 1
                }
                return self.calculateCurrentPage(offset: $0) }
            .distinctUntilChanged()
            .map { Reactor.Action.setPost($0) }
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
//            $0.delegate = self
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
    private func setBackgroundView(data: PostEntity) {
        guard let url = URL(string: data.imageURL) else {
            return
        }
        self.backgroundImageView.kf.setImage(with: url)
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
                    cell.reactor = PostDetailCellWrapper(post: data).makeReactor()
                    cell.setCell(data: data)
                    return cell
                }
            })
    }
}

extension PostViewController {
    private func pushCameraViewController(cameraType type: UploadLocation) {
        let cameraViewController =  CameraViewControllerWrapper(
            cameraType: type
        ).viewController
        
        navigationController?.pushViewController(
            cameraViewController,
            animated: true
        )
    }
    
    private func pushProfileViewController(memberId: String) {
        let profileController = ProfileViewControllerWrapper(
            memberId: memberId
        ).viewController
        
        navigationController?.pushViewController(
            profileController,
            animated: true
        )
    }
}

extension PostViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}
