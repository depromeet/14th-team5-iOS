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
import Util

import RxDataSources
import RxCocoa
import RxSwift

final class MainViewController: BBNavigationViewController<MainViewReactor>, UICollectionViewDelegateFlowLayout {
    private let familyViewController: MainFamilyViewController = MainFamilyViewControllerWrapper().makeViewController()
    
    private let timerView: TimerView = TimerView(reactor: TimerReactor())
    private let descriptionLabel: BBLabel = BBLabel(.body2Regular, textAlignment: .center, textColor: .gray300)
    private let imageView: UIImageView = UIImageView()
    
    private let contributorView: ContributorView = ContributorView(reactor: ContributorReactor())
    private let segmentControl: BibbiSegmentedControl = BibbiSegmentedControl()
    private let pageViewController: SegmentPageViewController = SegmentPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    
    private let cameraButton: MainCameraButtonView = MainCameraButtonView(reactor: MainCameraReactor())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BBLogManager.analytics(logType: BBEventAnalyticsLog.viewPage(pageName: .main))
    }
    
    override func bind(reactor: MainViewReactor) {
        super.bind(reactor: reactor)
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    override func setupUI() {
        super.setupUI()
        
        addChild(familyViewController)
        addChild(pageViewController)
        
        contentView.addSubviews(familyViewController.view, timerView, descriptionLabel,
                                imageView, segmentControl, pageViewController.view,
                                cameraButton, contributorView)
        
        familyViewController.didMove(toParent: self)
        pageViewController.didMove(toParent: self)
    }
    
    override func setupAutoLayout() {
        super.setupAutoLayout()
        
        familyViewController.view.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(138)
        }
        
        timerView.snp.makeConstraints {
            $0.top.equalTo(familyViewController.view.snp.bottom)
            $0.height.equalTo(48)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(timerView.snp.bottom).offset(8)
            $0.height.equalTo(20)
            $0.centerX.equalToSuperview()
        }
        
        imageView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel)
            $0.size.equalTo(20)
            $0.leading.equalTo(descriptionLabel.snp.trailing).offset(2)
        }
        
        contributorView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        segmentControl.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(138)
            $0.height.equalTo(40)
        }
        
        pageViewController.view.snp.makeConstraints {
            $0.top.equalTo(segmentControl.snp.bottom).offset(40)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
        
        cameraButton.snp.makeConstraints {
            $0.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(140)
        }
    }
    
    override func setupAttributes() {
        super.setupAttributes()
        
        navigationBar.do {
            $0.leftBarButtonItem = .person(new: false)
            $0.rightBarButtonItem = .calendar
        }
        
        contributorView.do {
            $0.isHidden = true
        }
    }
}

extension MainViewController {
    private func bindInput(reactor: MainViewReactor) {
        Observable.merge(
            rx.viewWillAppear
                .map { _ in Reactor.Action.calculateTime },
            NotificationCenter.default.rx.notification(UIScene.willEnterForegroundNotification)
                .map { _ in Reactor.Action.calculateTime }
        )
        .bind(to: reactor.action)
        .disposed(by: disposeBag)
        
        Observable.just(())
            .map { Reactor.Action.checkIsFirstFamilyManagement }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        Observable.just(())
            .map { Reactor.Action.checkIsFirstWidgetAlert }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        Observable.merge(
            segmentControl.survivalButton.rx.tap.map { Reactor.Action.didTapSegmentControl(.survival) },
            segmentControl.missionButton.rx.tap.map { Reactor.Action.didTapSegmentControl(.mission) },
            pageViewController.indexRelay.filter { $0.way == .scroll }.map { $0.index }.map { Reactor.Action.didTapSegmentControl($0 == 0 ? .survival : .mission)}
        )
        .observe(on: MainScheduler.instance)
        .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
        .bind(to: reactor.action)
        .disposed(by: disposeBag)
        
        Observable.merge(
            contributorView.nextButtonTapEvent.map { Reactor.Action.openNextViewController(.contributorNextButtonTap)},
            cameraButton.camerTapEvent.map { Reactor.Action.openNextViewController(.cameraButtonTap )},
            navigationBar.rx.didTapRightBarButton.map { _ in Reactor.Action.openNextViewController(.navigationRightButtonTap)},
            navigationBar.rx.didTapLeftBarButton.map { _ in Reactor.Action.openNextViewController(.navigationLeftButtonTap)}
        )
        .observe(on: MainScheduler.instance)
        .throttle(RxInterval._300milliseconds, scheduler: MainScheduler.instance)
        .bind(to: reactor.action)
        .disposed(by: disposeBag)
        
        
        contributorView.infoButton.rx.tap
            .throttle(RxConst.milliseconds300Interval, scheduler: MainScheduler.instance)
            .withUnretained(self)
            .bind(onNext: {
                $0.0.makeDescriptionPopoverView(
                    $0.0,
                    sourceView: $0.0.contributorView.infoButton,
                    text: "생존신고 횟수가 동일한 경우\n이모지, 댓글 수를 합산해서 등수를 정해요",
                    popoverSize: CGSize(width: 260, height: 62),
                    permittedArrowDrections: [.up]
                )
            })
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: MainViewReactor) {
        
        reactor.state.map { $0.isInTime }.compactMap { $0 }
            .distinctUntilChanged()
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .bind(onNext: { $0.0.setInTimeView($0.1) })
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$familySection)
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(to: familyViewController.familySectionRelay)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.pageIndex }
            .distinctUntilChanged()
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .bind(onNext: {
                $0.0.pageViewController.indexRelay.accept(.init(way: .segmentTap, index: $0.1))
                $0.0.segmentControl.isSelected = ($0.1 == 0)
            })
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$cameraEnabled)
            .distinctUntilChanged()
            .bind(to: cameraButton.cameraEnabledRelay)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.balloonText }
            .distinctUntilChanged { $0.message }
            .bind(to: cameraButton.textRelay)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.description }
            .distinctUntilChanged { $0.text }
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .bind(onNext: { $0.0.setDescription($0.1) })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isMissionUnlocked }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(to: segmentControl.isUpdatedRelay)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$contributor)
            .bind(to: contributorView.contributorRelay)
            .disposed(by: disposeBag)
        
        Observable.combineLatest(
            reactor.state.map { $0.familyname }.distinctUntilChanged(),
            reactor.state.map { $0.isFirstFamilyManagement }.distinctUntilChanged()
        )
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .bind(onNext: {
                $0.0.setNavigation(title: $0.1.0, isFirstFamilyManagement: $0.1.1)
            })
            .disposed(by: disposeBag)
    }
}

extension MainViewController {
    private func setInTimeView(_ isInTime: Bool) {
        if isInTime {
            contributorView.isHidden = true
            pageViewController.view.isHidden = false
            segmentControl.isHidden = false
        } else {
            contributorView.isHidden = false
            pageViewController.view.isHidden = true
            segmentControl.isHidden = true
        }
    }
    
    private func setDescription(_ description: Description) {
        if case let .missionNone(number) = description {
            let attributedString = NSMutableAttributedString(string: description.text)
            let range = (description.text as NSString).range(of: "\(number)명")
            attributedString.addAttribute(.foregroundColor, value: UIColor.mainYellow, range: range)
            descriptionLabel.attributedText = attributedString
        } else {
            descriptionLabel.text = description.text
        }
        imageView.image = description.image
    }
    
    private func setNavigation(title: String?, isFirstFamilyManagement: Bool) {
        navigationBar.leftBarButtonItem = .person(new: isFirstFamilyManagement)
        if let title {
            navigationBar.navigationTitleFontStyle = .homeTitle
            navigationBar.navigationTitle = title
        } else {
            navigationBar.navigationImage = .bibbi
        }
    }
}

extension MainViewController: UIPopoverPresentationControllerDelegate {
    public func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
