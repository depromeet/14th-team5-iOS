//
//  HomeViewController.swift
//  App
//
//  Created by 마경미 on 05.12.23.
//

import UIKit
import Core
import Domain
import DesignSystem

import RxDataSources
import RxCocoa
import RxSwift
import SnapKit
import Then
import Domain

final class HomeViewController: BaseViewController<HomeViewReactor>, UICollectionViewDelegateFlowLayout {
    private let navigationBarView: BibbiNavigationBarView = BibbiNavigationBarView()
    private let timerView: TimerView = TimerView()
    private let familyCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let postCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let noPostView: NoPostTodayView = NoPostTodayView()
    private let inviteFamilyView: InviteFamilyView = InviteFamilyView(openType: .inviteUrl)
    private let balloonView: BalloonView = BalloonView()
    private let loadingView: BibbiLoadingView = BibbiLoadingView()
    private let cameraButton: UIButton = UIButton()
    private let refreshControl: UIRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideCameraButton(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    override func bind(reactor: HomeViewReactor) {
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    override func setupUI() {
        super.setupUI()
        
        view.addSubviews(navigationBarView, familyCollectionView, timerView,
                         noPostView, postCollectionView, inviteFamilyView,
                         balloonView, cameraButton)
    }
    
    override func setupAutoLayout() {
        super.setupAutoLayout()
        
        navigationBarView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(40)
        }
        
        familyCollectionView.snp.makeConstraints {
            $0.height.equalTo(138)
            $0.top.equalTo(navigationBarView.snp.bottom)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        
        inviteFamilyView.snp.makeConstraints {
            $0.top.equalTo(familyCollectionView).inset(24)
            $0.horizontalEdges.equalTo(familyCollectionView).inset(20)
            $0.height.equalTo(90)
        }
        
        timerView.snp.makeConstraints {
            $0.top.equalTo(familyCollectionView.snp.bottom)
            $0.height.equalTo(100)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        postCollectionView.snp.makeConstraints {
            $0.top.equalTo(timerView.snp.bottom)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        noPostView.snp.makeConstraints {
            $0.top.equalTo(postCollectionView).inset(100)
            $0.horizontalEdges.bottom.equalTo(postCollectionView)
        }
        
        balloonView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(cameraButton.snp.top).offset(-8)
            $0.height.equalTo(52)
        }
        
        cameraButton.snp.makeConstraints {
            $0.size.equalTo(HomeAutoLayout.CamerButton.size)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func setupAttributes() {
        super.setupAttributes()
        
        navigationBarView.do {
            $0.navigationImage = .newBibbi
            $0.navigationImageScale = 0.8
            
            $0.leftBarButtonItem = .addPerson
            $0.leftBarButtonItemScale = 1.2
            $0.leftBarButtonItemYOffset = 10.0
            
            $0.rightBarButtonItem = .heartCalendar
            $0.rightBarButtonItemScale = 1.2
            $0.rightBarButtonItemYOffset = -10.0
        }
        
        familyCollectionView.do {
            $0.collectionViewLayout = createFamilyLayout()
            $0.showsHorizontalScrollIndicator = false
            $0.backgroundColor = .clear
            $0.register(FamilyCollectionViewCell.self, forCellWithReuseIdentifier: FamilyCollectionViewCell.id)
        }
        
        postCollectionView.do {
            $0.collectionViewLayout = createPostLayout()
            $0.showsVerticalScrollIndicator = false
            $0.backgroundColor = .clear
            $0.refreshControl = refreshControl
            $0.register(FeedCollectionViewCell.self, forCellWithReuseIdentifier: FeedCollectionViewCell.id)
        }
        
        balloonView.do {
            $0.text = "하루에 한번 사진을 올릴 수 있어요"
        }
        
        cameraButton.do {
            $0.setImage(DesignSystemAsset.shutter.image, for: .normal)
        }
    }
}

extension HomeViewController {
    private func bindInput(reactor: HomeViewReactor) {
        postCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        App.Repository.member.postId
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind(onNext: {
                var postIds: [String] = []
                reactor.currentState.postSection.items.forEach { item in
                    switch item {
                    case .main(let postListData):
                        postIds.append(postListData.postId)
                    }
                }
                
                if let index = $0.0.findIndex(postIds, $0.1) {
                    let indexPath = IndexPath(row: index, section: 0)
                    $0.0.navigationController?.pushViewController(PostListsDIContainer().makeViewController(postLists: reactor.currentState.postSection, selectedIndex: indexPath), animated: false)
                }
            })
            .disposed(by: disposeBag)
        
        Observable.just(())
            .map { Reactor.Action.checkInTime }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        Observable.just(())
            .map { Reactor.Action.startTimer }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        self.inviteFamilyView.rx.tap
            .throttle(RxConst.throttleInterval, scheduler: Schedulers.main)
            .map { Reactor.Action.tapInviteFamily }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        self.rx.viewWillAppear
            .map { _ in Reactor.Action.viewWillAppear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        refreshControl.rx.controlEvent(.valueChanged)
            .map { Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        navigationBarView.rx.didTapLeftBarButton
            .throttle(RxConst.throttleInterval, scheduler: Schedulers.main)
            .withUnretained(self)
            .subscribe {
                $0.0.navigationController?.pushViewController(
                    FamilyManagementDIContainer().makeViewController(),
                    animated: true
                )
            }
            .disposed(by: disposeBag)
        
        navigationBarView.rx.didTapRightBarButton
            .throttle(RxConst.throttleInterval, scheduler: Schedulers.main)
            .withUnretained(self)
            .subscribe {
                $0.0.navigationController?.pushViewController(
                    CalendarDIConatainer().makeViewController(),
                    animated: true
                )
            }
            .disposed(by: disposeBag)
        
        familyCollectionView.rx.modelSelected(FamilySection.Item.self)
            .throttle(RxConst.throttleInterval, scheduler: MainScheduler.instance)
            .compactMap { item -> ProfileData? in
                switch item {
                case .main(let profileData): return profileData
                }
            }
            .withUnretained(self)
            .bind { owner, profileData in
                let profileViewController = ProfileDIContainer(memberId: profileData.memberId).makeViewController()
                self.navigationController?.pushViewController(profileViewController, animated: true)
            }
            .disposed(by: disposeBag)
        
        postCollectionView.rx.itemSelected
            .throttle(RxConst.throttleInterval, scheduler: Schedulers.main)
            .withUnretained(self)
            .bind(onNext: {
                $0.0.navigationController?.pushViewController(
                    PostListsDIContainer().makeViewController(
                        postLists: reactor.currentState.postSection,
                        selectedIndex: $0.1
                    ), animated: true)
            })
            .disposed(by: disposeBag)
        
        cameraButton.rx.tap
            .throttle(RxConst.throttleInterval, scheduler: MainScheduler.instance)
            .withUnretained(self)
            .bind { owner, _ in
                MPEvent.Home.cameraTapped.track(with: nil)
                let cameraViewController = CameraDIContainer(cameraType: .feed).makeViewController()
                owner.navigationController?.pushViewController(cameraViewController, animated: true)
            }.disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: HomeViewReactor) {
        let postStream =  reactor.pulse(\.$postSection)
            .observe(on: MainScheduler.instance)
        
        postStream
            .map(Array.init(with:))
            .bind(to: postCollectionView.rx.items(dataSource: createPostDataSource()))
            .disposed(by: disposeBag)
        
        postStream
            .withUnretained(self)
            .bind(onNext: { _ in App.Repository.member.postId.accept(UserDefaults.standard.postId)  })
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$isRefreshEnd)
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind(onNext: { $0.0.refreshControl.endRefreshing() })
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$postSection)
            .withUnretained(self)
            .bind(onNext: { $0.0.timerView.reactor = TimerDIContainer().makeReactor(isSelfUploaded: reactor.currentState.isSelfUploaded, isAllUploaded: reactor.currentState.isAllFamilyMembersUploaded)
            })
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$familySection)
            .observe(on: MainScheduler.instance)
            .map(Array.init(with:))
            .bind(to: familyCollectionView.rx.items(dataSource: createFamilyDataSource()))
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$isSelfUploaded)
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind(onNext: { $0.0.hideCameraButton($0.1) })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isShowingInviteFamilyView}
            .observe(on: MainScheduler.instance)
            .distinctUntilChanged()
            .map { !$0 }
            .bind(to: inviteFamilyView.rx.isHidden)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isShowingNoPostTodayView }
            .observe(on: MainScheduler.instance)
            .distinctUntilChanged()
            .map { !$0 }
            .bind(to: noPostView.rx.isHidden)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$familyInvitationLink)
            .observe(on: Schedulers.main)
            .withUnretained(self)
            .bind(onNext: {
                $0.0.makeInvitationUrlSharePanel(
                    $0.1,
                    provider: reactor.provider
                )
            })
            .disposed(by: disposeBag)
        
        
        reactor.pulse(\.$shouldPresentCopySuccessToastMessageView)
            .skip(1)
            .withUnretained(self)
            .subscribe {
                $0.0.makeBibbiToastView(
                    text: "링크가 복사되었어요",
                    image: DesignSystemAsset.link.image
                )
            }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$shouldPresentFetchFailureToastMessageView)
            .skip(1)
            .withUnretained(self)
            .subscribe {
                $0.0.makeBibbiToastView(
                    text: "잠시 후에 다시 시도해주세요",
                    image: DesignSystemAsset.warning.image
                )
            }
            .disposed(by: disposeBag)
    }
}

extension HomeViewController {
    private func setNoPostTodayView(_ isShow: Bool) {
        postCollectionView.isHidden = isShow
    }
    
    private func hideCameraButton(_ isHidden: Bool) {
        balloonView.isHidden = isHidden
        cameraButton.isHidden = isHidden
    }
}

extension HomeViewController {
    private func createFamilyLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = .init(width: 64, height: 90)
        layout.sectionInset = UIEdgeInsets(
            top: HomeAutoLayout.FamilyCollectionView.edgeInsetTop,
            left: HomeAutoLayout.FamilyCollectionView.edgeInsetLeft,
            bottom: HomeAutoLayout.FamilyCollectionView.edgeInsetBottom,
            right: HomeAutoLayout.FamilyCollectionView.edgeInsetRight)
        layout.minimumLineSpacing = HomeAutoLayout.FamilyCollectionView.minimumLineSpacing
        return layout
    }
    
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
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCollectionViewCell.id, for: indexPath) as? FeedCollectionViewCell else {
                        return UICollectionViewCell()
                    }
                    cell.setCell(data: data)
                    return cell
                }
            })
        
    }
    
    private func createFamilyDataSource() -> RxCollectionViewSectionedReloadDataSource<FamilySection.Model>  {
        return RxCollectionViewSectionedReloadDataSource<FamilySection.Model>(
            configureCell: { (_, collectionView, indexPath, item) in
                switch item {
                case .main(let data):
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FamilyCollectionViewCell.id, for: indexPath) as? FamilyCollectionViewCell else {
                        return UICollectionViewCell()
                    }
                    cell.setCell(data: data)
                    return cell
                }
            })
    }
    
    private func findIndex<T: Equatable>(_ array: [T], _ element: T) -> Int? {
        for (index, value) in array.enumerated() {
            if value == element {
                return index
            }
        }
        return nil
    }
}
