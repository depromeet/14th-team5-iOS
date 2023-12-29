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

// MARK: - ViewController
public final class CalendarViewController: BaseViewController<CalendarViewReactor> {
    // MARK: - Views
    private lazy var collectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: orthogonalCompositionalLayout
    )
    
    // MARK: - Properties
    private lazy var dataSource: RxCollectionViewSectionedReloadDataSource<SectionOfMonthlyCalendar> = prepareDatasource()
    
    // 캘린더에 표시할 월 별 날짜(2023. 1. ~ 오늘까지)
    private let yearMonthArray: [String] = Date.for20230101.generateYearMonthStringsToToday()
    
    // MARK: - Lifecycles
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: - Helpers
    public override func setupUI() {
        super.setupUI()
        view.addSubview(collectionView)
    }
    
    public override func setupAutoLayout() {
        super.setupAutoLayout()
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    public override func setupAttributes() {
        super.setupAttributes()
        collectionView.do {
            $0.isScrollEnabled = false
            $0.backgroundColor = UIColor.clear
            $0.register(CalendarPageCell.self, forCellWithReuseIdentifier: CalendarPageCell.id)
        }
        scrollToLastIndexPath()
        
        navigationItem.title = "추억 캘린더"
    }
    
    public override func bind(reactor: CalendarViewReactor) {
        super.bind(reactor: reactor)
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    private func bindInput(reactor: CalendarViewReactor) {
        Observable<String>.from(yearMonthArray)
            .map { Reactor.Action.addMonthlyCalendarItem($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: CalendarViewReactor) {
        reactor.state.map { $0.calendarDatasource }
            .distinctUntilChanged(at: \.count)
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$pushCalendarPostVC)
            .withUnretained(self)
            .subscribe {
                $0.0.pushCalendarFeedView($0.1 ?? Date())
            }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$shouldPresentCalendarDescriptionPopoverVC)
            .withUnretained(self)
            .subscribe {
                $0.0.makeDescriptionPopoverView(
                    $0.0,
                    sourceView: $0.1,
                    text: CalendarVC.Strings.descriptionText,
                    popoverSize: CGSize(
                        width: CalendarVC.Attribute.popoverWidth,
                        height: CalendarVC.Attribute.popoverHeight
                    ),
                    permittedArrowDrections: [.up]
                )
            }
            .disposed(by: disposeBag)
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
            cell.reactor = CalendarPageCellDIContainer().makeReactor(yearMonth: yearMonth)
            return cell
        }
    }
    
    private func pushCalendarFeedView(_ date: Date) {
        navigationController?.pushViewController(
            CalendarPostDIConatainer(selectedCalendarCell: date).makeViewController(),
            animated: true
        )
    }
    
    private func scrollToLastIndexPath() {
        collectionView.layoutIfNeeded()
        let lastIndexPath: IndexPath = IndexPath(
            item: dataSource[0].items.count - 1,
            section: 0
        )
        collectionView.scrollToItem(
            at: lastIndexPath,
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
