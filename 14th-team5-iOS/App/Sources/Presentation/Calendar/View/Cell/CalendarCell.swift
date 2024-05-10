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

final class CalendarCell: BaseCollectionViewCell<CalendarCellReactor> {
    // MARK: - Id
    static var id: String = "CalendarCell"
    
    // MARK: - Views
    private lazy var labelStack: UIStackView = UIStackView()
    private let titleLabel: BibbiLabel = BibbiLabel(.head2Bold, textAlignment: .center, textColor: .gray200)
    private let countLabel: BibbiLabel = BibbiLabel(.body1Regular, textColor: .gray200)
    private let infoButton: UIButton = UIButton(type: .system)
    
    private lazy var bannerView: BannerView = BannerView(viewModel: bannerViewModel)
    private lazy var bannerController: UIHostingController = UIHostingController(rootView: bannerView)
    
    private let calendarView: FSCalendar = FSCalendar()
    
    // MARK: - Properties
    private let infoImage: UIImage = DesignSystemAsset.infoCircleFill.image
        .withRenderingMode(.alwaysTemplate)
    private lazy var bannerViewModel: BannerViewModel = BannerViewModel(reactor: reactor, state: .init())
    
    // MARK: - Helpers
    override func bind(reactor: CalendarCellReactor) {
        super.bind(reactor: reactor)
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    private func bindInput(reactor: CalendarCellReactor) {
        Observable<Void>.just(())
            .map { Reactor.Action.requestBanner }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        Observable<Void>.just(())
            .map { Reactor.Action.requestStatistics }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        Observable<Void>.just(())
            .map { Reactor.Action.requestMonthlyCalendar }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        infoButton.rx.tap
            .throttle(RxConst.milliseconds300Interval, scheduler: MainScheduler.instance)
            .withUnretained(self)
            .map { Reactor.Action.infoButtonTapped($0.0.infoButton) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        calendarView.rx.didSelect
            .map { Reactor.Action.dateSelected($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: CalendarCellReactor) {
        reactor.state.compactMap { $0.displayBanner }
            .distinctUntilChanged(\.familyTopPercentage)
            .withUnretained(self)
            .subscribe {
                $0.0.bannerViewModel.updateState(state: $0.1)
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.displayMemoryCount }
            .distinctUntilChanged()
            .bind(to: countLabel.rx.memoryCountText)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.displayMonthlyCalendar }
            .withUnretained(self)
            .subscribe { $0.0.calendarView.reloadData() }
            .disposed(by: disposeBag)
        
        let currentDate = reactor.state.map { $0.yearMonth }
            .map { $0.toDate(with: .dashYyyyMM) }
            .asDriver(onErrorJustReturn: .now)
        
        currentDate
            .distinctUntilChanged()
            .drive(calendarView.rx.currentPage)
            .disposed(by: disposeBag)
        
        currentDate
            .distinctUntilChanged()
            .drive(titleLabel.rx.calendarTitleText)
            .disposed(by: disposeBag)
    }
    
    override func setupUI() {
        super.setupUI()
        contentView.addSubviews(
            labelStack, countLabel, bannerController.view, calendarView
        )
        labelStack.addArrangedSubviews(
            titleLabel, infoButton
        )
    }
    
    override func setupAutoLayout() {
        super.setupAutoLayout()
        labelStack.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.leading.equalToSuperview().offset(24)
        }
        
        countLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
        }
        
        bannerController.view.snp.makeConstraints {
            $0.top.equalTo(labelStack.snp.bottom).offset(22)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(calendarView.snp.top).offset(-28)
        }
        
        calendarView.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(UIScreen.isPhoneSE ? -8 : -30)
            $0.horizontalEdges.equalToSuperview().inset(0.5)
            $0.height.equalTo(contentView.snp.width).multipliedBy(0.98)
        }
        
        infoButton.snp.makeConstraints {
            $0.size.equalTo(20)
        }
    }
    
    override func setupAttributes() {
        super.setupAttributes()
        infoButton.do {
            $0.setImage(
                infoImage,
                for: .normal
            )
            $0.tintColor = .gray300
        }
        
        labelStack.do {
            $0.axis = .horizontal
            $0.spacing = 10.0
            $0.alignment = .fill
            $0.distribution = .fill
        }
        
        calendarView.do {
            $0.headerHeight = 0.0
            $0.weekdayHeight = 40.0
            
            $0.today = nil
            $0.scrollEnabled = false
            $0.placeholderType = .fillSixRows
            $0.adjustsBoundingRectWhenChangingMonths = true
            
            $0.appearance.selectionColor = UIColor.clear
            
            $0.appearance.titleFont = UIFont.pretendard(.body1Regular)
            $0.appearance.titleDefaultColor = UIColor.bibbiWhite
            $0.appearance.titleSelectionColor = UIColor.bibbiWhite
            
            $0.appearance.weekdayFont = UIFont.pretendard(.caption)
            $0.appearance.weekdayTextColor = UIColor.gray300
            $0.appearance.caseOptions = .weekdayUsesSingleUpperCase
            
            $0.appearance.titlePlaceholderColor = UIColor.gray700
            
            $0.backgroundColor = UIColor.clear
            
            $0.locale = Locale(identifier: "ko_kr")
            $0.register(CalendarImageCell.self, forCellReuseIdentifier: CalendarImageCell.id)
            $0.register(CalendarPlaceholderCell.self, forCellReuseIdentifier: CalendarPlaceholderCell.id)
            
            $0.delegate = self
            $0.dataSource = self
        }
        
        bannerController.view.do {
            $0.backgroundColor = UIColor.clear
        }
    }
}

// MARK: - Extensions
extension CalendarCell: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        let month = date.month
        let currentMonth = calendar.currentPage.month
        
        if let calendarCell = calendar.cell(for: date, at: monthPosition) as? CalendarImageCell {
            // 셀의 날짜가 현재 월(月)과 동일하고, 썸네일 이미지가 있다면
            if month == currentMonth && calendarCell.hasThumbnailImage {
                return true
            }
        }
        
        return false
    }
}

extension CalendarCell: FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let calendarMonth = calendar.currentPage.month
        let positionMonth = date.month
        // 셀의 날짜가 현재 월(月)과 동일하다면
        if calendarMonth == positionMonth {
            let cell = calendar.dequeueReusableCell(
                withIdentifier: CalendarImageCell.id,
                for: date,
                at: position
            ) as! CalendarImageCell
            
            // 해당 일자에 데이터가 존재하지 않는다면
            guard let dayResponse = reactor?.currentState.displayMonthlyCalendar?.results.filter({ $0.date == date }).first else {
                let emptyResponse = CalendarEntity(
                    date: date,
                    representativePostId: .none,
                    representativeThumbnailUrl: .none,
                    allFamilyMemebersUploaded: false
                )
                cell.reactor = CalendarImageCellDIContainer(
                    type: .month,
                    monthlyEntity: emptyResponse
                ).makeReactor()
                return cell
            }
            
            cell.reactor = CalendarImageCellDIContainer(
                type: .month,
                monthlyEntity: dayResponse
            ).makeReactor()
            return cell
        // 셀의 날짜가 현재 월(月)과 동일하지 않다면
        } else {
            let cell = calendar.dequeueReusableCell(
                withIdentifier: CalendarPlaceholderCell.id,
                for: date,
                at: position
            ) as! CalendarPlaceholderCell
            return cell
        }
    }
}
