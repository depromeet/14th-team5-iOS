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

final class MainViewController: BaseViewController<HomeViewReactor>, UICollectionViewDelegateFlowLayout {
    private let familyViewController: MainFamilyViewController = MainFamilyDIContainer().makeViewController()
    private let segmentControl: BibbiSegmentedControl = BibbiSegmentedControl()
    private let timerView: TimerView = TimerView()
    private let pageViewController: SegmentPageViewController = SegmentPageViewController()

    private let balloonView: BalloonView = BalloonView()
    private let loadingView: BibbiLoadingView = BibbiLoadingView()
    private let cameraButton: UIButton = UIButton()
    
    // MARK: - Properties
    private let memberRepo = App.Repository.member
    private let deepLinkRepo = App.Repository.deepLink
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideCameraButton(true)
        UserDefaults.standard.inviteCode = nil
    }
    
    override func bind(reactor: HomeViewReactor) {
        super.bind(reactor: reactor)
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    override func setupUI() {
        super.setupUI()
        
        addChild(familyViewController)
        addChild(pageViewController)
        
        view.addSubviews(familyViewController.view, timerView, segmentControl,
                         pageViewController.view, balloonView, cameraButton)
        
        familyViewController.didMove(toParent: self)
        pageViewController.didMove(toParent: self)
    }
    
    override func setupAutoLayout() {
        super.setupAutoLayout()
        
        familyViewController.view.snp.makeConstraints {
            $0.top.equalTo(navigationBarView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(138)
        }
        
        timerView.snp.makeConstraints {
            $0.top.equalTo(familyViewController.view.snp.bottom)
            $0.height.equalTo(100)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        segmentControl.snp.makeConstraints {
            $0.top.equalTo(timerView.snp.bottom)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(138)
            $0.height.equalTo(40)
        }
        
        pageViewController.view.snp.makeConstraints {
            $0.top.equalTo(segmentControl.snp.bottom)
            $0.horizontalEdges.bottom.equalToSuperview()
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
            $0.setNavigationView(leftItem: .family, centerItem: .logo, rightItem: .calendar)
        }
        
        balloonView.do {
            $0.text = "하루에 한번 사진을 올릴 수 있어요"
        }
        
        cameraButton.do {
            $0.setImage(DesignSystemAsset.shutter.image, for: .normal)
        }
    }
}

extension MainViewController {
    private func bindInput(reactor: HomeViewReactor) {
        Observable.merge(
            Observable.just(())
                .map { Reactor.Action.viewDidLoad },
            NotificationCenter.default.rx.notification(UIScene.willEnterForegroundNotification)
                .map { _ in Reactor.Action.viewDidLoad }
        )
        .bind(to: reactor.action)
        .disposed(by: disposeBag)
        
        Observable.just(())
            .map { Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        self.rx.viewWillAppear
            .withUnretained(self)
            // 별도 딥링크를 받지 않으면
            .filter {
                let repo = $0.0.deepLinkRepo
                return repo.notification.value == nil && repo.widget.value == nil
            }
            // viewWillAppear 메서드 수행하기
            .map { _ in Reactor.Action.viewWillAppear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        // 노티피케이션 딥링크를 받게 된다면 딥링크 처리 과정에서 viewWillAppear를 대신 불러옴
        
        navigationBarView.rx.leftButtonTap
            .withUnretained(self)
            .subscribe {
                $0.0.navigationController?.pushViewController(
                    FamilyManagementDIContainer().makeViewController(),
                    animated: true
                )
            }
            .disposed(by: disposeBag)
        
        navigationBarView.rx.rightButtonTap
            .withUnretained(self)
            .subscribe {
                $0.0.navigationController?.pushViewController(
                    CalendarDIConatainer().makeViewController(),
                    animated: true
                )
            }
            .disposed(by: disposeBag)
        
        cameraButton.rx.tap
            .throttle(RxConst.throttleInterval, scheduler: MainScheduler.instance)
            .map { Reactor.Action.tapCameraButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 위젯 딥링크 코드
        App.Repository.deepLink.widget
            .compactMap { $0 }
            .map { Reactor.Action.pushWidgetPostDeepLink($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 푸시 노티피케이션 딥링크 코드
        App.Repository.deepLink.notification
            .compactMap { $0 }
            .flatMap {
                // 댓글 푸시 알림이라면
                if $0.openComment {
                    return Observable.just(Reactor.Action.pushNotificationCommentDeepLink($0))
                // 포스트 푸시 알림이라면
                } else {
                    return Observable.just(Reactor.Action.pushNotificationPostDeepLink($0))
                }
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: HomeViewReactor) {
        reactor.pulse(\.$isSelfUploaded)
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind(onNext: { $0.0.hideCameraButton($0.1) })
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$isShowingCameraView)
            .observe(on: MainScheduler.instance)
            .filter { $0 }
            .withUnretained(self)
            .bind(onNext: {
                MPEvent.Home.cameraTapped.track(with: nil)
                let cameraViewController = CameraDIContainer(cameraType: .feed).makeViewController()
                $0.0.navigationController?.pushViewController(cameraViewController, animated: true)
            })
            .disposed(by: disposeBag)
//        
//        // 위젯 딥링크 코드
//        reactor.pulse(\.$widgetPostDeepLink)
//            .delay(RxConst.smallDelayInterval, scheduler: Schedulers.main)
//            .compactMap { $0 }
//            .bind(with: self) { owner, deepLink in
//                owner.handlePostWidgetDeepLink(deepLink)
//            }
//            .disposed(by: disposeBag)
//        
//        // 포스트 노티피케이션 딥링크 코드
//        reactor.pulse(\.$notificationPostDeepLink)
//            .delay(RxConst.smallDelayInterval, scheduler: Schedulers.main)
//            .compactMap { $0 }
//            .bind(with: self) { owner, deepLink in
//                owner.handlePostNotificationDeepLink(deepLink)
//            }
//            .disposed(by: disposeBag)
//        
//        // 댓글 노티피케이션 딥링크 코드
//        reactor.pulse(\.$notificationCommentDeepLink)
//            .delay(RxConst.smallDelayInterval, scheduler: Schedulers.main)
//            .compactMap { $0 }
//            .bind(with: self) { owner, deepLink in
//                owner.handleCommentNotificationDeepLink(deepLink)
//            }
//            .disposed(by: disposeBag)
        
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
    }
}

extension MainViewController {
    private func hideCameraButton(_ isHidden: Bool) {
        balloonView.isHidden = isHidden
        cameraButton.isHidden = isHidden
    }
}

//extension MainViewController {
//    private func handlePostWidgetDeepLink(_ deepLink: WidgetDeepLink) {
//        guard let reactor = reactor else { return }
//        reactor.currentState.postSection.items.enumerated().forEach { (index, item) in
//            switch item {
//            case .main(let postListData):
//                if postListData.postId == deepLink.postId {
//                    let indexPath = IndexPath(row: index, section: 0)
//                    self.navigationController?.pushViewController(
//                        PostListsDIContainer().makeViewController(
//                            postLists: reactor.currentState.postSection,
//                            selectedIndex: indexPath),
//                        animated: true
//                    )
//                }
//            }
//        }
//    }
//    
//    private func handlePostNotificationDeepLink(_ deepLink: NotificationDeepLink) {
//        guard let reactor = reactor else { return }
//        reactor.currentState.postSection.items.enumerated().forEach { (index, item) in
//            switch item {
//            case .main(let post):
//                if post.postId == deepLink.postId {
//                    let indexPath = IndexPath(row: index, section: 0)
//                    self.navigationController?.pushViewController(
//                        PostListsDIContainer().makeViewController(
//                            postLists: reactor.currentState.postSection,
//                            selectedIndex: indexPath),
//                        animated: true
//                    )
//                }
//            }
//        }
//    }
//    
//    private func handleCommentNotificationDeepLink(_ deepLink: NotificationDeepLink) {
//        guard let reactor = reactor else { return }
//        
//        // 오늘 올린 피드에 댓글이 달렸다면
//        if deepLink.dateOfPost.isToday {
//            guard let selectedIndex = reactor.currentState.postSection.items.firstIndex(where: { postList in
//                switch postList {
//                case let .main(post):
//                    post.postId == deepLink.postId
//                }
//            }) else { return }
//            let indexPath = IndexPath(row: selectedIndex, section: 0)
//            
//            let postListViewController = PostListsDIContainer().makeViewController(
//                postLists: reactor.currentState.postSection,
//                selectedIndex: indexPath,
//                notificationDeepLink: deepLink
//            )
//            
//            navigationController?.pushViewController(
//                postListViewController,
//                animated: true
//            )
//        // 이전에 올린 피드에 댓글이 달렸다면
//        } else {
//            let calendarPostViewController = CalendarPostDIConatainer(
//                selectedDate: deepLink.dateOfPost,
//                notificationDeepLink: deepLink
//            ).makeViewController()
//            
//            navigationController?.pushViewController(
//                calendarPostViewController,
//                animated: true
//            )
//        }
//    }
//}
