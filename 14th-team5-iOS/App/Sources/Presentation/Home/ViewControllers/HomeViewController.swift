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

final class HomeViewController: BaseViewController<HomeViewReactor> {
    private let navigationBarView: BibbiNavigationBarView = BibbiNavigationBarView()
    private let familyViewController: HomeFamilyViewController = HomeFamilyDIContainer().makeViewController()
    private let dividerView: UIView = UIView()
    private let timerLabel: BibbiLabel = BibbiLabel(.head1, alignment: .center)
    private let descriptionLabel: UILabel = BibbiLabel(.body2Regular, alignment: .center, textColor: .gray300)
    private let noPostTodayView: UIView = NoPostTodayView()
    private let postCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let balloonView: BalloonView = BalloonView()
    private let cameraButton: UIButton = UIButton()
    private let refreshControl: UIRefreshControl = UIRefreshControl()
    private let dataSource: RxCollectionViewSectionedReloadDataSource<PostSection.Model>  = {
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
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        navigationController?.navigationBar.isHidden = true
    }
    
    public override func bind(reactor: HomeViewReactor) {
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    public override func setupUI() {
        super.setupUI()
        
        addChild(familyViewController)
        view.addSubviews(navigationBarView, dividerView, timerLabel,
                         descriptionLabel, postCollectionView, noPostTodayView,
                         balloonView, cameraButton, familyViewController.view)
        
        familyViewController.didMove(toParent: self)
    }
    
    public override func setupAutoLayout() {
        super.setupAutoLayout()
        
        navigationBarView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(33)
            $0.horizontalEdges.equalToSuperview()
        }
        
        familyViewController.view.snp.makeConstraints {
            $0.top.equalTo(navigationBarView.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(90)
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
        
        noPostTodayView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(HomeAutoLayout.NoPostTodayView.topOffset)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    public override func setupAttributes() {
        super.setupAttributes()

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
        
        dividerView.do {
            $0.backgroundColor = .gray900
        }
        
        feedCollectionViewLayout.do {
            $0.sectionInset = .zero
            $0.minimumLineSpacing = HomeAutoLayout.FeedCollectionView.minimumLineSpacing
            $0.minimumInteritemSpacing = HomeAutoLayout.FeedCollectionView.minimumInteritemSpacing
        }
        
        postCollectionView.do {
            $0.refreshControl = refreshControl
            $0.register(FeedCollectionViewCell.self, forCellWithReuseIdentifier: FeedCollectionViewCell.id)
            $0.backgroundColor = .clear
        }
        
        noPostTodayView.do {
            $0.isHidden = true
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
    private func bindInput(reactor: HomeViewReactor) {
        postCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        Observable.just(())
            .map { Reactor.Action.startTimer }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rx.viewWillAppear
            .map { _ in Reactor.Action.viewWillAppear }
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
        
        postCollectionView.rx.itemSelected
            .throttle(RxConst.throttleInterval, scheduler: Schedulers.main)
            .bind(onNext: { [weak self] indexPath in
                guard let self else { return }
                let sectionModel = reactor.currentState.postSections

                self.navigationController?.pushViewController(
                    PostListsDIContainer().makeViewController(
                        postLists: sectionModel,
                        selectedIndex: indexPath
                    ),
                    animated: true
                )
            })
            .disposed(by: disposeBag)
        
        postCollectionView.rx.prefetchItems
            .throttle(.seconds(1), scheduler: Schedulers.main)
            .observe(on: Schedulers.main)
            .asObservable()
            .map(dataSource.items(at:))
            .map(Reactor.Action.prefetchItems)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        postCollectionView.rx.didScroll
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(self.postCollectionView.rx.contentOffset)
            .map { [weak self] in
              Reactor.Action.pagination(
                contentHeight: self?.postCollectionView.contentSize.height ?? 0,
                contentOffsetY: $0.y,
                scrollViewHeight: UIScreen.main.bounds.height
              )
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        refreshControl.rx.controlEvent(.valueChanged)
            .map { Reactor.Action.refreshCollectionview }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        cameraButton.rx.tap
            .throttle(RxConst.throttleInterval, scheduler: MainScheduler.instance)
            .withUnretained(self)
            .bind { owner, _ in
                MPEvent.Home.cameraTapped.track(with: nil)
                let cameraViewController = CameraDIContainer(cameraType: .realEmoji, memberId: App.Repository.member.memberID.value ?? "" ).makeViewController()
                owner.navigationController?.pushViewController(cameraViewController, animated: true)
            }.disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: HomeViewReactor) {
        reactor.state
            .map { $0.isRefreshing }
            .observe(on: MainScheduler.instance)
            .bind(onNext: { [weak postCollectionView] isRefreshing in
                if let refreshControl = postCollectionView?.refreshControl {
                    refreshControl.endRefreshing()
                    postCollectionView?.reloadData()
                }
            })
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$timer)
            .observe(on: Schedulers.main)
            .bind(to: timerLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$timerLabelColor)
            .observe(on: Schedulers.main)
            .bind(to: timerLabel.rx.textColor)
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.isHideCameraButton }
            .distinctUntilChanged()
            .observe(on: Schedulers.main)
            .withUnretained(self)
            .bind(onNext: { $0.0.hideCameraButton($0.1) })
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.descriptionText }
            .distinctUntilChanged()
            .observe(on: Schedulers.main)
            .bind(to: descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.postSections }
            .map(Array.init(with:))
            .distinctUntilChanged()
            .bind(to: postCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isShowingNoPostTodayView }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind(onNext: { $0.0.setNoPostTodayView($0.1) })
            .disposed(by: disposeBag)
    }
}

extension HomeViewController {
    private func setNoPostTodayView(_ isShow: Bool) {
        noPostTodayView.isHidden = !isShow
        postCollectionView.isHidden = isShow
    }

    private func hideCameraButton(_ isShow: Bool) {
        balloonView.isHidden = isShow
        cameraButton.isHidden = isShow
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let width = (collectionView.frame.size.width - 10) / 2
            return CGSize(width: width, height: width + 36)
    }
}
