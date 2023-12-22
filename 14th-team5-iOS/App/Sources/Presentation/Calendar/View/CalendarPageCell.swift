//
//  CalendarPageViewCell.swift
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
import SnapKit
import Then

final class CalendarPageCell: BaseCollectionViewCell<CalendarPageCellReactor> {
    // MARK: - Views
    private let calendarTitleLabel: UILabel = UILabel()
    
    private lazy var infoButton: UIButton = UIButton(type: .system)
    private lazy var titleStackView: UIStackView = UIStackView()
    
    private let calendarView: FSCalendar = FSCalendar()
    
    // MARK: - Properties
    static var id: String = "CalendarPageCell"
    
    // MARK: - Intializer
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    override func setupUI() { 
        super.setupUI()
        contentView.addSubviews(
            titleStackView, calendarView
        )
        titleStackView.addArrangedSubviews(
            calendarTitleLabel, infoButton
        )
    }
    
    override func setupAutoLayout() { 
        super.setupAutoLayout()
        titleStackView.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top).offset(CalendarCell.AutoLayout.defaultOffsetValue)
            $0.leading.equalTo(contentView.snp.leading).offset(CalendarCell.AutoLayout.calendarTopOffsetValue)
        }
        
        calendarView.snp.makeConstraints {
            $0.leading.equalTo(contentView.snp.leading).offset(CalendarCell.AutoLayout.calendarLeadingTrailingOffsetValue)
            $0.top.equalTo(titleStackView.snp.bottom).offset(CalendarCell.AutoLayout.calendarTopOffsetValue)
            $0.trailing.equalTo(contentView.snp.trailing).offset(-CalendarCell.AutoLayout.calendarLeadingTrailingOffsetValue)
            $0.height.equalTo(contentView.snp.width).multipliedBy(CalendarCell.AutoLayout.calendarHeightMultiplier)
        }
    }
    
    override func setupAttributes() { 
        super.setupAttributes()
        calendarTitleLabel.do {
            $0.text = DateFormatter.yyyyMM.string(from: reactor?.monthInfo.month ?? Date())
            $0.textColor = UIColor.white
            $0.textAlignment = .center
            $0.font = UIFont.boldSystemFont(ofSize: CalendarCell.Attribute.calendarTitleFontSize)
            $0.numberOfLines = 0
        }
        
        infoButton.do {
            let sizeConfig = UIImage.SymbolConfiguration(pointSize: 14, weight: .bold)
            let colorConfig = UIImage.SymbolConfiguration(hierarchicalColor: UIColor.white)
            
            let image: UIImage? = UIImage(
                systemName: CalendarCell.SFSymbol.exclamationMark,
                withConfiguration: sizeConfig.applying(colorConfig)
            )
            $0.setImage(image, for: .normal)
        }
        
        titleStackView.do {
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
            
            $0.appearance.titleFont = UIFont.boldSystemFont(ofSize: CalendarCell.Attribute.dayFontSize)
            $0.appearance.titleDefaultColor = UIColor.white
            $0.appearance.titleSelectionColor = UIColor.white
            
            $0.appearance.weekdayFont = UIFont.systemFont(ofSize: CalendarCell.Attribute.weekdayFontSize)
            $0.appearance.weekdayTextColor = UIColor.white
            $0.appearance.caseOptions = .weekdayUsesSingleUpperCase
            
            $0.appearance.titlePlaceholderColor = UIColor.systemGray.withAlphaComponent(0.3)
            
            $0.backgroundColor = UIColor.clear
            
            $0.locale = Locale.autoupdatingCurrent
            $0.register(ImageCalendarCell.self, forCellReuseIdentifier: ImageCalendarCell.id)
            $0.register(PlaceholderCalendarCell.self, forCellReuseIdentifier: PlaceholderCalendarCell.id)
            
            $0.delegate = self
            $0.dataSource = self
        }
        
        setupCalendarTitle(calendarView.currentPage)
    }
    
    override func bind(reactor: CalendarPageCellReactor) { 
        super.bind(reactor: reactor)
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    private func bindInput(reactor: CalendarPageCellReactor) {
        infoButton.rx.tap
            .throttle(RxConst.throttleInterval, scheduler: MainScheduler.instance)
            .withUnretained(self)
            .map { Reactor.Action.didTapInfoButton($0.0.infoButton) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        calendarView.rx.didSelect
            .map { Reactor.Action.didSelectCell($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: CalendarPageCellReactor) { 
        reactor.state.map { $0.date }
            .distinctUntilChanged()
            .bind(to: calendarView.rx.currentPage)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.date }
            .distinctUntilChanged()
            .bind(to: calendarTitleLabel.rx.calendarTitle)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.date }
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe {
                $0.0.setupCalendarTitle($0.1)
            }
            .disposed(by: disposeBag)
    }
}

extension CalendarPageCell {
    func setupCalendarTitle(_ date: Date) {
        calendarTitleLabel.text = DateFormatter.yyyyMM.string(from: date)
    }
}

extension CalendarPageCell: FSCalendarDelegate {     
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        let dateMonth = date.month
        let currentMonth = calendar.currentPage.month
        
        if let calendarCell = calendar.cell(for: date, at: monthPosition) as? ImageCalendarCell {
            // 셀의 날짜가 현재 월(月)과 동일하고, 썸네일 이미지가 있다면
            if dateMonth == currentMonth && calendarCell.hasThumbnailImage {
                return true
            }
        }
        
        return false
    }
}

extension CalendarPageCell: FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let calendarMonth = calendar.currentPage.month
        let positionMonth = date.month
        // 셀의 날짜가 현재 월(月)과 동일하다면
        if calendarMonth == positionMonth {
            let cell = calendar.dequeueReusableCell(
                withIdentifier: ImageCalendarCell.id,
                for: date,
                at: position
            ) as! ImageCalendarCell
            
            // 해당 일자에 데이터가 존재하지 않는다면
            guard let dayInfo = reactor?.monthInfo.imagePostDays.filter({ $0.date == date }).first else {
                let emptyInfo = PerDayInfo(date: date)
                cell.reactor = ImageCalendarCellReactor(date, perDayInfo: emptyInfo)
                return cell
            }
            
            cell.reactor = ImageCalendarCellReactor(date, perDayInfo: dayInfo)
            return cell
        // 셀의 날짜가 현재 월(月)과 동일하지 않다면
        } else {
            let cell = calendar.dequeueReusableCell(
                withIdentifier: PlaceholderCalendarCell.id,
                for: date,
                at: position
            ) as! PlaceholderCalendarCell
            return cell
        }
    }
}
