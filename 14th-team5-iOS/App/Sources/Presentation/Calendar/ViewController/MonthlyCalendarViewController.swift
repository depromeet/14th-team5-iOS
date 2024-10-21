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

public final class MonthlyCalendarViewController: BBNavigationViewController<MonthlyCalendarViewReactor> {
    
    // MARK: - Typealias
    
    typealias RxDataSource = RxCollectionViewSectionedReloadDataSource<MonthlyCalendarSectionModel>
    
    
    // MARK: - Views
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: compositionalLayout)
    
    
    // MARK: - Properties
    
    private lazy var dataSource: RxDataSource = prepareDatasource()
    
    
    // MARK: - Helpers
    
    public override func bind(reactor: MonthlyCalendarViewReactor) {
        super.bind(reactor: reactor)
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    private func bindInput(reactor: MonthlyCalendarViewReactor) {
        Observable.just(())
            .map { Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: MonthlyCalendarViewReactor) {
        let pageDatasource = reactor.pulse(\.$pageDatasource)
            .asDriver(onErrorDriveWith: .empty())
        
        pageDatasource
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    public override func setupUI() {
        super.setupUI()
        view.addSubviews(collectionView)
    }
    
    public override func setupAutoLayout() {
        super.setupAutoLayout()
        
        collectionView.snp.makeConstraints {
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
        
        collectionView.do {
            $0.isScrollEnabled = false
            $0.backgroundColor = UIColor.clear
            $0.register(MemoriesCalendarPageViewCell.self, forCellWithReuseIdentifier: MemoriesCalendarPageViewCell.id)
        }
        
        
        collectionView.layoutIfNeeded()
        collectionView.scroll(to: IndexPath(item: reactor!.currentState.pageDatasource.first!.items.count - 1, section: 0)) // 다시 리팩토링하기
    }
}


// MARK: - Extensions

extension MonthlyCalendarViewController {
    
    private var compositionalLayout: UICollectionViewCompositionalLayout {
        let itemSize: NSCollectionLayoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item: NSCollectionLayoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize: NSCollectionLayoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let group: NSCollectionLayoutGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 1
        )
        
        let section: NSCollectionLayoutSection = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        
        let layout: UICollectionViewCompositionalLayout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
}

extension MonthlyCalendarViewController {
    
    private func prepareDatasource() -> RxDataSource {
        return RxDataSource { datasource, collectionView, indexPath, yearMonth in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MemoriesCalendarPageViewCell.id, for: indexPath) as! MemoriesCalendarPageViewCell
            cell.reactor = MemoriesCalendarPageReactor(yearMonth: yearMonth)
            return cell
        }
    }
    
}
