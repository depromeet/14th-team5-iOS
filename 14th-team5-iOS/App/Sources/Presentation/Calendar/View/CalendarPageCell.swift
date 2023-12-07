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
    private let scoreView: UIView = UIView().then {
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 20.0
        $0.backgroundColor = UIColor.systemGray6
    }
    
    private let calendarView: FSCalendar = FSCalendar().then {
        $0.rowHeight = 50.0
        $0.headerHeight = 0.0
        $0.weekdayHeight = 40.0
        
        $0.today = nil
        $0.scrollEnabled = false
        $0.placeholderType = .fillSixRows
        
        $0.appearance.selectionColor = UIColor.clear
        
        $0.appearance.titleFont = UIFont.boldSystemFont(ofSize: 20)
        $0.appearance.titleDefaultColor = UIColor.white
        $0.appearance.titleSelectionColor = UIColor.white
        
        $0.appearance.weekdayFont = UIFont.systemFont(ofSize: 16)
        $0.appearance.weekdayTextColor = UIColor.white
        $0.appearance.caseOptions = .weekdayUsesSingleUpperCase
        
        $0.appearance.titlePlaceholderColor = UIColor.systemGray5
        
        $0.backgroundColor = UIColor.black
        
        $0.locale = Locale.autoupdatingCurrent
    }
    
    // MARK: - Properties
    static var identifier: String = "CalendarPageViewCell"
    
    // MARK: - Constants
    private enum AutoLayout {
        static let defaultOffsetValue: CGFloat = 0.0
    }
    
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
        contentView.addSubview(scoreView)
        contentView.addSubview(calendarView)
    }
    
    override func setupAutoLayout() { 
        super.setupAutoLayout()
        scoreView.snp.makeConstraints {
            $0.leading.equalTo(contentView.snp.leading).offset(16.0)
            $0.top.equalTo(contentView.snp.top).offset(4.0)
            $0.trailing.equalTo(contentView.snp.trailing).offset(-16.0)
            $0.bottom.equalTo(calendarView.snp.top).offset(-50.0)
        }
        
        calendarView.snp.makeConstraints {
            $0.leading.equalTo(contentView.snp.leading).offset(16.0)
            $0.bottom.equalTo(contentView.snp.bottom)
            $0.trailing.equalTo(contentView.snp.trailing).offset(-16.0)
            $0.height.equalTo(contentView.snp.width).multipliedBy(0.95)
        }
    }
    
    override func setupAttributes() { 
        super.setupAttributes()
        calendarView.delegate = self
        calendarView.dataSource = self
    }
    
    override func bind(reactor: CalendarPageCellReactor) { }
}

extension CalendarPageCell: FSCalendarDelegate { 
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return true
    }
}

extension CalendarPageCell: FSCalendarDataSource { 
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        <#code#>
    }
}
