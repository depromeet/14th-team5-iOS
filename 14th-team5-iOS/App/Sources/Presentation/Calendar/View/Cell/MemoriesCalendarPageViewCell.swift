//
//  CalendarPageViewCell.swift
//  App
//
//  Created by 김건우 on 12/6/23.
//

import Core
import DesignSystem
import Domain
import SwiftUI
import UIKit

import FSCalendar
import ReactorKit
import RxCocoa
import RxSwift
import SnapKit
import Then

final class MemoriesCalendarPageViewCell: BaseCollectionViewCell<MemoriesCalendarPageReactor> {
    
    // MARK: - Id
    
    static var id: String = "CalendarCell"
    
    
    // MARK: - Views
    
    private lazy var titleView = makeMemoriesCalendarTitleView()
    private lazy var bannerViewController = BannerHostingViewController(reactor: reactor)
    private let calendarView: FSCalendar = FSCalendar()
    
    
    // MARK: - Properties
    
    private let infoImage: UIImage = DesignSystemAsset.infoCircleFill.image
        .withRenderingMode(.alwaysTemplate)
    
    
    // MARK: - Helpers
    
    override func bind(reactor: MemoriesCalendarPageReactor) {
        super.bind(reactor: reactor)
        
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    private func bindInput(reactor: MemoriesCalendarPageReactor) {
        Observable.just(())
            .map { Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    
        calendarView.rx.didSelect
            .map { Reactor.Action.didSelect($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: MemoriesCalendarPageReactor) {
        
        let yearMonth = reactor.state.map { $0.yearMonth }
            .map { $0.toDate(with: .dashYyyyMM) }
            .asDriver(onErrorJustReturn: .distantPast)
        
        yearMonth
            .drive(with: self, onNext: { $0.titleView.setTitle($1.toFormatString(with: "yyyy년 M월")) })
            .disposed(by: disposeBag)
        
        yearMonth
            .drive(calendarView.rx.currentPage)
            .disposed(by: disposeBag)
        
        reactor.state.compactMap { $0.imageCount }
            .distinctUntilChanged()
            .bind(with: self) { $0.titleView.setMemoryCount($1) }
            .disposed(by: disposeBag)

        reactor.state.compactMap { $0.bannerInfo }
            .distinctUntilChanged(\.familyTopPercentage)
            .bind(with: self) { $0.bannerViewController.updateState($1) }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.calendarEntity }
            .withUnretained(self)
            .subscribe { $0.0.calendarView.reloadData() }
            .disposed(by: disposeBag)
    }
    
    override func setupUI() {
        super.setupUI()
        contentView.addSubviews(bannerViewController.view, calendarView, titleView)
    }
    
    override func setupAutoLayout() {
        super.setupAutoLayout()

        titleView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.height.equalTo(24)
        }
        
        bannerViewController.view.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom).offset(22)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(calendarView.snp.top).offset(-28)
        }
        
        calendarView.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(UIScreen.isPhoneSE ? -8 : -30)
            $0.horizontalEdges.equalToSuperview().inset(0.5)
            $0.height.equalTo(contentView.snp.width).multipliedBy(0.98)
        }
    }
    
    override func setupAttributes() {
        super.setupAttributes()

        calendarView.do {
            $0.headerHeight = 0
            $0.weekdayHeight = 40
            
            $0.today = nil
            $0.scrollEnabled = false
            $0.placeholderType = .fillSixRows
            $0.adjustsBoundingRectWhenChangingMonths = true
            
            $0.appearance.selectionColor = UIColor.clear
            $0.appearance.titleFont = UIFont.style(.body1Regular)
            $0.appearance.titleDefaultColor = UIColor.bibbiWhite
            $0.appearance.titleSelectionColor = UIColor.bibbiWhite
            $0.appearance.weekdayFont = UIFont.style(.caption)
            $0.appearance.weekdayTextColor = UIColor.gray300
            $0.appearance.caseOptions = .weekdayUsesSingleUpperCase
            $0.appearance.titlePlaceholderColor = UIColor.gray700
            
            $0.backgroundColor = UIColor.clear
            
            $0.locale = Locale(identifier: "ko_kr")
            $0.register(MemoriesCalendarCell.self, forCellReuseIdentifier: MemoriesCalendarCell.id)
            $0.register(MemoriesCalendarPlaceholderCell.self, forCellReuseIdentifier: MemoriesCalendarPlaceholderCell.id)
            
            $0.delegate = self
            $0.dataSource = self
        }

    }
}

// MARK: - Extensions

extension MemoriesCalendarPageViewCell: FSCalendarDelegate {
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        let currentMonth = date.month
        let visibleMonth = calendar.currentPage.month
        
        if let cell = calendar.cell(for: date, at: monthPosition) as? MemoriesCalendarCell {
            if visibleMonth == currentMonth && cell.hasThumbnailImage {
                return true
            }
        }
        return false
    }
    
}

extension MemoriesCalendarPageViewCell: FSCalendarDataSource {
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let currentMonth = date.month
        let visibleMonth = calendar.currentPage.month
        
        if visibleMonth == currentMonth {
            let cell = calendar.dequeueReusableCell(
                withIdentifier: MemoriesCalendarCell.id,
                for: date,
                at: position
            ) as! MemoriesCalendarCell
            
            guard
                let entity = reactor?.currentState
                    .calendarEntity?.results
                    .first(where: { $0.date == date })
            else {
                let entity = MonthlyCalendarEntity(
                    date: date,
                    representativePostId: "",
                    representativeThumbnailUrl: "",
                    allFamilyMemebersUploaded: false
                )
                cell.reactor = MemoriesCalendarCellReactor(
                    of: .month,
                    with: entity
                )
                return cell
            }
            
            cell.reactor = MemoriesCalendarCellReactor(
                of: .month,
                with: entity
            )
            return cell
            
        } else {
            let cell = calendar.dequeueReusableCell(
                withIdentifier: MemoriesCalendarPlaceholderCell.id,
                for: date,
                at: position
            ) as! MemoriesCalendarPlaceholderCell
            return cell
        }
    }
    
}

extension MemoriesCalendarPageViewCell {
    
    private func makeMemoriesCalendarTitleView() -> MemoriesCalendarPageTitleView {
        MemoriesCalendarPageTitleView(reactor: .init())
    }
    
}
