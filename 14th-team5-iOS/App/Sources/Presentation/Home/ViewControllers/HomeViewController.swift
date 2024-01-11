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
    private let navigationBarView: BibbiNavigationBarView = BibbiNavigationBarView()
    private let familyCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let inviteFamilyView: UIView = InviteFamilyView()
    private let dividerView: UIView = UIView()
    private let timerLabel: BibbiLabel = BibbiLabel(.head1, alignment: .center)
    private let descriptionLabel: UILabel = BibbiLabel(.body2Regular, alignment: .center, textColor: .gray300)
    private let noPostTodayView: UIView = NoPostTodayView()
    private let postCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let balloonView: BalloonView = BalloonView()
    private let cameraButton: UIButton = UIButton()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    deinit {
        print("deinit HomeViewController")
    }
    
    public override func bind(reactor: HomeViewReactor) {
        familyCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        postCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        Observable<Void>.just(())
            .take(1)
            .map { Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        Observable.concat (
            Observable.just(()).map { Reactor.Action.getFamilyMembers },
            Observable.just(()).map { Reactor.Action.getTodayPostList }
        )
        .bind(to: reactor.action)
        .disposed(by: disposeBag)
        
        Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
            .startWith(0)
            .map { [weak self] _ in
                guard let self = self else { return HomeStrings.Timer.notTime }
                let time = self.calculateRemainingTime()
                guard let timeString = time.setTimerFormat() else {
                    self.hideCameraButton(true)
                    return HomeStrings.Timer.notTime
                }

                if time <= 3600 && !reactor.currentState.didPost {
                    self.timerLabel.textBibbiColor = .warningRed
                    self.descriptionLabel.text = "시간이 얼마 남지 않았어요!"
                }

                return timeString
            }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] time in
                guard let self = self else { return }

                self.timerLabel.text = time
            })
            .disposed(by: disposeBag)
        
        navigationBarView.rx.didTapLeftBarButton
            .throttle(RxConst.throttleInterval, scheduler: Schedulers.main)
            .withUnretained(self)
            .subscribe {
                $0.0.navigationController?.pushViewController(
                    InviteFamilyDIContainer().makeViewController(),
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
        
        familyCollectionView
            .rx.modelSelected(ProfileData.self)
            .map { $0.memberId }
            .withUnretained(self)
            .bind { owner, memberId in
                let profileViewController = ProfileDIContainer(memberId: memberId).makeViewController()
                self.navigationController?.pushViewController(profileViewController, animated: true)
            }.disposed(by: disposeBag)
        
        postCollectionView.rx.itemSelected
            .throttle(RxConst.throttleInterval, scheduler: Schedulers.main)
            .bind(onNext: { [weak self] indexPath in
                guard let self else { return }
                let sectionModel = reactor.currentState.feedSections[indexPath.section]
                let selectedItem = sectionModel.items[indexPath.item]

                self.navigationController?.pushViewController(
                    PostListsDIContainer().makeViewController(
                        postLists: sectionModel,
                        selectedIndex: indexPath
                    ),
                    animated: true
                )
            })
            .disposed(by: disposeBag)
        
        cameraButton
            .rx.tap
            .throttle(RxConst.throttleInterval, scheduler: MainScheduler.instance)
            .withUnretained(self)
            .bind { owner, _ in
                let cameraViewController = CameraDIContainer(cameraType: .feed).makeViewController()
                owner.navigationController?.pushViewController(cameraViewController, animated: true)
            }.disposed(by: disposeBag)
        
        inviteFamilyView.rx.tap
            .throttle(RxConst.throttleInterval, scheduler: Schedulers.main)
            .map { Reactor.Action.tapInviteFamily }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.descriptionText }
            .distinctUntilChanged()
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
            .distinctUntilChanged()
            .bind(to: postCollectionView.rx.items(dataSource: createFeedDataSource()))
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isShowingInviteFamilyView }
            .distinctUntilChanged()
            .observe(on: Schedulers.main)
            .withUnretained(self)
            .bind(onNext: { $0.0.setFamilyInviteView($0.1) })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isShowingNoPostTodayView }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind(onNext: { $0.0.setNoPostTodayView($0.1) })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.familyInvitationLink }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind(onNext: {
                $0.0.makeInvitationUrlSharePanel($0.1, provider: reactor.provider)
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.didPost }
            .observe(on: MainScheduler.instance)
            .distinctUntilChanged()
            .withUnretained(self)
            .bind(onNext: {
                $0.0.hideCameraButton($0.1)
            })
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$shouldPresentCopySuccessToastMessageView)
            .skip(1)
            .withUnretained(self)
            .subscribe {
                $0.0.makeBibbiToastView(
                    text: AddFamilyVC.Strings.successCopyInvitationUrl,
                    symbol: "link",
                    width: 210
                )
            }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$shouldPresentFetchFailureToastMessageView)
            .skip(1)
            .withUnretained(self)
            .subscribe {
                $0.0.makeBibbiToastView(
                    text: "링크 불러오기 실패",
                    symbol: "exclamationmark.triangle.fill",
                    palletteColors: [UIColor.systemRed],
                    width: 190
                )
            }
            .disposed(by: disposeBag)
    }
    
    public override func setupUI() {
        super.setupUI()
        
        view.addSubviews(navigationBarView, familyCollectionView, dividerView, timerLabel, descriptionLabel,
                         postCollectionView, balloonView, cameraButton)
    }
    
    public override func setupAutoLayout() {
        super.setupAutoLayout()
        
        navigationBarView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(33)
            $0.horizontalEdges.equalToSuperview()
        }
        
        familyCollectionView.snp.makeConstraints {
            $0.top.equalTo(navigationBarView.snp.bottom).offset(HomeAutoLayout.FamilyCollectionView.topInset)
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
        
        familyCollectionViewLayout.do {
            $0.scrollDirection = .horizontal
            $0.sectionInset = UIEdgeInsets(
                top: HomeAutoLayout.FamilyCollectionView.edgeInsetTop,
                left: HomeAutoLayout.FamilyCollectionView.edgeInsetLeft,
                bottom: HomeAutoLayout.FamilyCollectionView.edgeInsetBottom,
                right: HomeAutoLayout.FamilyCollectionView.edgeInsetRight)
            $0.minimumLineSpacing = HomeAutoLayout.FamilyCollectionView.minimumLineSpacing
        }
        
        familyCollectionView.do {
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
            $0.register(FamilyCollectionViewCell.self, forCellWithReuseIdentifier: FamilyCollectionViewCell.id)
            $0.backgroundColor = .clear
            $0.collectionViewLayout = familyCollectionViewLayout
        }
        
        
        dividerView.do {
            $0.backgroundColor = .gray900
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
    private func setFamilyInviteView(_ isShow: Bool) {
        if isShow {
            familyCollectionView.isHidden = isShow
            view.addSubview(inviteFamilyView)
            
            inviteFamilyView.snp.makeConstraints {
                $0.top.equalTo(navigationBarView.snp.bottom).offset(HomeAutoLayout.InviteFamilyView.topInset)
                $0.horizontalEdges.equalToSuperview().inset(HomeAutoLayout.InviteFamilyView.horizontalInset)
                $0.height.equalTo(HomeAutoLayout.InviteFamilyView.height)
            }
        } else {
            inviteFamilyView.removeFromSuperview()
        }
    }
    
    private func setNoPostTodayView(_ isShow: Bool) {
        if isShow {
            view.addSubview(noPostTodayView)
            postCollectionView.isHidden = isShow
            
            noPostTodayView.snp.makeConstraints {
                $0.top.equalTo(descriptionLabel.snp.bottom).offset(HomeAutoLayout.NoPostTodayView.topOffset)
                $0.horizontalEdges.equalToSuperview()
                $0.bottom.equalTo(view.safeAreaLayoutGuide)
            }
        } else {
            noPostTodayView.removeFromSuperview()
        }
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
