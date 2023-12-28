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
    private let postCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let balloonView: BalloonView = BalloonView()
    private let cameraButton: UIButton = UIButton()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    deinit {
        print("deinit HomeViewController")
    }
    
    public override func bind(reactor: HomeViewReactor) {
        familyCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        postCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        Observable.merge(
            Observable.just(()).map { Reactor.Action.getFamilyMembers },
            Observable.just(()).map { Reactor.Action.getTodayPostList }
        )
        .bind(to: reactor.action)
        .disposed(by: disposeBag)
        
        Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
            .startWith(0)
            .map { [weak self] _ in
                guard let self = self else { return HomeStrings.Timer.notTime }
                guard let time = self.calculateRemainingTime().setTimerFormat() else {
                    self.hideCameraButton(true)
                    return HomeStrings.Timer.notTime
                }
                return time
            }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] time in
                guard let self = self else { return }
                self.timerLabel.text = time
            })
            .disposed(by: disposeBag)
        
        postCollectionView.rx.itemSelected
            .withUnretained(self)
            .throttle(RxConst.throttleInterval, scheduler: Schedulers.main)
            .bind(onNext: {
                $0.0.navigationController?.pushViewController(PostViewController(reacter: PostReactor()), animated: true)
            })
            .disposed(by: disposeBag)
        
        cameraButton
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
            .compactMap({$0})
            .observe(on: Schedulers.main)
            .bind(to: descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.familySections }
            .asObservable()
            .bind(to: familyCollectionView.rx.items(dataSource: createFamilyDataSource()))
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.feedSections }
            .asObservable()
            .bind(to: postCollectionView.rx.items(dataSource: createFeedDataSource()))
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
        
        reactor.state
            .map { $0.didPost }
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind(onNext: {
                $0.0.hideCameraButton($0.1)
            })
            .disposed(by: disposeBag)
    }
    
    public override func setupUI() {
        super.setupUI()
        
        view.addSubviews(familyCollectionView, dividerView, timerLabel, descriptionLabel,
                         postCollectionView, balloonView, cameraButton)
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
        
        postCollectionView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(HomeAutoLayout.FeedCollectionView.topOffset)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
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
        
        postCollectionView.do {
            $0.register(FeedCollectionViewCell.self, forCellWithReuseIdentifier: FeedCollectionViewCell.id)
            $0.backgroundColor = .clear
        }
        
        balloonView.do {
            $0.text = "하루에 한번 사진을 올릴 수 있어요"
        }
        
        cameraButton.do {
            $0.setImage(DesignSystemAsset.camerButton.image, for: .normal)
        }
    }
}

extension HomeViewController {
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
        postCollectionView.isHidden = true
        
        noPostTodayView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(HomeAutoLayout.NoPostTodayView.topOffset)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func removeNoPostTodayView() {
        noPostTodayView.removeFromSuperview()
    }
    
    private func hideCameraButton(_ isShow: Bool) {
        balloonView.isHidden = isShow
        cameraButton.isHidden = isShow
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
