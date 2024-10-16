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

public final class MonthlyCalendarViewController: TempNavigationViewController<MonthlyCalendarViewReactor> {
    // MARK: - Views
    private lazy var calendarCollectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: orthogonalCompositionalLayout
    )
    
    // MARK: - Properties
    private lazy var dataSource: RxCollectionViewSectionedReloadDataSource<MonthlyCalendarSectionModel> = prepareDatasource()
    
    // MARK: - Lifecycles
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Helpers
    public override func bind(reactor: MonthlyCalendarViewReactor) {
        super.bind(reactor: reactor)
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    private func bindInput(reactor: MonthlyCalendarViewReactor) {
        Observable<Void>.just(())
            .delay(RxConst.milliseconds100Interval, scheduler: RxSchedulers.main)
            .bind(with: self) { owner, _ in
                UIView.transition(
                    with: owner.calendarCollectionView,
                    duration: 0.25,
                    options: .transitionCrossDissolve
                ) { [weak self] in
                    self?.calendarCollectionView.isHidden = false
                }
            }
            .disposed(by: disposeBag)
        
        App.Repository.member.familyCreatedAt // 캘린더 페이지를 생성하는 코드 ex) 2024년 3월 ~ 9월
            .withUnretained(self)
            .map {
                guard let createdAt = $0.1 else {
                    let _20230101 = Date._20230101
                    return $0.0.createCalendarItems(from: _20230101)
                }
                print("======= \(createdAt)")
                print("======= \($0.0.createCalendarItems(from: createdAt))")
                return $0.0.createCalendarItems(from: createdAt)
            }
            .map { Reactor.Action.addCalendarItems($0)}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
         

        navigationBar.rx.didTapLeftBarButton
            .map { _ in Reactor.Action.popViewController }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: MonthlyCalendarViewReactor) {
        reactor.pulse(\.$displayCalendar)
            .bind(to: calendarCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        reactor.state.compactMap { $0.initalCalendarPageIndexPath }
            .bind(with: self) { owner, indexPath in
                owner.scrollToLastIndexPath(indexPath)
            }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$shouldPushDailyCalendarViewController).compactMap { $0 }
            .withUnretained(self)
            .subscribe { $0.0.pushWeeklyCalendarViewController($0.1) }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$shouldPresnetInfoPopover)
            .withUnretained(self)
            .subscribe {
                $0.0.makeDescriptionPopoverView(
                    $0.0,
                    sourceView: $0.1,
                    text: "모두가 참여한 날과 업로드한 사진 수로\n이 달의 친밀도를 측정합니다",
                    popoverSize: CGSize(width: 260, height: 62),
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
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    public override func setupAttributes() {
        super.setupAttributes()
        
        navigationBar.do {
            $0.navigationTitle = "추억 캘린더"
            $0.leftBarButtonItem = .arrowLeft
            $0.rightBarButtonItem = nil
        }
        
        calendarCollectionView.do {
            $0.isHidden = true
            $0.isScrollEnabled = false
            $0.backgroundColor = UIColor.clear
            $0.register(MemoriesCalendarPageViewCell.self, forCellWithReuseIdentifier: MemoriesCalendarPageViewCell.id)
        }
    }
}

// MARK: - Extensions
extension MonthlyCalendarViewController {
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

extension MonthlyCalendarViewController {
    private func prepareDatasource() -> RxCollectionViewSectionedReloadDataSource<MonthlyCalendarSectionModel> {
        return RxCollectionViewSectionedReloadDataSource<MonthlyCalendarSectionModel> { datasource, collectionView, indexPath, yearMonth in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MemoriesCalendarPageViewCell.id, for: indexPath) as! MemoriesCalendarPageViewCell
            cell.reactor = MemoriesCalendarPageReactor(yearMonth: yearMonth)
            return cell
        }
    }
    
    private func pushWeeklyCalendarViewController(_ date: Date) {
        navigationController?.pushViewController(
            WeeklyCalendarDIConatainer(
                date: date
            ).makeViewController(),
            animated: true
        )
    }
    
    private func scrollToLastIndexPath(_ indexPath: IndexPath) {
        calendarCollectionView.layoutIfNeeded()
        
        calendarCollectionView.scrollToItem(
            at: indexPath,
            at: .centeredHorizontally,
            animated: false
        )
    }
}

extension MonthlyCalendarViewController {
    // TODO: - Item 생성 로직을 다른 곳으로 이동하기
    private func createCalendarItems(from startDate: Date, to endDate: Date = Date()) -> [String] {
        var items: [String] = []
        let calendar: Calendar = Calendar.current
        
        let monthInterval: Int = getMonthInterval(from: startDate, to: endDate)
        
        for value in 0...monthInterval {
            if let date = calendar.date(byAdding: .month, value: value, to: startDate) {
                let yyyyMM = date.toFormatString(with: .dashYyyyMM)
                items.append(yyyyMM)
            }
        }

        return items
    }
    
    private func getMonthInterval(from startDate: Date, to endDate: Date) -> Int {
        let calendar: Calendar = Calendar.current
        
        let startComponents = calendar.dateComponents([.year, .month], from: startDate)
        let endComponents = calendar.dateComponents([.year, .month], from: endDate)
        
        let yearDifference = endComponents.year! - startComponents.year!
        let monthDifference = endComponents.month! - startComponents.month!
        
        let monthInterval = yearDifference * 12 + monthDifference
        return monthInterval
    }
}

extension MonthlyCalendarViewController: UIPopoverPresentationControllerDelegate {
    public func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
