//
//  SurvivalViewController.swift
//  App
//
//  Created by 마경미 on 21.04.24.
//

import UIKit

import Core
import Domain

import RxSwift
import RxCocoa
import RxDataSources

final class MainPostViewController: BaseViewController<MainPostViewReactor>, UICollectionViewDelegate {
    private let postCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private let refreshControl: UIRefreshControl = UIRefreshControl()
    
    lazy var noPostView: NoPostTodayView = NoPostTodayView(type: reactor?.currentState.type ?? .survival, frame: .init())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBarView.isHidden = true
    }
    
    override func bind(reactor: MainPostViewReactor) {
        super.bind(reactor: reactor)
        
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    override func setupUI() {
        super.setupUI()
        
        view.addSubviews(postCollectionView, noPostView)
    }
    
    override func setupAutoLayout() {
        super.setupAutoLayout()
        
        postCollectionView.snp.makeConstraints {
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.verticalEdges.equalToSuperview()
        }
        
        noPostView.snp.makeConstraints {
            $0.width.equalTo(220)
            $0.height.equalTo(180)
            $0.top.centerX.equalTo(postCollectionView)
        }
    }
    
    override func setupAttributes() {
        super.setupAttributes()
        
        postCollectionView.do {
            $0.collectionViewLayout = createPostLayout()
            $0.showsVerticalScrollIndicator = false
            $0.backgroundColor = .clear
            $0.refreshControl = refreshControl
            $0.refreshControl?.tintColor = UIColor.bibbiWhite
            $0.register(MainPostCollectionViewCell.self, forCellWithReuseIdentifier: MainPostCollectionViewCell.id)
        }
        
        noPostView.do {
            $0.isUserInteractionEnabled = false
        }
    }
}

extension MainPostViewController {
    private func bindInput(reactor: MainPostViewReactor) {
        postCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        self.rx.viewWillAppear
            .map { _ in Reactor.Action.fetchPost }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        postCollectionView.rx.itemSelected
            .throttle(RxConst.milliseconds300Interval, scheduler: RxSchedulers.main)
            .withUnretained(self)
            .bind(onNext: {
                let vc = PostDetailViewControllerWrapper(
                    selectedIndex: $0.1.row,
                    originPostLists: reactor.currentState.postSection
                ).makeViewController()
                $0.0.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        refreshControl.rx.controlEvent(.valueChanged)
            .map { Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: MainPostViewReactor) {
        reactor.pulse(\.$postSection)
            .observe(on: MainScheduler.instance)
            .map(Array.init(with:))
            .bind(to: postCollectionView.rx.items(dataSource: createPostDataSource()))
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$isRefreshEnd)
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .bind(onNext: { $0.0.refreshControl.endRefreshing() })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isShowingNoPostTodayView }
            .observe(on: MainScheduler.instance)
            .distinctUntilChanged()
            .map { !$0 }
            .bind(to: noPostView.rx.isHidden)
            .disposed(by: disposeBag)
    }
}

extension MainPostViewController {
    private func createPostLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = .zero
        layout.itemSize = .init(width: UIScreen.main.bounds.width / 2 - 3, height: UIScreen.main.bounds.width / 2 - 3 + 36)
        layout.minimumLineSpacing = HomeAutoLayout.FeedCollectionView.minimumLineSpacing
        layout.minimumInteritemSpacing = HomeAutoLayout.FeedCollectionView.minimumInteritemSpacing
        return layout
    }
    
    private func createPostDataSource() -> RxCollectionViewSectionedReloadDataSource<PostSection.Model> {
        return RxCollectionViewSectionedReloadDataSource<PostSection.Model>(
            configureCell: { (_, collectionView, indexPath, item) in
                switch item {
                case .main(let data):
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainPostCollectionViewCell.id, for: indexPath) as? MainPostCollectionViewCell else {
                        return UICollectionViewCell()
                    }
                    cell.reactor = MainPostCellReactor(initialState: .init(postListData: data))
                    return cell
                }
            })
        
    }
}
