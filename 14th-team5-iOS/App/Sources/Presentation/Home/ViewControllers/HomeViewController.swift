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

public final class HomeViewController: BaseViewController<HomeViewReactor> {
    private let manageFamilyButton: UIBarButtonItem = UIBarButtonItem()
    private let calendarButton: UIBarButtonItem = UIBarButtonItem()
    private let familyCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let inviteFamilyView: UIView = InviteFamilyView()
    private let dividerView: UIView = UIView()
    private let timerLabel: UILabel = UILabel()
    private let descriptionLabel: UILabel = UILabel()
    private let noPostTodayView: UIView = NoPostTodayView()
    private let feedCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let camerButton: UIButton = UIButton()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    deinit {
        print("deinit HomeViewController")
    }
    
    public override func bind(reactor: HomeViewReactor) {
        familyCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        feedCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        Observable.just(())
            .map { Reactor.Action.getFamilyMembers }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        Observable.just(())
            .map { Reactor.Action.getTodayPostList }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        Observable.interval(.seconds(1), scheduler: MainScheduler.instance)
            .map { (time: Int) in
                let remainingTime = self.calculateRemainingTime(time: time)
                return self.setTimerFormat(remainingTime: remainingTime)
            }
            .bind(to: timerLabel.rx.text)
            .disposed(by: disposeBag)
        
        feedCollectionView.rx.itemSelected
            .withUnretained(self)
            .throttle(RxConst.throttleInterval, scheduler: Schedulers.main)
            .bind(onNext: {
                $0.0.navigationController?.pushViewController(PostViewController(reacter: PostReactor()), animated: true)
            })
            .disposed(by: disposeBag)
        
        camerButton
            .rx.tap
            .throttle(RxConst.throttleInterval, scheduler: MainScheduler.instance)
            .withUnretained(self)
            .bind { owner, _ in
                let cameraViewController = CameraDIContainer().makeViewController()
                owner.navigationController?.pushViewController(cameraViewController, animated: true)
            }.disposed(by: disposeBag)
        
        inviteFamilyView.rx.tap
            .throttle(RxConst.throttleInterval, scheduler: Schedulers.main)
            .map { Reactor.Action.tapInviteFamily }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.descriptionText }
            .observe(on: Schedulers.main)
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe(onNext: {
                $0.descriptionLabel.text = $1
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.familySections }
            .asObservable()
            .bind(to: familyCollectionView.rx.items(dataSource: createFamilyDataSource()))
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.feedSections }
            .asObservable()
            .bind(to: feedCollectionView.rx.items(dataSource: createFeedDataSource()))
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isShowingInviteFamilyView }
            .observe(on: Schedulers.main)
            .distinctUntilChanged()
            .withUnretained(self)
            .bind(onNext: {
                if $0.1 {
                    $0.0.addFamilyInviteView()
                } else {
                    $0.0.removeFamilyInviteView()
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isShowingNoPostTodayView }
            .observe(on: MainScheduler.instance)
            .distinctUntilChanged()
            .withUnretained(self)
            .bind(onNext: {
                if $0.1 {
                    $0.0.addNoPostTodayView()
                } else {
                    $0.0.removeNoPostTodayView()
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.inviteLink }
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind(onNext: {
                $0.0.makeInvitationUrlSharePanel($0.1, provider: reactor.provider)
            })
            .disposed(by: disposeBag)
    }
    
    public override func setupUI() {
        super.setupUI()
        
        view.addSubviews(familyCollectionView, dividerView, timerLabel, descriptionLabel,
                         feedCollectionView, camerButton)
    }
    
    public override func setupAutoLayout() {
        super.setupAutoLayout()
        
        familyCollectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(HomeAutoLayout.FamilyCollectionView.topInset)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(HomeAutoLayout.FamilyCollectionView.height)
        }
        
        dividerView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(HomeAutoLayout.DividerView.topInset)
            $0.height.equalTo(HomeAutoLayout.DividerView.height)
        }
        
        timerLabel.snp.makeConstraints {
            $0.top.equalTo(dividerView.snp.bottom).offset(HomeAutoLayout.TimerLabel.topOffset)
            $0.height.equalTo(HomeAutoLayout.TimerLabel.height)
            $0.horizontalEdges.equalToSuperview().inset(HomeAutoLayout.TimerLabel.horizontalInset)
            $0.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(timerLabel.snp.bottom).offset(HomeAutoLayout.DescriptionLabel.topOffset)
            $0.centerX.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(HomeAutoLayout.DescriptionLabel.horizontalInset)
            $0.height.equalTo(HomeAutoLayout.DescriptionLabel.height)
        }
        
        feedCollectionView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(HomeAutoLayout.FeedCollectionView.topOffset)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        camerButton.snp.makeConstraints {
            $0.size.equalTo(HomeAutoLayout.CamerButton.size)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    public override func setupAttributes() {
        super.setupAttributes()
        
        let familyCollectionViewLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let feedCollectionViewLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        navigationItem.do {
            $0.titleView = UIImageView(image: DesignSystemAsset.bibbi.image)
            $0.leftBarButtonItem = manageFamilyButton
            $0.rightBarButtonItem = calendarButton
        }
        
        manageFamilyButton.do {
            $0.image = DesignSystemAsset.addPerson.image
            $0.tintColor = DesignSystemAsset.gray400.color
            $0.target = self
        }
        
        calendarButton.do {
            $0.image = DesignSystemAsset.calendar.image
            $0.tintColor = DesignSystemAsset.gray400.color
            $0.target = self
        }
        
        familyCollectionViewLayout.do {
            $0.sectionInset = UIEdgeInsets(
                top: HomeAutoLayout.FamilyCollectionView.edgeInsetTop,
                left: HomeAutoLayout.FamilyCollectionView.edgeInsetLeft,
                bottom: HomeAutoLayout.FamilyCollectionView.edgeInsetBottom,
                right: HomeAutoLayout.FamilyCollectionView.edgeInsetRight)
            $0.minimumLineSpacing = HomeAutoLayout.FamilyCollectionView.minimumLineSpacing
        }
        
        familyCollectionView.do {
            $0.register(FamilyCollectionViewCell.self, forCellWithReuseIdentifier: FamilyCollectionViewCell.id)
            $0.backgroundColor = .clear
            $0.collectionViewLayout = familyCollectionViewLayout
        }
        
        
        dividerView.do {
            $0.backgroundColor = DesignSystemAsset.gray900.color
        }
        
        
        timerLabel.do {
            $0.font = UIFont(name: "Pretendard-Bold", size: 24)
            $0.textAlignment = .center
            $0.textColor = .white
        }
        
        descriptionLabel.do {
            $0.font = UIFont(name: "Pretendard-Regular", size: 14)
            $0.textColor = DesignSystemAsset.gray300.color
        }
        
        feedCollectionViewLayout.do {
            $0.sectionInset = .zero
            $0.minimumLineSpacing = HomeAutoLayout.FeedCollectionView.minimumLineSpacing
            $0.minimumInteritemSpacing = HomeAutoLayout.FeedCollectionView.minimumInteritemSpacing
        }
        
        feedCollectionView.do {
            $0.register(FeedCollectionViewCell.self, forCellWithReuseIdentifier: FeedCollectionViewCell.id)
            $0.backgroundColor = .clear
        }
        
        camerButton.do {
            $0.setImage(DesignSystemAsset.camerButton.image, for: .normal)
        }
    }
}

extension HomeViewController {
    private func setTimerFormat(remainingTime: Int) -> String {
        if remainingTime <= 0 {
            return HomeStrings.Timer.notTime
        }
        
        let hours = remainingTime / 3600
        let minutes = (remainingTime % 3600) / 60
        let seconds = remainingTime % 60
        
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    private func addFamilyInviteView() {
        familyCollectionView.isHidden = true
        view.addSubview(inviteFamilyView)
        
        inviteFamilyView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(HomeAutoLayout.InviteFamilyView.topInset)
            $0.horizontalEdges.equalToSuperview().inset(HomeAutoLayout.InviteFamilyView.horizontalInset)
            $0.height.equalTo(HomeAutoLayout.InviteFamilyView.height)
        }
    }
    
    private func removeFamilyInviteView() {
        inviteFamilyView.removeFromSuperview()
    }
    
    private func addNoPostTodayView() {
        view.addSubview(noPostTodayView)
        feedCollectionView.isHidden = true
        
        noPostTodayView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(HomeAutoLayout.NoPostTodayView.topOffset)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func removeNoPostTodayView() {
        noPostTodayView.removeFromSuperview()
    }
    
    private func calculateRemainingTime(time: Int) -> Int {
        let calendar = Calendar.current
        let currentTime = Date()
        
        let isAfterNoon = calendar.component(.hour, from: currentTime) >= 12
        
        if isAfterNoon {
            if let nextMidnight = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: currentTime.addingTimeInterval(24 * 60 * 60)) {
                let timeDifference = calendar.dateComponents([.second], from: currentTime, to: nextMidnight)
                return max(0, timeDifference.second ?? 0)
            }
        }
        
        return 0
    }
    
    private func createFamilyDataSource() -> RxCollectionViewSectionedReloadDataSource<SectionModel<String, ProfileData>> {
        return RxCollectionViewSectionedReloadDataSource<SectionModel<String, ProfileData>>(
            configureCell: { (_, collectionView, indexPath, item) in
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FamilyCollectionViewCell.id, for: indexPath) as? FamilyCollectionViewCell else {
                    return UICollectionViewCell()
                }
                cell.setCell(data: item)
                return cell
            })
    }
    
    private func createFeedDataSource() -> RxCollectionViewSectionedReloadDataSource<SectionModel<String, PostListData>> {
        return RxCollectionViewSectionedReloadDataSource<SectionModel<String, PostListData>>(
            configureCell: { (_, collectionView, indexPath, item) in
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCollectionViewCell.id, for: indexPath) as? FeedCollectionViewCell else {
                    return UICollectionViewCell()
                }
                cell.setCell(data: item)
                return cell
            })
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == familyCollectionView {
            return CGSize(width: HomeAutoLayout.FamilyCollectionView.cellWidth, height: HomeAutoLayout.FamilyCollectionView.cellHeight)
        } else {
            let width = (collectionView.frame.size.width - 10) / 2
            return CGSize(width: width, height: width + 36)
        }
    }
}
