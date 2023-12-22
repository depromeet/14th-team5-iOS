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
    var dataSource: RxCollectionViewSectionedReloadDataSource<SectionOfPerMonthInfo> = RxCollectionViewSectionedReloadDataSource<SectionOfPerMonthInfo> { datasource, collectionView, indexPath, monthInfo in
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarPageCell.id, for: indexPath) as! CalendarPageCell
        cell.reactor = CalendarPageCellDIContainer().makeReactor(perMonthInfo: monthInfo)
        return cell
    }
    // 캘린더의 시작 날짜
    let startDate: Date = Date.for20230101

    
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
        Observable<String>.from(generateYearMonthStrings(from: startDate))
            .map { print($0); return Reactor.Action.refreshMonthlyCalendar($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: CalendarViewReactor) {
        reactor.state.map { $0.calendarDatasource }
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$pushCalendarFeedVC)
            .withUnretained(self)
            .subscribe {
                $0.0.pushCalendarFeedView($0.1)
            }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$shouldPresentPopoverVC)
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

extension CalendarViewController {
    var orthogonalCompositionalLayout: UICollectionViewCompositionalLayout {
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
    func scrollToLastIndexPath() {
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
    
    func pushCalendarFeedView(_ date: Date?) {
        let container = CalendarFeedDIConatainer(selectedDate: date ?? Date())
        navigationController?.pushViewController(container.makeViewController(), animated: true)
    }
    
    func generateYearMonthStrings(from startDate: Date) -> [String] {
        let calendar: Calendar = Calendar.autoupdatingCurrent
        let currentDate: Date = Date()
        
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM"
        
        var yearMonthStrings: [String] = []
        
        let monthInterval = startDate.interval([.month], to: currentDate)[.month]!
        for month in 0...monthInterval {
            if let date = calendar.date(byAdding: .month, value: month, to: startDate) {
                let yearMonthString = dateFormatter.string(from: date)
                yearMonthStrings.append(yearMonthString)
            }
        }
        
        return yearMonthStrings
    }
}

extension CalendarViewController: UIPopoverPresentationControllerDelegate {
    public func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
