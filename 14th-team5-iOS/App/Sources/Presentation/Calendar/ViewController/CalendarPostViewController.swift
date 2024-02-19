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
    private let navigationBarView: BibbiNavigationBarView = BibbiNavigationBarView()
    private let blurImageView: UIImageView = UIImageView()

    private let calendarView: FSCalendar = FSCalendar()
    private lazy var postCollectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: orthogonalCompositionalLayout
    )
    private let reactionViewController: ReactionViewController = ReactionDIContainer().makeViewController(post: .init(postId: "", author: nil, commentCount: 0, emojiCount: 0, imageURL: "", content: nil, time: ""))
    
    private let fireLottieView: LottieView = LottieView(with: .fire, contentMode: .scaleAspectFill)
    
    // MARK: - Properties
    private let cellIndexRelay: PublishRelay<Int> = PublishRelay<Int>()
    private lazy var dataSource: RxCollectionViewSectionedReloadDataSource<PostListSectionModel> = prepareDatasource()
    
    // MARK: - Lifecycles
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
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
        
        let previousNextMonths: [String] = reactor.currentState.selectedDate.generatePreviousNextYearMonth()
        Observable<String>.from(previousNextMonths)
            .map { Reactor.Action.fetchCalendarResponse($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        navigationBarView.rx.didTapLeftBarButton
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
            .subscribe { $0.0.adjustWeeklyCalendarRect($0.1) }
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
        
        cellIndexRelay
            .flatMap {
                Observable.merge(
                    Observable.just(Reactor.Action.setBlurImageIndex($0)),
                    Observable.just(Reactor.Action.sendPostIdToReaction($0))
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
            .distinctUntilChanged()
            .drive(with: self) {
                guard let items = $1.first?.items,
                      !items.isEmpty else { return }
                let indexPath = IndexPath(item: 0, section: 0)
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
        
        reactor.state.compactMap { $0.visiblePostList }
            .map { $0 }
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe { $0.0.reactionViewController.postListData.accept($0.1) }
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
        
        reactor.pulse(\.$shouldPopViewController)
            .filter { $0 }
            .withUnretained(self)
            .subscribe { $0.0.navigationController?.popViewController(animated: true) }
            .disposed(by: disposeBag)
        
        didTapProfileImageNotificationHandler()
        didTapSelectableCameraButtonNotifcationHandler()
    }
    
    public override func setupUI() {
        super.setupUI()
        view.addSubviews(
            navigationBarView, blurImageView
        )
        blurImageView.addSubviews(
            navigationBarView, calendarView, postCollectionView
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
        
        navigationBarView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(42)
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
            $0.leftBarButtonItem = .arrowLeft
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
            $0.register(PostDetailCollectionViewCell.self, forCellWithReuseIdentifier: PostDetailCollectionViewCell.id)
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
                cellIndexRelay.accept(index)
                debugPrint("cellIndexRelay: \(index)")
            }
        }
        
        // layout
        let layout: UICollectionViewCompositionalLayout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
}

extension CalendarPostViewController {
    private func prepareDatasource() -> RxCollectionViewSectionedReloadDataSource<PostListSectionModel> {
        return RxCollectionViewSectionedReloadDataSource<PostListSectionModel> { datasource, collectionView, indexPath, post in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostDetailCollectionViewCell.id, for: indexPath) as! PostDetailCollectionViewCell
            cell.reactor = PostDetailCellDIContainer().makeReactor(type: .calendar, post: post)
            return cell
        }
    }
    
    private func setupBlurEffect() {
        let blurEffect = UIBlurEffect(style: .systemThickMaterialDark)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.alpha = 0.95
        visualEffectView.frame = view.frame
        blurImageView.insertSubview(visualEffectView, at: 0)
    }
    
    private func setupNavigationTitle(_ date: Date) {
        navigationBarView.navigationTitle = DateFormatter.yyyyMM.string(from: date)
    }
    
    private func adjustWeeklyCalendarRect(_ bounds: CGRect) {
        calendarView.snp.updateConstraints {
            $0.height.equalTo(bounds.height)
        }
        view.layoutIfNeeded()
    }
    
    private func presentPostCommentSheet(postId: String) {
        let postCommentSheet = PostCommentDIContainer(postId: postId).makeViewController()
        
        if let sheet = postCommentSheet.sheetPresentationController {
            if #available(iOS 16.0, *) {
                let customId = UISheetPresentationController.Detent.Identifier("customId")
                let customDetents = UISheetPresentationController.Detent.custom(identifier: customId) {
                    return $0.maximumDetentValue * 0.835
                }
                sheet.detents = [customDetents, .large()]
            } else {
                sheet.detents = [.medium(), .large()]
            }
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        }
        
        present(postCommentSheet, animated: true)
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
    private func didTapSelectableCameraButtonNotifcationHandler() {
        NotificationCenter.default
            .rx.notification(.didTapSelectableCameraButton)
            .withUnretained(self)
            .bind { owner, _ in
                owner.pushCameraViewController(cameraType: .realEmoji)
            }.disposed(by: disposeBag)
    }
    
    private func didTapProfileImageNotificationHandler() {
        NotificationCenter.default
            .rx.notification(.didTapProfilImage)
            .withUnretained(self)
            .bind { owner, notification in
                guard let userInfo = notification.userInfo,
                      let memberId = userInfo["memberId"] as? String else {
                    return
                }
                owner.pushProfileViewController(memberId: memberId)
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
            let emptyResponse = CalendarResponse(
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
