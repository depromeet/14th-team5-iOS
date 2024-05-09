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

final class MainViewController: BaseViewController<MainViewReactor>, UICollectionViewDelegateFlowLayout {
    private let familyViewController: MainFamilyViewController = MainFamilyViewDIContainer().makeViewController()

    private let timerView: TimerView = TimerView(reactor: TimerReactor())
    private let descriptionLabel: BibbiLabel = BibbiLabel(.body2Regular, textAlignment: .center, textColor: .gray300)
    private let imageView: UIImageView = UIImageView()
    
    private let contributorView: ContributorView = ContributorView(reactor: ContributorReactor())
    private let segmentControl: BibbiSegmentedControl = BibbiSegmentedControl(isUpdated: true)
    private let pageViewController: SegmentPageViewController = SegmentPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    
    private let cameraButton: MainCameraButtonView = MainCameraDIContainer().makeView()
    private let alertConfirmRelay = PublishRelay<(String, String)>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserDefaults.standard.inviteCode = nil
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
        
        view.addSubviews(familyViewController.view, timerView, descriptionLabel,
                         imageView, segmentControl, pageViewController.view,
                         cameraButton, contributorView)
        
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
            $0.top.equalTo(segmentControl.snp.bottom)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
        
        cameraButton.snp.makeConstraints {
            $0.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(140)
        }
    }
    
    override func setupAttributes() {
        super.setupAttributes()
        
        navigationBarView.do {
            $0.setNavigationView(leftItem: .family, centerItem: .logo, rightItem: .calendar)
        }
    }
}

extension MainViewController {
    private func bindInput(reactor: MainViewReactor) {
        Observable.merge(
            self.rx.viewWillAppear
                .map { _ in Reactor.Action.calculateTime },
            NotificationCenter.default.rx.notification(UIScene.willEnterForegroundNotification)
                .map { _ in Reactor.Action.calculateTime }
        )
        .bind(to: reactor.action)
        .disposed(by: disposeBag)

        segmentControl.survivalButton.rx.tap
            .throttle(.milliseconds(1000), scheduler: MainScheduler.instance)
            .map { Reactor.Action.didTapSegmentControl(.survival) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
      
        segmentControl.missionButton.rx.tap
            .throttle(.milliseconds(1000), scheduler: MainScheduler.instance)
            .map { Reactor.Action.didTapSegmentControl(.mission) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        navigationBarView.rx.leftButtonTap
            .throttle(RxConst.throttleInterval, scheduler: MainScheduler.instance)
            .withUnretained(self)
            .bind { $0.0.navigationController?.pushViewController( FamilyManagementDIContainer().makeViewController(), animated: true) }
            .disposed(by: disposeBag)
        
        navigationBarView.rx.rightButtonTap
            .throttle(RxConst.throttleInterval, scheduler: MainScheduler.instance)
            .withUnretained(self)
            .bind { $0.0.navigationController?.pushViewController(CalendarDIConatainer().makeViewController(), animated: true) }
            .disposed(by: disposeBag)
      
        alertConfirmRelay
            .map { Reactor.Action.pickConfirmButtonTapped($0.0, $0.1) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        cameraButton.camerTapObservable
            .throttle(RxConst.throttleInterval, scheduler: MainScheduler.instance)
            .withUnretained(self)
            .bind(onNext: {
                MPEvent.Home.cameraTapped.track(with: nil)
                let cameraViewController = CameraDIContainer(cameraType: .survival).makeViewController()
                $0.0.navigationController?.pushViewController(cameraViewController, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: MainViewReactor) {
        reactor.state.map { $0.isInTime }
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
                $0.0.pageViewController.indexRelay.accept($0.1)
                $0.0.segmentControl.isSelected = ($0.1 == 0)
            })
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$cameraEnabled)
            .distinctUntilChanged()
            .bind(to: cameraButton.cameraEnabledRelay)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.balloonText }
            .distinctUntilChanged()
            .bind(to: cameraButton.textRelay)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.description }
            .distinctUntilChanged { $0.text }
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .bind(onNext: {
                $0.0.descriptionLabel.text = $0.1.text
                $0.0.imageView.image = $0.1.image
            })
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$contributor)
            .bind(to: contributorView.contributorRelay)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$shouldPresentPickAlert)
            .compactMap { $0 }
            .bind(with: self) { owner, profile in
                BibbiAlertBuilder(owner)
                    .alertStyle(.pickMember(profile.0))
                    .setConfirmAction {
                        owner.alertConfirmRelay.accept((profile.0, profile.1))
                    }
                    .present()
            }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$shouldPresentPickSuccessToastMessage)
            .compactMap { $0 }
            .bind(with: self) { owner, name in
                owner.makeBibbiToastView(
                    text: "\(name)님에게 생존신고 알림을 보냈어요",
                    image: DesignSystemAsset.yellowPaperPlane.image
                )
            }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$shouldPresentCopySuccessToastMessage)
            .filter { $0 }
            .bind(with: self) { owner, _ in
                owner.makeBibbiToastView(
                    text: "링크가 복사되었어요",
                    image: DesignSystemAsset.link.image
                )
            }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$shouldPresentFailureToastMessage)
            .filter { $0 }
            .bind(with: self) { owner, _ in
                owner.makeErrorBibbiToastView()
            }
            .disposed(by: disposeBag)
    }
}

extension MainViewController {
    private func setInTimeView(_ isInTime: Bool) {
        if isInTime {
            contributorView.isHidden = true
            segmentControl.isHidden = false
        } else {
            contributorView.isHidden = false
            segmentControl.isHidden = true
        }
    }
}
