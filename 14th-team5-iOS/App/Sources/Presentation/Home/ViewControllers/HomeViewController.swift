//
//  HomeViewController.swift
//  App
//
//  Created by 마경미 on 05.12.23.
//

import UIKit
import Core

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
    private let familyInviteView: UIView = FamilyInviteView()
    private let timerLabel: UILabel = UILabel()
    private let descriptionLabel: UILabel = UILabel()
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

        reactor.action.onNext(.setTimer)
        
        feedCollectionView.rx.itemSelected
            .withUnretained(self)
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .bind(onNext: {
                $0.0.navigationController?.pushViewController(FeedDetailViewController(reacter: FeedDetailReactor()), animated: true)
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.remainingTime }
            .observe(on: Schedulers.main)
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe(onNext: {
                $0.setTimerFormat(remainingTime: $1)
            })
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
            .withUnretained(self)
            .bind(onNext: {_ in
                self.addFamilyInviteView()
            })
            .disposed(by: disposeBag)
        
        camerButton
            .rx.tap
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .bind { owner, _ in
                let cameraViewController = CameraDIContainer().makeViewController()
                owner.navigationController?.pushViewController(cameraViewController, animated: true)
            }.disposed(by: disposeBag)
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
    private func setTimerFormat(remainingTime: Int) {
        if remainingTime <= 0 {
            timerLabel.text = "00:00:00"
            return
        }
        
        let hours = remainingTime / 3600
        let minutes = (remainingTime % 3600) / 60
        let seconds = remainingTime % 60
        
        timerLabel.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    private func addFamilyInviteView() {
        view.addSubview(familyInviteView)
        familyCollectionView.isHidden = true
        
        familyInviteView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(24)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(90)
        }
    }
    
    private func removeFamilyInviteView() {
        familyInviteView.removeFromSuperview()
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
