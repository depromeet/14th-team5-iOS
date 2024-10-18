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

public final class DailyCalendarViewController: BBNavigationViewController<DailyCalendarViewReactor> {
    
    // MARK: - Typealias
    
    typealias RxDataSource = RxCollectionViewSectionedReloadDataSource<DailyCalendarSectionModel>
    
    
    // MARK: - Views
    
    private let backgroundImage: UIImageView = UIImageView()
    private let calendarView: FSCalendar = FSCalendar()
    private lazy var collectionView: UICollectionView = UICollectionView(frame: .zero,collectionViewLayout: compositionalLayout)
    
    private lazy var reactionViewController: ReactionViewController = makeReactionViewController()
    
    
    // MARK: - Properties
    
    private lazy var dataSource = prepareDatasource()
    
    private let deepLinkRepo = DeepLinkRepository() // 삭제하기
    
    
    // MARK: - Lifecycles
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        App.Repository.deepLink.notification.accept(nil) // 삭제하기
    }

    // MARK: - Helpers
    public override func bind(reactor: DailyCalendarViewReactor) {
        super.bind(reactor: reactor)
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    private func bindInput(reactor: DailyCalendarViewReactor) {
        Observable.just(())
            .map { Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        calendarView.rx.didSelect
            .distinctUntilChanged()
            .throttle(RxInterval._300milliseconds, scheduler: RxScheduler.main)
            .map { Reactor.Action.didSelect(date: $0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        let currentPageDidChange = calendarView.rx.calendarCurrentPageDidChange
            .asDriver(onErrorJustReturn: .now)
        
        currentPageDidChange
            .distinctUntilChanged()
            .map { Reactor.Action.fetchMonthlyCalendar(date: $0) }
            .drive(reactor.action)
            .disposed(by: disposeBag)
        
        currentPageDidChange
            .distinctUntilChanged()
            .drive(with: self, onNext: { $0.setNavigationTitle($1) })
            .disposed(by: disposeBag)
        
        calendarView.rx.boundingRectWillChange
            .distinctUntilChanged()
            .bind(with: self) { $0.updateCalendarViewConstraints($1) }
            .disposed(by: disposeBag)
        
        navigationBar.rx.didTapLeftBarButton
            .map { _ in Reactor.Action.backToMonthly }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: DailyCalendarViewReactor) {
        reactor.state.map { $0.initialSelection }
            .distinctUntilChanged()
            .bind(with: self) { $0.calendarView.select($1, scrollToDate: true) }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$monthlyCalendars)
            .bind(with: self) { owner, _ in owner.calendarView.reloadData() }
            .disposed(by: disposeBag)

        let dailyPosts = reactor.pulse(\.$dailyPostsDataSource)
            .asDriver(onErrorJustReturn: [])
        
        dailyPosts
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        dailyPosts
            .drive(with: self, onNext: { owner, _ in owner.scrollCollectionView() })
            .disposed(by: disposeBag)
        
        reactor.state.compactMap { $0.visiblePost }
            .compactMap { URL(string: $0.postImageUrl) }
            .distinctUntilChanged()
            .bind(to: backgroundImage.rx.kfImage)
            .disposed(by: disposeBag)
        
        reactor.state.compactMap { $0.visiblePost }
            .distinctUntilChanged()
            .bind(with: self) {
                $0.reactionViewController.postListData.accept(
                    PostEntity(
                        postId: $1.postId,
                        author: .init(memberId: $1.authorId, name: ""),
                        commentCount: $1.commentCount,
                        emojiCount: $1.emojiCount,
                        imageURL: $1.postImageUrl,
                        content: $1.postContent,
                        time: $1.createdAt.toFormatString(with: .dashYyyyMMdd)
                    )
                )
            }
            .disposed(by: disposeBag)
        
        NotificationCenter.default
            .rx.notification(.didTapSelectableCameraButton)
            .bind(with: self) { owner, _ in owner.pushCameraViewController(cameraType: .realEmoji)}
            .disposed(by: disposeBag)
    }
    
    public override func setupUI() {
        super.setupUI()
        view.addSubviews(backgroundImage)
        backgroundImage.addSubviews(calendarView, collectionView)
        
        addChild(reactionViewController)
        backgroundImage.addSubview(reactionViewController.view)
        reactionViewController.didMove(toParent: self)
    }
    
    public override func setupAutoLayout() {
        super.setupAutoLayout()
        backgroundImage.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        calendarView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(350)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(calendarView.snp.bottom).offset(16)
            $0.height.equalTo(collectionView.snp.width).multipliedBy(1.15)
            $0.horizontalEdges.equalToSuperview()
        }
        
        reactionViewController.view.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        bringNavigationBarViewToFront()
    }
    
    public override func setupAttributes() {
        super.setupAttributes()
        
        enableAutoPopViewController = false
        navigationBar.leftBarButtonItem = .arrowLeft
        
        backgroundImage.do {
            $0.clipsToBounds = true
            $0.contentMode = .scaleAspectFill
            $0.isUserInteractionEnabled = true
            $0.setBlurEffect(style: .systemThinMaterialDark)
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
        
        collectionView.do {
            $0.isScrollEnabled = false
            $0.backgroundColor = UIColor.clear
            $0.register(MemoriesCalendarPostCell.self, forCellWithReuseIdentifier: MemoriesCalendarPostCell.id)
        }
        
        setNavigationTitle(calendarView.currentPage)
    }
}

// MARK: - Extensions

extension DailyCalendarViewController {
    
    private var compositionalLayout: UICollectionViewCompositionalLayout {
        let itemSize: NSCollectionLayoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let item: NSCollectionLayoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize: NSCollectionLayoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let group: NSCollectionLayoutGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 1
        )
        
        let section: NSCollectionLayoutSection = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.visibleItemsInvalidationHandler = { [unowned self] visibleItems, offset, environment in
            let position: CGFloat =  offset.x / collectionView.frame.width
            let floorPosition: CGFloat = floor(position)
            let fractionPart: CGFloat = position - floorPosition
            
            if fractionPart <= 0.0 {
                let index: Int = Int(floorPosition)
                reactor?.action.onNext(.updateVisiblePost(index: index))
            }
        }
        
        let layout: UICollectionViewCompositionalLayout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
}

extension DailyCalendarViewController {
    
    private func setNavigationTitle(_ date: Date) {
        navigationBar.navigationTitle = date.toFormatString(with: .yyyyM)
    }
    
    private func updateCalendarViewConstraints(_ bounds: CGRect) {
        calendarView.snp.updateConstraints {
            $0.height.equalTo(bounds.height)
        }
        view.layoutIfNeeded()
    }
    
    // 다시 리팩토링하기
    private func scrollCollectionView() {
        guard
            let datasource = reactor?.currentState.dailyPostsDataSource.first,
            let index = datasource.items.firstIndex(where: {
                $0.postId == reactor?.currentState.visiblePost?.postId
        }) else { return }
        var indexPath = IndexPath(item: index, section: 0)
        
        // 삭제하기
        if let deepLink = reactor?.currentState.notificationDeepLink {
            let postId = deepLink.postId
            guard let index = datasource.items.firstIndex(where: { post in
                      post.postId == postId
                  }) else { return }
            indexPath = IndexPath(item: index, section: 0)
        }
        
        collectionView.scroll(to: indexPath)
    }
    
    private func prepareDatasource() -> RxDataSource {
        return RxDataSource { datasource, collectionView, indexPath, post in
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MemoriesCalendarPostCell.id,
                for: indexPath
            ) as! MemoriesCalendarPostCell
            cell.reactor = MemoriesCalendarPostCellReactor(postEntity: post)
            return cell
        }
    }
    
    @available(*, deprecated, message: "삭제하기")
    private func pushCameraViewController(cameraType type: UploadLocation) {
        let vc = CameraViewControllerWrapper(cameraType: type).viewController
        navigationController?.pushViewController(vc, animated: true)
    }

}

extension DailyCalendarViewController {
    
    private func makeReactionViewController() -> ReactionViewController {
        return ReactionViewControllerWrapper(type: .calendar, postListData: .empty).makeViewController()
    }
    
    
}

extension DailyCalendarViewController: FSCalendarDataSource {
    
    public func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(
            withIdentifier: MemoriesCalendarCell.id,
            for: date,
            at: position
        ) as! MemoriesCalendarCell
        
        let yearMonth = date.toFormatString(with: .dashYyyyMM)
        guard let currentState = reactor?.currentState,
              let entity = currentState.monthlyCalendars[yearMonth]?.first(where: { $0.date.isEqual(with: date) })
        else {
            let entity = MonthlyCalendarEntity(
                date: date,
                representativePostId: .none,
                representativeThumbnailUrl: .none,
                allFamilyMemebersUploaded: false
            )
            cell.reactor = MemoriesCalendarCellReactor(of: .daily, with: entity)
            return cell
        }
        
        cell.reactor = MemoriesCalendarCellReactor(of: .daily, with: entity, isSelected: currentState.initialSelection.isEqual(with: date))
        return cell
    }
    
}
