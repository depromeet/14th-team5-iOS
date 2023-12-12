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
    private lazy var scoreView: UIView = UIView()
    private lazy var scoreInfoStackView: UIStackView = UIStackView()
    
    private lazy var allParticipatedDayCountView: UIView = UIView()
    private lazy var allParticiatedDayCountStackView: UIStackView = UIStackView()
    private let allParticipatedDayCountNum: UILabel = UILabel()
    private let allParticipatedDayCountLabel: UILabel = UILabel()
    
    private lazy var totalPhotosCountView: UIView = UIView()
    private lazy var totalPhotosCountStackView: UIStackView = UIStackView()
    private let totalPhotosCountNum: UILabel = UILabel()
    private let totalPhotosCountLabel: UILabel = UILabel()
    
    private lazy var myPhotosCountView: UIView = UIView()
    private lazy var myPhotosCountStackView: UIStackView = UIStackView()
    private let myPhotosCountNum: UILabel = UILabel()
    private let myPhotosCountLabel: UILabel = UILabel()
    
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
            scoreView, titleStackView, calendarView
        )
        
        scoreView.addSubview(scoreInfoStackView)
        scoreInfoStackView.addArrangedSubviews(
            allParticipatedDayCountView, totalPhotosCountView, myPhotosCountView
        )
        
        allParticipatedDayCountView.addSubview(allParticiatedDayCountStackView)
        allParticiatedDayCountStackView.addArrangedSubviews(
            allParticipatedDayCountNum, allParticipatedDayCountLabel
        )
        
        totalPhotosCountView.addSubview(totalPhotosCountStackView)
        totalPhotosCountStackView.addArrangedSubviews(
            totalPhotosCountNum, totalPhotosCountLabel
        )
        
        myPhotosCountView.addSubview(myPhotosCountStackView)
        myPhotosCountStackView.addArrangedSubviews(
            myPhotosCountNum, myPhotosCountLabel
        )
        
        titleStackView.addArrangedSubviews(
            calendarTitleLabel, infoButton
        )
    }
    
    override func setupAutoLayout() { 
        super.setupAutoLayout()
        scoreView.snp.makeConstraints {
            $0.leading.equalTo(contentView.snp.leading).offset(CalendarCell.AutoLayout.defaultOffsetValue)
            $0.top.equalTo(contentView.snp.top).offset(CalendarCell.AutoLayout.defaultOffsetValue)
            $0.trailing.equalTo(contentView.snp.trailing).offset(-CalendarCell.AutoLayout.defaultOffsetValue)
            $0.bottom.equalTo(titleStackView.snp.top).offset(-CalendarCell.AutoLayout.scoreViewBottomOffsetValue)
        }
        
        scoreInfoStackView.snp.makeConstraints {
            $0.leading.equalTo(scoreView.snp.leading).offset(CalendarCell.AutoLayout.defaultOffsetValue)
            $0.trailing.equalTo(scoreView.snp.trailing).offset(-CalendarCell.AutoLayout.defaultOffsetValue)
            $0.bottom.equalTo(scoreView.snp.bottom).offset(-CalendarCell.AutoLayout.defaultOffsetValue)
            $0.height.equalTo(allParticipatedDayCountView.snp.width)
        }
        
        allParticiatedDayCountStackView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(CalendarCell.AutoLayout.infoStackHeightMultiplier)
            $0.center.equalTo(allParticipatedDayCountView.snp.center)
        }
        
        totalPhotosCountStackView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(CalendarCell.AutoLayout.infoStackHeightMultiplier)
            $0.center.equalTo(totalPhotosCountView.snp.center)
        }
        
        myPhotosCountStackView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(CalendarCell.AutoLayout.infoStackHeightMultiplier)
            $0.center.equalTo(myPhotosCountView.snp.center)
        }
        
        titleStackView.snp.makeConstraints {
            $0.leading.equalTo(scoreView)
            $0.bottom.equalTo(calendarView.snp.top).offset(-CalendarCell.AutoLayout.defaultOffsetValue)
        }
        
        calendarView.snp.makeConstraints {
            $0.leading.equalTo(contentView.snp.leading).offset(CalendarCell.AutoLayout.defaultOffsetValue)
            $0.bottom.equalTo(contentView.snp.bottom)
            $0.trailing.equalTo(contentView.snp.trailing).offset(-CalendarCell.AutoLayout.defaultOffsetValue)
            $0.height.equalTo(contentView.snp.width).multipliedBy(CalendarCell.AutoLayout.calendarHeightMultiplier)
        }
    }
    
    override func setupAttributes() { 
        super.setupAttributes()
        calendarView.delegate = self
        calendarView.dataSource = self
        
        scoreView.do {
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = CalendarCell.Attribute.scoreViewCornerRadius
            $0.backgroundColor = UIColor.systemGray
        }
        
        scoreInfoStackView.do {
            $0.axis = .horizontal
            $0.spacing = CalendarCell.Attribute.scoreInfoStackSpacing
            $0.alignment = .fill
            $0.distribution = .fillEqually
        }
        
        allParticipatedDayCountView.do {
            $0.clipsToBounds = true
            $0.layer.cornerRadius = CalendarCell.Attribute.scoreInfoViewCornerRadius
            $0.backgroundColor = UIColor.secondarySystemBackground
        }
        
        allParticiatedDayCountStackView.do {
            $0.axis = .vertical
            $0.spacing = 0.0
            $0.alignment = .fill
            $0.distribution = .fillProportionally
        }
        
        allParticipatedDayCountNum.do {
            $0.text = "12"
            $0.textColor = UIColor.black
            $0.font = UIFont.boldSystemFont(ofSize: CalendarCell.Attribute.countFontSize)
            $0.textAlignment = .center
        }
        
        allParticipatedDayCountLabel.do {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 3
            
            let attrString = NSMutableAttributedString(string: CalendarCell.Strings.allParticipatedDayCountText)
            attrString.addAttribute(.paragraphStyle, value:paragraphStyle, range: NSMakeRange(0, attrString.length))
            
            $0.attributedText = attrString
            $0.textColor = UIColor.secondaryLabel
            $0.textAlignment = .center
            $0.font = UIFont.boldSystemFont(ofSize: CalendarCell.Attribute.infoLabelFontSize)
            $0.numberOfLines = 0
        }
        
        totalPhotosCountView.do {
            $0.clipsToBounds = true
            $0.layer.cornerRadius = CalendarCell.Attribute.scoreInfoViewCornerRadius
            $0.backgroundColor = UIColor.secondarySystemBackground
        }
        
        totalPhotosCountStackView.do {
            $0.axis = .vertical
            $0.spacing = 0.0
            $0.alignment = .fill
            $0.distribution = .fillProportionally
        }
        
        totalPhotosCountNum.do {
            $0.text = "124"
            $0.textColor = UIColor.black
            $0.font = UIFont.boldSystemFont(ofSize: CalendarCell.Attribute.countFontSize)
            $0.textAlignment = .center
        }
        
        totalPhotosCountLabel.do {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 3
            
            let attrString = NSMutableAttributedString(string: CalendarCell.Strings.totalPhotosCountText)
            attrString.addAttribute(.paragraphStyle, value:paragraphStyle, range: NSMakeRange(0, attrString.length))
            
            $0.attributedText = attrString
            $0.textColor = UIColor.secondaryLabel
            $0.textAlignment = .center
            $0.font = UIFont.boldSystemFont(ofSize: CalendarCell.Attribute.infoLabelFontSize)
            $0.numberOfLines = 0
        }
        
        myPhotosCountView.do {
            $0.clipsToBounds = true
            $0.layer.cornerRadius = CalendarCell.Attribute.scoreInfoViewCornerRadius
            $0.backgroundColor = UIColor.secondarySystemBackground
        }
        
        myPhotosCountNum.do {
            $0.text = "38"
            $0.textColor = UIColor.black
            $0.font = UIFont.boldSystemFont(ofSize: CalendarCell.Attribute.countFontSize)
            $0.textAlignment = .center
        }
        
        myPhotosCountStackView.do {
            $0.axis = .vertical
            $0.spacing = 0.0
            $0.alignment = .fill
            $0.distribution = .fillProportionally
        }
        
        myPhotosCountLabel.do {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 3
            
            let attrString = NSMutableAttributedString(string: CalendarCell.Strings.myPhotosCountText)
            attrString.addAttribute(.paragraphStyle, value:paragraphStyle, range: NSMakeRange(0, attrString.length))
            
            $0.attributedText = attrString
            $0.textColor = UIColor.secondaryLabel
            $0.textAlignment = .center
            $0.font = UIFont.boldSystemFont(ofSize: CalendarCell.Attribute.infoLabelFontSize)
            $0.numberOfLines = 0
        }
        
        calendarTitleLabel.do {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 3
            
            let attrString = NSMutableAttributedString(string: CalendarCell.Strings.calendarName)
            attrString.addAttribute(.paragraphStyle, value:paragraphStyle, range: NSMakeRange(0, attrString.length))
            
            $0.attributedText = attrString
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
            
            $0.appearance.titleFont = UIFont.boldSystemFont(ofSize: CalendarCell.Attribute.calendarTitleFontSize)
            $0.appearance.titleDefaultColor = UIColor.white
            $0.appearance.titleSelectionColor = UIColor.white
            
            $0.appearance.weekdayFont = UIFont.systemFont(ofSize: CalendarCell.Attribute.weekdayFontSize)
            $0.appearance.weekdayTextColor = UIColor.white
            $0.appearance.caseOptions = .weekdayUsesSingleUpperCase
            
            $0.appearance.titlePlaceholderColor = UIColor.systemGray.withAlphaComponent(0.3)
            
            $0.backgroundColor = UIColor.black
            
            $0.locale = Locale.autoupdatingCurrent
            $0.register(ImageCalendarCell.self, forCellReuseIdentifier: ImageCalendarCell.id)
            $0.register(PlaceholderCalendarCell.self, forCellReuseIdentifier: PlaceholderCalendarCell.id)
        }
    }
    
    override func bind(reactor: CalendarPageCellReactor) { 
        super.bind(reactor: reactor)
        
        // Action
        infoButton.rx.tap
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .map { Reactor.Action.didPressInfoButton($0.0.infoButton) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        calendarView.rx.didSelect
            .map { Reactor.Action.didSelectCell($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}

extension CalendarPageCell: FSCalendarDelegate {     
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        let calendarMonth = calendar.currentPage.month
        let positionMonth = date.month
        // 셀의 날짜가 현재 월(月)과 동일하다면
        if calendarMonth == positionMonth {
            return true
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
            
            // NOTE: - 더미 데이터
            let imageUrls = [
                "https://cdn.pixabay.com/photo/2023/11/20/13/48/butterfly-8401173_1280.jpg",
                "https://cdn.pixabay.com/photo/2023/11/10/02/30/woman-8378634_1280.jpg",
                "https://cdn.pixabay.com/photo/2023/11/26/08/27/leaves-8413064_1280.jpg",
                "https://cdn.pixabay.com/photo/2023/09/03/17/00/chives-8231068_1280.jpg",
                "https://cdn.pixabay.com/photo/2023/09/25/13/42/kingfisher-8275049_1280.png",
                "", "", "", ""
            ]
            let cellModel = TempCalendarCellModel(imageUrl: imageUrls.randomElement(), isHidden: Bool.random())
            
            cell.reactor = ImageCalendarCellReactor(cellModel)
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
