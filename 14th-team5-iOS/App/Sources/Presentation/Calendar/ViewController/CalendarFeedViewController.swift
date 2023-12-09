//
//  CalendarFeedViewController.swift
//  App
//
//  Created by 김건우 on 12/8/23.
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

final class CalendarFeedViewController: BaseViewController<CalendarFeedViewReactor> {
    // MARK: - Views
    private lazy var calendarView: FSCalendar = FSCalendar()
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Helpers
    override func setupUI() { 
        super.setupUI()
        view.addSubview(calendarView)
    }
    
    override func setupAutoLayout() { 
        super.setupAutoLayout()
        calendarView.snp.makeConstraints {
            $0.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(CalendarVC.AutoLayout.calendarHeightValue)
        }
    }
    
    override func setupAttributes() { 
        super.setupAttributes()
        calendarView.delegate = self
        calendarView.dataSource = self
    
        calendarView.do {
            $0.headerHeight = 0.0
            $0.weekdayHeight = 30.0
            
            $0.today = nil
            $0.scope = .week
            $0.allowsMultipleSelection = false
            
            $0.appearance.selectionColor = UIColor.clear
            
            $0.appearance.titleFont = UIFont.boldSystemFont(ofSize: CalendarVC.Attribute.calendarTitleFontSize)
            $0.appearance.titleDefaultColor = UIColor.white
            $0.appearance.titleSelectionColor = UIColor.white
            
            $0.appearance.weekdayFont = UIFont.systemFont(ofSize: CalendarVC.Attribute.weekdayFontSize)
            $0.appearance.weekdayTextColor = UIColor.white
            $0.appearance.caseOptions = .weekdayUsesSingleUpperCase
            
            $0.appearance.titlePlaceholderColor = UIColor.systemGray.withAlphaComponent(0.3)
            
            $0.backgroundColor = UIColor.black
            
            $0.locale = Locale.autoupdatingCurrent
            $0.register(ImageCalendarCell.self, forCellReuseIdentifier: ImageCalendarCell.id)
            $0.register(PlaceholderCalendarCell.self, forCellReuseIdentifier: PlaceholderCalendarCell.id)
        }
    }

    override func bind(reactor: CalendarFeedViewReactor) { }
}

extension CalendarFeedViewController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendar.snp.updateConstraints {
            $0.height.equalTo(bounds.height)
        }
        view.layoutIfNeeded()
    }
}

extension CalendarFeedViewController: FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(
            withIdentifier: ImageCalendarCell.id,
            for: date,
            at: position
        ) as! ImageCalendarCell
        
        // NOTE: - 더미 데이터
        let imageUrls = [
            "https://cdn.pixabay.com/photo/2023/11/20/13/48/butterfly-8401173_1280.jpg",
            "https://cdn.pixabay.com/photo/2023/11/10/02/30/woman-8378634_1280.jpg",
            "https://cdn.pixabay.com/photo/2023/11/26/08/27/leaves-8413064_1280.jpg",
            "https://cdn.pixabay.com/photo/2023/09/03/17/00/chives-8231068_1280.jpg",
            "https://cdn.pixabay.com/photo/2023/09/25/13/42/kingfisher-8275049_1280.png",
            "", "", "", ""
        ]
        cell.configure(date, imageUrl: imageUrls.randomElement() ?? "", cellType: .week)
        
        return cell
    }
}
