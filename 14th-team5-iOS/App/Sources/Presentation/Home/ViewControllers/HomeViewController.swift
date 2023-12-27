//
//  HomeViewController.swift
//  App
//
//  Created by 마경미 on 05.12.23.
//

import UIKit
import Core
import DesignSystem

import RxDataSources
import RxCocoa
import RxSwift
import SnapKit
import Then

final class HomeViewController: BaseViewController<HomeViewReactor> {
    private let manageFamilyButton: UIBarButtonItem = UIBarButtonItem()
    private let calendarButton: UIBarButtonItem = UIBarButtonItem()
    private let familyCollectionViewLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    private let familyCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let inviteFamilyView: UIView = InviteFamilyView()
    private let timerLabel: UILabel = UILabel()
    private let descriptionLabel: UILabel = UILabel()
    private let noPostTodayView: UIView = NoPostTodayView()
    private let feedCollectionViewLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    private let feedCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let camerButton: UIButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    deinit {
        print("deinit HomeViewController")
    }
    
    override func bind(reactor: HomeViewReactor) {
        familyCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        feedCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)

        // 통신 이후에 observable로 변경하기
//        reactor.action.onNext(.setTimer)
        Observable.interval(.seconds(1), scheduler: MainScheduler.instance)
            .map { (time: Int) in
                let remainingTime = self.calculateRemainingTime(time: time)
                return self.setTimerFormat(remainingTime: remainingTime)
            }
            .bind(to: timerLabel.rx.text)
            .disposed(by: disposeBag)
        
        feedCollectionView.rx.itemSelected
            .withUnretained(self)
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .bind(onNext: {
                $0.0.navigationController?.pushViewController(PostViewController(reacter: PostReactor()), animated: true)
            })
            .disposed(by: disposeBag)
        
        camerButton
            .rx.tap
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .bind { owner, _ in
                let cameraViewController = CameraDIContainer(cameraType: .feed).makeViewController()
                owner.navigationController?.pushViewController(cameraViewController, animated: true)
            }.disposed(by: disposeBag)
        
        inviteFamilyView.rx.tap
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
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
            .withUnretained(self)
            .bind(onNext: {
                $0.0.addFamilyInviteView()
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isShowingNoPostTodayView }
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind(onNext: {
                $0.0.addNoPostTodayView()
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
    
    override func setupUI() {
        super.setupUI()
        
        view.addSubviews(familyCollectionView, timerLabel, descriptionLabel,
                         feedCollectionView, camerButton)
    }
    
    override func setupAutoLayout() {
        super.setupAutoLayout()
        
        familyCollectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(24)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(90)
        }
        
        timerLabel.snp.makeConstraints {
            $0.top.equalTo(familyCollectionView.snp.bottom).offset(24)
            $0.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(timerLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
        
        feedCollectionView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview()
        }
        
        camerButton.snp.makeConstraints {
            $0.top.equalTo(feedCollectionView.snp.bottom).offset(12)
            $0.size.equalTo(72)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(30)
        }
    }
    
    override func setupAttributes() {
        super.setupAttributes()
        
        navigationItem.do {
            $0.title = "로고"
            $0.leftBarButtonItem = manageFamilyButton
            $0.rightBarButtonItem = calendarButton
        }
        
        manageFamilyButton.do {
            $0.image = UIImage(named: "Profile")
            $0.target = self
        }
        
        calendarButton.do {
            $0.image = UIImage(named: "Calendar")
            $0.target = self
        }
        
        familyCollectionViewLayout.do {
            $0.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            $0.minimumLineSpacing = 12
        }
        
        familyCollectionView.do {
            $0.register(FamilyCollectionViewCell.self, forCellWithReuseIdentifier: FamilyCollectionViewCell.id)
            $0.backgroundColor = .clear
            $0.collectionViewLayout = familyCollectionViewLayout
        }
        
        feedCollectionViewLayout.do {
            $0.sectionInset = .zero
            $0.minimumLineSpacing = 16
            $0.minimumInteritemSpacing = 0
        }
        
        feedCollectionView.do {
            $0.register(FeedCollectionViewCell.self, forCellWithReuseIdentifier: FeedCollectionViewCell.id)
            $0.backgroundColor = .clear
        }
        
        camerButton.do {
            $0.setImage(UIImage(named: "Shutter"), for: .normal)
        }
    }
}

extension HomeViewController {
    private func setTimerFormat(remainingTime: Int) -> String {
        if remainingTime <= 0 {
            return "00:00:00"
        }
        
        let hours = remainingTime / 3600
        let minutes = (remainingTime % 3600) / 60
        let seconds = remainingTime % 60
        
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    private func addFamilyInviteView() {
        view.addSubview(inviteFamilyView)
        familyCollectionView.isHidden = true
        
        inviteFamilyView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(24)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(90)
        }
    }
    
    private func removeFamilyInviteView() {
        inviteFamilyView.removeFromSuperview()
    }
    
    private func addNoPostTodayView() {
        view.addSubview(noPostTodayView)
        feedCollectionView.isHidden = true
        
        feedCollectionView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(149)
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
    
    private func createFeedDataSource() -> RxCollectionViewSectionedReloadDataSource<SectionModel<String, FeedData>> {
        return RxCollectionViewSectionedReloadDataSource<SectionModel<String, FeedData>>(
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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == familyCollectionView {
            return CGSize(width: 64, height: 90)
        } else {
            let width = (collectionView.frame.size.width - 10) / 2
            return CGSize(width: width, height: width + 36)
        }
    }
}
