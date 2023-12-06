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

final class CalendarPageViewCell: BaseCollectionViewCell<CalendarPageCellReactor> {
    // MARK: - Views
    private let memoryScoreView: UIView = UIView().then {
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 10.0
        $0.backgroundColor = UIColor.systemGray6
    }
    
    private let calendarView: FSCalendar = FSCalendar().then {
        $0.scrollEnabled = false
    }
    
    // MARK: - Properties
    static var identifier: String = "CalendarPageViewCell"
    
    // MARK: - Constants
    
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
        contentView.addSubview(memoryScoreView)
        contentView.addSubview(calendarView)
    }
    
    override func setupAutoLayout() { 
        super.setupAutoLayout()
        memoryScoreView.snp.makeConstraints {
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
    }
    
    override func bind(reactor: CalendarPageCellReactor) { }
}

extension CalendarPageViewCell: FSCalendarDelegate { }

extension CalendarPageViewCell: FSCalendarDataSource { }
