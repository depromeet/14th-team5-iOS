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

fileprivate typealias _Str = CalendarStrings
public final class CalendarPostViewController: BaseViewController<CalendarPostViewReactor> {
    // MARK: - Views
    private let blurImageView: UIImageView = UIImageView()

    private let calendarView: FSCalendar = FSCalendar()
    private lazy var postCollectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: orthogonalCompositionalLayout
    )
    private let reactionViewController: ReactionViewController = ReactionDIContainer().makeViewController(
        post: .init(
            postId: "", author: nil, commentCount: 0, emojiCount: 0,
            imageURL: "", content: nil, time: ""
        )
    )
    
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
        // HomeViewController는 notification이 nil일 때만
        // ViewWillAppear시 가족과 피드를 불러오므로, nil 항목 전달이 필수임
        App.Repository.deepLink.notification.accept(nil)
    }

    // MARK: - Helpers
    public override func bind(reactor: CalendarPostViewReactor) {
        super.bind(reactor: reactor)
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    private func bindInput(reactor: CalendarPostViewReactor) {
        let selectedDate: Date = reactor.currentState.selectedDate
        Observable<Date>.just(selectedDate)
            .flatMap {
                Observable.merge(
                    Observable.just(Reactor.Action.didSelectDate($0)),
                    Observable.just(Reactor.Action.fetchPostList($0))
                )
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        let previousNextMonths: [String] = reactor.currentState.selectedDate.createPreviousNextDateStringArray()
        Observable<String>.from(previousNextMonths)
            .map { Reactor.Action.fetchCalendarResponse($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        navigationBarView.rx.leftButtonTap
            .map { _ in Reactor.Action.popViewController }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        calendarView.rx.didSelect
            .distinctUntilChanged()
            .flatMap {
                Observable.merge(
                    Observable.just(Reactor.Action.didSelectDate($0)),
                    Observable.just(Reactor.Action.fetchPostList($0))
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
                    .map { Reactor.Action.fetchCalendarResponse($0) }
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        calendarView.rx.boundingRectWillChange
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe { $0.0.updateCalendarViewConstraints($0.1) }
            .disposed(by: disposeBag)
        
//        postCollectionView.rx.willBeginDragging
//            .observe(on: MainScheduler.instance)
//            .bind(onNext: { [weak self] _ in
//                guard let self = self else { return }
//                UIView.animate(withDuration: 0.3) {
//                    self.reactionViewController.view.alpha = 0
//                }
//            })
//            .disposed(by: disposeBag)
        
        visibleCellIndex
            .flatMap {
                Observable.merge(
                    Observable.just(Reactor.Action.setBlurImageIndex($0)),
                    Observable.just(Reactor.Action.sendPostToReaction($0))
                )
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
    }
    
    private func bindOutput(reactor: CalendarPostViewReactor) {
        reactor.state.map { $0.selectedDate }
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe { $0.0.calendarView.select($0.1, scrollToDate: true) }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$displayCalendarResponse)
            .withUnretained(self)
            .subscribe { $0.0.calendarView.reloadData() }
            .disposed(by: disposeBag)

        let postResponse = reactor.pulse(\.$displayPostResponse).asDriver(onErrorJustReturn: [])
        
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
        
        reactor.state.compactMap { $0.blurImageUrlString }
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe {
                guard let url: URL = URL(string: $0.1) else { return }
                KingfisherManager.shared.retrieveImage(with: url) { [unowned self] result in
                    switch result {
                    case let .success(value):
                        UIView.transition(
                            with: self.blurImageView,
                            duration: 0.15,
                            options: [.transitionCrossDissolve, .allowUserInteraction]) {
                                self.blurImageView.image = value.image
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
                let postListData = PostListData(
                    postId: post.postId,
                    author: ProfileData(memberId: post.authorId, name: ""),
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
            .delay(.milliseconds(500), scheduler: Schedulers.main)
            .compactMap { $0 }
            .bind(with: self) { owner, id in
                owner.pushProfileViewController(memberId: id)
            }
            .disposed(by: disposeBag)
        
        let allUploadedToastMessageView = reactor.pulse(\.$shouldPresentAllUploadedToastMessageView)
            .asDriver(onErrorJustReturn: false)
        
        allUploadedToastMessageView
            .filter { $0 }
            .delay(RxConst.smallDelayInterval)
            .drive(with: self, onNext: { owner, _ in
                owner.makeBibbiToastView(
                    text: _Str.allFamilyUploadedText,
                    image: DesignSystemAsset.fire.image
                )
            })
            .disposed(by: disposeBag)
        
        allUploadedToastMessageView
            .filter { $0 }
            .delay(RxConst.smallDelayInterval)
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
        
//        reactor.pulse(\.$shouldPopViewController)
//            .filter { $0 }
//            .withUnretained(self)
//            .subscribe { $0.0.navigationController?.popViewController(animated: true) }
//            .disposed(by: disposeBag)
        
        // 댓글 노티피케이션 딥링크 코드
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
        view.addSubviews(
            blurImageView, navigationBarView
        )
        blurImageView.addSubviews(
            calendarView, postCollectionView
        )
        view.addSubview(fireLottieView)
        
        addChild(reactionViewController)
        blurImageView.addSubview(reactionViewController.view)
        reactionViewController.didMove(toParent: self)
    }
    
    public override func setupAutoLayout() {
        super.setupAutoLayout()
        blurImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        calendarView.snp.makeConstraints {
            $0.top.equalTo(navigationBarView.snp.bottom).offset(16)
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
    }
    
    public override func setupAttributes() {
        super.setupAttributes()
        blurImageView.do {
            $0.clipsToBounds = true
            $0.contentMode = .scaleAspectFill
            $0.isUserInteractionEnabled = true
        }
        
        navigationBarView.do {
            $0.setNavigationView(leftItem: .arrowLeft, rightItem: .empty)
        }
        
        calendarView.do {
            $0.headerHeight = 0
            $0.weekdayHeight = 0
            
            $0.today = nil
            $0.scope = .week
            $0.allowsMultipleSelection = false
            
            $0.appearance.selectionColor = UIColor.clear
            
            $0.appearance.titleFont = UIFont.pretendard(.body1Regular)
            $0.appearance.titleDefaultColor = UIColor.bibbiWhite
            $0.appearance.titleSelectionColor = UIColor.bibbiWhite
            
            $0.backgroundColor = UIColor.clear
            $0.register(ImageCalendarCell.self, forCellReuseIdentifier: ImageCalendarCell.id)
            $0.register(PlaceholderCalendarCell.self, forCellReuseIdentifier: PlaceholderCalendarCell.id)
            
            $0.dataSource = self
        }
        
        postCollectionView.do {
            $0.isScrollEnabled = false
            $0.backgroundColor = UIColor.clear
            $0.register(
                CalendarPostCell.self,
                forCellWithReuseIdentifier: CalendarPostCell.id
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
extension CalendarPostViewController {
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
                visibleCellIndex.accept(index)
            }
        }
        
        // layout
        let layout: UICollectionViewCompositionalLayout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
}

extension CalendarPostViewController {
    private func prepareDatasource() -> RxCollectionViewSectionedReloadDataSource<CalendarPostSectionModel> {
        return RxCollectionViewSectionedReloadDataSource<CalendarPostSectionModel> { datasource, collectionView, indexPath, post in
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CalendarPostCell.id,
                for: indexPath
            ) as! CalendarPostCell
            cell.reactor = CalendarPostCellDIContainer(post: post).makeReactor()
            return cell
        }
    }
    
    private func setupBlurEffect() {
        let blurEffect = UIBlurEffect(style: .systemThinMaterialDark)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = view.frame
        blurImageView.insertSubview(visualEffectView, at: 0)
    }
    
    private func setupNavigationTitle(_ date: Date) {
        navigationBarView.setNavigationTitle(title: date.toFormatString(with: .yyyyM))
    }
    
    private func updateCalendarViewConstraints(_ bounds: CGRect) {
        calendarView.snp.updateConstraints {
            $0.height.equalTo(bounds.height)
        }
        view.layoutIfNeeded()
    }
    
    private func pushCameraViewController(cameraType type: UploadLocation) {
        let cameraViewController = CameraDIContainer(
            cameraType: type
        ).makeViewController()
        
        navigationController?.pushViewController(
            cameraViewController,
            animated: true
        )
    }
    
    private func pushProfileViewController(memberId: String) {
        let profileController = ProfileDIContainer(
            memberId: memberId
        ).makeViewController()
        
        navigationController?.pushViewController(
            profileController,
            animated: true
        )
    }
}

extension CalendarPostViewController {
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

extension CalendarPostViewController: FSCalendarDataSource {
    public func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(
            withIdentifier: ImageCalendarCell.id,
            for: date,
            at: position
        ) as! ImageCalendarCell
        
        // 해당 일에 불러온 데이터가 없다면
        let yyyyMM: String = date.toFormatString()
        guard let currentState = reactor?.currentState,
              let dayResponse = currentState.displayCalendarResponse[yyyyMM]?.filter({ $0.date.isEqual(with: date) }).first
        else {
            let emptyResponse = CalendarEntity(
                date: date,
                representativePostId: .none,
                representativeThumbnailUrl: .none,
                allFamilyMemebersUploaded: false
            )
            cell.reactor = ImageCalendarCellDIContainer(
                .week,
                dayResponse: emptyResponse
            ).makeReactor()
            return cell
        }
        
        cell.reactor = ImageCalendarCellDIContainer(
            .week,
            isSelected: currentState.selectedDate.isEqual(with: date),
            dayResponse: dayResponse
        ).makeReactor()
        return cell
    }
}
