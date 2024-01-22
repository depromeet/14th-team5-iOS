//
//  CalendarViewController.swift
//  App
//
//  Created by 김건우 on 12/6/23.
//

import UIKit

import Core
import FSCalendar
import ReactorKit
import RxCocoa
import RxSwift
import RxDataSources
import SnapKit
import Then

fileprivate typealias _Str = CalendarStrings
public final class CalendarViewController: BaseViewController<CalendarViewReactor> {
    // MARK: - Views
    private let navigationBarView: BibbiNavigationBarView = BibbiNavigationBarView()
    private lazy var calendarCollectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: orthogonalCompositionalLayout
    )
    
    // MARK: - Properties
    private lazy var dataSource: RxCollectionViewSectionedReloadDataSource<SectionOfMonthlyCalendar> = prepareDatasource()
    
    // MARK: - Lifecycles
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - Helpers
    public override func bind(reactor: CalendarViewReactor) {
        super.bind(reactor: reactor)
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    private func bindInput(reactor: CalendarViewReactor) {
        let yearMonthArray: [String] = Date.for20240101.generateYearMonthStringsToToday()
        Observable<String>.from(yearMonthArray)
            .map { Reactor.Action.addYearMonthItem($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        Observable<Void>.just(())
            .map { Reactor.Action.fetchFamilyMembers }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        navigationBarView.rx.didTapLeftBarButton
            .map { _ in Reactor.Action.popViewController }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: CalendarViewReactor) {
        reactor.pulse(\.$displayCalendar)
            .bind(to: calendarCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$shouldPushCalendarPostVC).compactMap { $0 }
            .withUnretained(self)
            .subscribe {
                $0.0.pushCalendarPostView($0.1)
            }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$shouldPresnetInfoPopover)
            .withUnretained(self)
            .subscribe {
                $0.0.makeDescriptionPopoverView(
                    $0.0,
                    sourceView: $0.1,
                    text: _Str.infoText,
                    popoverSize: CGSize(width: 210, height: 70),
                    permittedArrowDrections: [.up]
                )
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.shouldPopCalendarVC }
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe {
                if $0.1 {
                    $0.0.navigationController?.popViewController(animated: true)
                }
            }
            .disposed(by: disposeBag)
    }
    
    public override func setupUI() {
        super.setupUI()
        view.addSubviews(
            navigationBarView, calendarCollectionView
        )
    }
    
    public override func setupAutoLayout() {
        super.setupAutoLayout()
        navigationBarView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(42)
        }
        
        calendarCollectionView.snp.makeConstraints {
            $0.top.equalTo(navigationBarView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    public override func setupAttributes() {
        super.setupAttributes()
        navigationBarView.do {
            $0.navigationTitle = _Str.mainTitle
            $0.leftBarButtonItem = .arrowLeft
        }
        
        calendarCollectionView.do {
            $0.isScrollEnabled = false
            $0.backgroundColor = UIColor.clear
            $0.register(CalendarPageCell.self, forCellWithReuseIdentifier: CalendarPageCell.id)
        }
        scrollToLastIndexPath()
    }
}

// MARK: - Extensions
extension CalendarViewController {
    private var orthogonalCompositionalLayout: UICollectionViewCompositionalLayout {
        // item
        let itemSize: NSCollectionLayoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item: NSCollectionLayoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // group
        let groupSize: NSCollectionLayoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let group: NSCollectionLayoutGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 1
        )
        
        // section
        let section: NSCollectionLayoutSection = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        
        // layout
        let layout: UICollectionViewCompositionalLayout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
}

extension CalendarViewController {
    private func prepareDatasource() -> RxCollectionViewSectionedReloadDataSource<SectionOfMonthlyCalendar> {
        return RxCollectionViewSectionedReloadDataSource<SectionOfMonthlyCalendar> { datasource, collectionView, indexPath, yearMonth in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarPageCell.id, for: indexPath) as! CalendarPageCell
            cell.reactor = CalendarPageCellDIContainer(yearMonth: yearMonth).makeReactor()
            return cell
        }
    }
    
    private func pushCalendarPostView(_ date: Date) {
        navigationController?.pushViewController(
            CalendarPostDIConatainer(selectedDate: date).makeViewController(),
            animated: true
        )
    }
    
    private func scrollToLastIndexPath() {
        calendarCollectionView.layoutIfNeeded()
        let indexPath: IndexPath = IndexPath(
            item: dataSource[0].items.count - 1,
            section: 0
        )
        calendarCollectionView.scrollToItem(
            at: indexPath,
            at: .centeredHorizontally,
            animated: false
        )
    }
}

extension CalendarViewController: UIPopoverPresentationControllerDelegate {
    public func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
