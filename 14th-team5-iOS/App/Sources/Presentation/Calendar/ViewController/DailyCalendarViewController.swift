//
//  CalendarFeedViewController.swift
//  App
//
//  Created by 김건우 on 12/8/23.
//

import Core
import DesignSystem
import Domain
import UIKit

import FSCalendar
import Kingfisher
import ReactorKit
import RxCocoa
import RxSwift
import RxDataSources
import SnapKit
import Then

public final class DailyCalendarViewController: TempNavigationViewController<DailyCalendarViewReactor> {
    // MARK: - Views
    private let imageView: UIImageView = UIImageView()
    private let calendarView: FSCalendar = FSCalendar()
    private lazy var postCollectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: orthogonalCompositionalLayout
    )
    private let reactionViewController: ReactionViewController = ReactionViewControllerWrapper(type: .calendar, postListData: .empty).makeViewController()
    private let fireLottieView: LottieView = LottieView(with: .fire, contentMode: .scaleAspectFill)
    
    // MARK: - Properties
    private let visibleCellIndex: PublishRelay<Int> = PublishRelay<Int>()
    private lazy var dataSource = prepareDatasource()
    
    private let deepLinkRepo = DeepLinkRepository()
    
    // MARK: - Lifecycles
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        App.Repository.deepLink.notification.accept(nil)
    }

    // MARK: - Helpers
    public override func bind(reactor: DailyCalendarViewReactor) {
        super.bind(reactor: reactor)
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    private func bindInput(reactor: DailyCalendarViewReactor) {
        Observable<Date>.just(reactor.initialState.date)
            .flatMap {
                Observable.merge(
                    Observable.just(Reactor.Action.dateSelected($0)),
                    Observable.just(Reactor.Action.requestDailyCalendar($0))
                )
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        let previousNextMonths: [String] = reactor.currentState.date.makePreviousNextMonth()
        Observable<String>.from(previousNextMonths)
            .map { Reactor.Action.requestMonthlyCalendar($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        navigationBar.rx.didTapLeftBarButton
            .map { _ in Reactor.Action.popViewController }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        calendarView.rx.didSelect
            .distinctUntilChanged()
            .flatMap {
                Observable.merge(
                    Observable.just(Reactor.Action.dateSelected($0)),
                    Observable.just(Reactor.Action.requestDailyCalendar($0))
                )
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        calendarView.rx.calendarCurrentPageDidChange
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe {
                $0.0.setupNavigationTitle($0.1)
            }
            .disposed(by: disposeBag)
        
        calendarView.rx.fetchCalendarResponseDidChange
            .distinctUntilChanged()
            .flatMap {
                Observable<String>.from($0)
                    .map { Reactor.Action.requestMonthlyCalendar($0) }
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        calendarView.rx.boundingRectWillChange
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe { $0.0.updateCalendarViewConstraints($0.1) }
            .disposed(by: disposeBag)
        
        visibleCellIndex
            .flatMap {
                Observable.merge(
                    Observable.just(Reactor.Action.imageIndex($0)),
                    Observable.just(Reactor.Action.renewEmoji($0))
                )
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
    }
    
    private func bindOutput(reactor: DailyCalendarViewReactor) {
        reactor.state.map { $0.date }
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe { $0.0.calendarView.select($0.1, scrollToDate: true) }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$displayMonthlyCalendar)
            .withUnretained(self)
            .subscribe { $0.0.calendarView.reloadData() }
            .disposed(by: disposeBag)

        let postResponse = reactor.pulse(\.$displayDailyCalendar).asDriver(onErrorJustReturn: [])
        
        postResponse
            .drive(postCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        postResponse
            .drive(with: self) {
                guard let items = $1.first?.items else { return }

                var indexPath = IndexPath(item: 0, section: 0)
                // 알림으로 화면에 진입하면
                if let deepLink = reactor.currentState.notificationDeepLink {
                    let postId = deepLink.postId
                    guard let index = items.firstIndex(where: { post in
                              post.postId == postId
                          }) else { return }
                    indexPath = IndexPath(item: index, section: 0)
                }
                
                // 일반 루트로 화면에 진입하면
                $0.postCollectionView.scrollToItem(
                    at: indexPath,
                    at: .centeredHorizontally,
                    animated: false
                )
            }
            .disposed(by: disposeBag)
        
        reactor.state.compactMap { $0.imageUrl }
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe {
                guard let url: URL = URL(string: $0.1) else { return }
                KingfisherManager.shared.retrieveImage(with: url) { [unowned self] result in
                    switch result {
                    case let .success(value):
                        UIView.transition(
                            with: self.imageView,
                            duration: 0.15,
                            options: [.transitionCrossDissolve, .allowUserInteraction]) {
                                self.imageView.image = value.image
                            }
                    case .failure:
                        print("Kingfisher RetrieveImage Error")
                    }
                }
            }
            .disposed(by: disposeBag)
        
        reactor.state.compactMap { $0.visiblePost }
            .distinctUntilChanged()
            .withUnretained(self)
            .bind { owner, post in
                let postListData = PostEntity(
                    postId: post.postId,
                    author: FamilyMemberProfileEntity(memberId: post.authorId, name: ""),
                    commentCount: post.commentCount,
                    emojiCount: post.emojiCount,
                    imageURL: post.postImageUrl,
                    content: post.postContent,
                    time: post.createdAt.toFormatString(with: .dashYyyyMMdd)
                )
                owner.reactionViewController.postListData.accept(postListData)
            }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$shouldPushProfileViewController)
            .delay(.milliseconds(500), scheduler: RxSchedulers.main)
            .compactMap { $0 }
            .bind(with: self) { owner, id in
                owner.pushProfileViewController(memberId: id)
            }
            .disposed(by: disposeBag)
        
        let allUploadedToastMessageView = reactor.pulse(\.$shouldPresentAllUploadedToastMessageView)
            .asDriver(onErrorJustReturn: false)
        
        allUploadedToastMessageView
            .filter { $0 }
            .delay(RxConst.milliseconds100Interval)
            .drive(with: self, onNext: { owner, _ in
                owner.makeBibbiToastView(
                    text: "우리 가족 모두가 사진을 올린 날",
                    image: DesignSystemAsset.fire.image
                )
            })
            .disposed(by: disposeBag)
        
        allUploadedToastMessageView
            .filter { $0 }
            .delay(RxConst.milliseconds100Interval)
            .drive(with: self, onNext: { owner, _ in
                // 애니메이션 중이 아니라면
                if !owner.fireLottieView.isPlay {
                    owner.fireLottieView.play()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.9) {
                        owner.fireLottieView.stop()
                    }
                }
            })
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$shouldGenerateSelectionHaptic)
            .filter { $0 }
            .subscribe(onNext: { _ in Haptic.selection() })
            .disposed(by: disposeBag)
        
        // TODO: - 딥링크 코드 개선하기
        reactor.state.compactMap { $0.notificationDeepLink }
            .distinctUntilChanged(at: \.postId)
            .filter { $0.openComment }
            .bind(with: self) { owner, deepLink in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    let postCommentViewController = PostCommentDIContainer(
                        postId: deepLink.postId
                    ).makeViewController()
                    
                    owner.presentPostCommentSheet(
                        postCommentViewController,
                        from: .calendar
                    )
                }
            }
            .disposed(by: disposeBag)

        didTapCameraButtonNotifcationHandler()
    }
    
    public override func setupUI() {
        super.setupUI()
        view.addSubviews(imageView)
        imageView.addSubviews(calendarView, postCollectionView)
        view.addSubview(fireLottieView)
        
        addChild(reactionViewController)
        imageView.addSubview(reactionViewController.view)
        reactionViewController.didMove(toParent: self)
    }
    
    public override func setupAutoLayout() {
        super.setupAutoLayout()
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        calendarView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(350)
        }
        
        postCollectionView.snp.makeConstraints {
            $0.top.equalTo(calendarView.snp.bottom).offset(16)
            $0.height.equalTo(postCollectionView.snp.width).multipliedBy(1.15)
            $0.horizontalEdges.equalToSuperview()
        }
        
        fireLottieView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        reactionViewController.view.snp.makeConstraints {
            $0.top.equalTo(postCollectionView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        bringNavigationBarViewToFront()
    }
    
    public override func setupAttributes() {
        super.setupAttributes()
        imageView.do {
            $0.clipsToBounds = true
            $0.contentMode = .scaleAspectFill
            $0.isUserInteractionEnabled = true
        }
        
        navigationBar.do {
            $0.leftBarButtonItem = .arrowLeft
        }
        
        calendarView.do {
            $0.headerHeight = 0
            $0.weekdayHeight = 0
            
            $0.today = nil
            $0.scope = .week
            $0.allowsMultipleSelection = false
            
            $0.appearance.selectionColor = UIColor.clear
            
            $0.appearance.titleFont = UIFont.style(.body1Regular)
            $0.appearance.titleDefaultColor = UIColor.bibbiWhite
            $0.appearance.titleSelectionColor = UIColor.bibbiWhite
            
            $0.backgroundColor = UIColor.clear
            $0.register(MemoriesCalendarCell.self, forCellReuseIdentifier: MemoriesCalendarCell.id)
            $0.register(MemoriesCalendarPlaceholderCell.self, forCellReuseIdentifier: MemoriesCalendarPlaceholderCell.id)
            
            $0.dataSource = self
        }
        
        postCollectionView.do {
            $0.isScrollEnabled = false
            $0.backgroundColor = UIColor.clear
            $0.register(
                MemoriesCalendarPostCell.self,
                forCellWithReuseIdentifier: MemoriesCalendarPostCell.id
            )
        }
        
        fireLottieView.do {
            $0.stop()
            $0.isUserInteractionEnabled = false
        }
        
        setupBlurEffect()
        setupNavigationTitle(calendarView.currentPage)
    }
}

// MARK: - Extensions

extension DailyCalendarViewController {
    
    // 이름 바꾸기
    private var orthogonalCompositionalLayout: UICollectionViewCompositionalLayout {
        // item
        let itemSize: NSCollectionLayoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let item: NSCollectionLayoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // group
        let groupSize: NSCollectionLayoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let group: NSCollectionLayoutGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 1
        )
        
        // section
        let section: NSCollectionLayoutSection = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        
        section.visibleItemsInvalidationHandler = { [unowned self] visibleItems, offset, environment in
            let position: CGFloat =  offset.x / postCollectionView.frame.width
            let floorPosition: CGFloat = floor(position)
            let fractionPart: CGFloat = position - floorPosition
            
            if fractionPart <= 0.0 {
                let index: Int = Int(floorPosition)
                visibleCellIndex.accept(index) // reactor.onNext로 리팩토링하기
            }
        }
        
        // layout
        let layout: UICollectionViewCompositionalLayout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
}

extension DailyCalendarViewController {
    
    private func prepareDatasource() -> RxCollectionViewSectionedReloadDataSource<DailyCalendarSectionModel> {
        return RxCollectionViewSectionedReloadDataSource<DailyCalendarSectionModel> { datasource, collectionView, indexPath, post in
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MemoriesCalendarPostCell.id,
                for: indexPath
            ) as! MemoriesCalendarPostCell
            cell.reactor = CalendarPostCellDIContainer(post: post).makeReactor()
            return cell
        }
    }
    
    // 익스텐션으로 빼기
    private func setupBlurEffect() {
        let blurEffect = UIBlurEffect(style: .systemThinMaterialDark)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = view.frame
        imageView.insertSubview(visualEffectView, at: 0)
    }
    
    // 이름 바꾸기
    private func setupNavigationTitle(_ date: Date) {
        navigationBar.navigationTitle = date.toFormatString(with: .yyyyM)
    }
    
    private func updateCalendarViewConstraints(_ bounds: CGRect) {
        calendarView.snp.updateConstraints {
            $0.height.equalTo(bounds.height)
        }
        view.layoutIfNeeded()
    }
    
    // 삭제하기
    private func pushCameraViewController(cameraType type: UploadLocation) {
        let cameraViewController = CameraViewControllerWrapper(cameraType: type).viewController
        
        navigationController?.pushViewController(
            cameraViewController,
            animated: true
        )
    }
    
    // 삭제하기
    private func pushProfileViewController(memberId: String) {
        let profileController = ProfileViewControllerWrapper(
            memberId: memberId
        ).viewController
        
        navigationController?.pushViewController(
            profileController,
            animated: true
        )
    }
}

extension DailyCalendarViewController {
    
    // 삭제하기
    private func didTapCameraButtonNotifcationHandler() {
        NotificationCenter.default
            .rx.notification(.didTapSelectableCameraButton)
            .withUnretained(self)
            .bind { owner, _ in
                owner.pushCameraViewController(cameraType: .realEmoji)
            }
            .disposed(by: disposeBag)
    }
    
    
}

extension DailyCalendarViewController: FSCalendarDataSource {
    
    public func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(
            withIdentifier: MemoriesCalendarCell.id,
            for: date,
            at: position
        ) as! MemoriesCalendarCell
        
        
        // 추후 캐시 기능 도입 감안해서 리팩토링하기
        
        // 해당 일에 불러온 데이터가 없다면
        let yearMonth: String = date.toFormatString(with: .dashYyyyMM)
        guard let currentState = reactor?.currentState,
              let monthlyEntity = currentState.displayMonthlyCalendar[yearMonth]?.filter({ $0.date.isEqual(with: date) }).first
        else {
            let emptyEntity = MonthlyCalendarEntity(
                date: date,
                representativePostId: .none,
                representativeThumbnailUrl: .none,
                allFamilyMemebersUploaded: false
            )
            cell.reactor = CalendarImageCellDIContainer(
                type: .daily,
                monthlyEntity: emptyEntity
            ).makeReactor()
            return cell
        }
        
        cell.reactor = CalendarImageCellDIContainer(
            type: .daily,
            monthlyEntity: monthlyEntity,
            isSelected: currentState.date.isEqual(with: date)
        ).makeReactor()
        return cell
    }
    
}
