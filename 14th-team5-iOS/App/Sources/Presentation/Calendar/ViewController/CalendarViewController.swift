//
//  CalendarViewController.swift
//  App
//
//  Created by 김건우 on 12/6/23.
//

import Core
import UIKit

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
    
    // MARK: - Helpers
    public override func bind(reactor: CalendarViewReactor) {
        super.bind(reactor: reactor)
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    private func bindInput(reactor: CalendarViewReactor) {
        Observable<Void>.just(())
            .delay(RxConst.smallDelayInterval, scheduler: Schedulers.main)
            .withUnretained(self)
            .subscribe {
                UIView.transition(
                    with: $0.0.calendarCollectionView,
                    duration: 0.15,
                    options: .transitionCrossDissolve
                ) { [weak self] in
                    self?.calendarCollectionView.isHidden = false
                }
            }
            .disposed(by: disposeBag)
        
        App.Repository.member.familyCreatedAt
            .withUnretained(self)
            .map {
                guard let createdAt = $0.1 else {
                    let _20230101 = Date.for20230101
                    return $0.0.createCalendarItems(from: _20230101)
                }
                return $0.0.createCalendarItems(from: createdAt)
            }
            .map { Reactor.Action.addCalendarItem($0)}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
         

        navigationBarView.rx.leftButtonTap
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
            .subscribe { $0.0.pushCalendarPostView($0.1) }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$shouldPresnetInfoPopover)
            .withUnretained(self)
            .subscribe {
                $0.0.makeDescriptionPopoverView(
                    $0.0,
                    sourceView: $0.1,
                    text: _Str.infoText,
                    popoverSize: CGSize(width: 280, height: 72),
                    permittedArrowDrections: [.up]
                )
            }
            .disposed(by: disposeBag)
    }
    
    public override func setupUI() {
        super.setupUI()
        view.addSubviews(calendarCollectionView)
    }
    
    public override func setupAutoLayout() {
        super.setupAutoLayout()
        
        calendarCollectionView.snp.makeConstraints {
            $0.top.equalTo(navigationBarView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    public override func setupAttributes() {
        super.setupAttributes()
        
        navigationBarView.do {
            $0.setNavigationView(leftItem: .arrowLeft, centerItem: .label(_Str.mainTitle), rightItem: .empty)
        }
        
        calendarCollectionView.do {
            $0.isHidden = true
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

extension CalendarViewController {
    private func createCalendarItems(from startDate: Date, to endDate: Date = Date()) -> [String] {
        var items: [String] = []
        let calendar: Calendar = Calendar.current
        
        let monthInterval: Int = monthBetween(from: startDate, to: endDate)
        
        for value in 0...monthInterval {
            if let date = calendar.date(byAdding: .month, value: value, to: startDate) {
                let yyyyMM = date.toFormatString(with: .dashYyyyMM)
                items.append(yyyyMM)
            }
        }

        return items
    }
    
    private func monthBetween(from startDate: Date, to endDate: Date) -> Int {
        let calendar: Calendar = Calendar.current
        
        let startComponents = calendar.dateComponents([.year, .month], from: startDate)
        let endComponents = calendar.dateComponents([.year, .month], from: endDate)
        
        let yearDifference = endComponents.year! - startComponents.year!
        let monthDifference = endComponents.month! - startComponents.month!
        
        let monthInterval = yearDifference * 12 + monthDifference
        return monthInterval
    }
}

extension CalendarViewController: UIPopoverPresentationControllerDelegate {
    public func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
