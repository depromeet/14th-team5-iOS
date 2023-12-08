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
    private lazy var scoreView: UIView = UIView().then {
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = AttributeValue.scoreViewCornerRadius
        $0.backgroundColor = UIColor.systemGray
        
        $0.addSubview(scoreInfoStackView)
    }
    
    private lazy var scoreInfoStackView: UIStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = AttributeValue.scoreInfoStackSpacing
        $0.alignment = .fill
        $0.distribution = .fillEqually
        
        $0.addArrangedSubview(allParticipatedDayCountView)
        $0.addArrangedSubview(totalPhotosCountView)
        $0.addArrangedSubview(myPhotosCountView)
        
    }
    
    private lazy var allParticipatedDayCountView: UIView = UIView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = AttributeValue.scoreInfoViewCornerRadius
        $0.backgroundColor = UIColor.secondarySystemBackground
        $0.addSubview(allParticiatedDayCountStackView)
    }
    
    private lazy var allParticiatedDayCountStackView: UIStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 0.0
        $0.alignment = .fill
        $0.distribution = .fillProportionally
        
        $0.addArrangedSubview(allParticipatedDayCountNum)
        $0.addArrangedSubview(allParticipatedDayCountLabel)
    }
    
    private let allParticipatedDayCountNum: UILabel = UILabel().then {
        $0.text = "12"
        $0.textColor = UIColor.black
        $0.font = UIFont.boldSystemFont(ofSize: AttributeValue.countFontSize)
        $0.textAlignment = .center
    }
    
    private let allParticipatedDayCountLabel: UILabel = UILabel().then {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3

        let attrString = NSMutableAttributedString(string: Strings.allParticipatedDayCountText)
        attrString.addAttribute(.paragraphStyle, value:paragraphStyle, range: NSMakeRange(0, attrString.length))
    
        $0.attributedText = attrString
        $0.textColor = UIColor.secondaryLabel
        $0.textAlignment = .center
        $0.font = UIFont.boldSystemFont(ofSize: AttributeValue.infoLabelFontSize)
        $0.numberOfLines = 0
    }
    
    private lazy var totalPhotosCountView: UIView = UIView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = AttributeValue.scoreInfoViewCornerRadius
        $0.backgroundColor = UIColor.secondarySystemBackground
        $0.addSubview(totalPhotosCountStackView)
    }
    
    private lazy var totalPhotosCountStackView: UIStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 0.0
        $0.alignment = .fill
        $0.distribution = .fillProportionally
        
        $0.addArrangedSubview(totalPhotosCountNum)
        $0.addArrangedSubview(totalPhotosCountLabel)
    }
    
    private let totalPhotosCountNum: UILabel = UILabel().then {
        $0.text = "124"
        $0.textColor = UIColor.black
        $0.font = UIFont.boldSystemFont(ofSize: AttributeValue.countFontSize)
        $0.textAlignment = .center
    }
    
    private let totalPhotosCountLabel: UILabel = UILabel().then {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3

        let attrString = NSMutableAttributedString(string: Strings.totalPhotosCountText)
        attrString.addAttribute(.paragraphStyle, value:paragraphStyle, range: NSMakeRange(0, attrString.length))

        $0.attributedText = attrString
        $0.textColor = UIColor.secondaryLabel
        $0.textAlignment = .center
        $0.font = UIFont.boldSystemFont(ofSize: AttributeValue.infoLabelFontSize)
        $0.numberOfLines = 0
    }
    
    private lazy var myPhotosCountView: UIView = UIView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = AttributeValue.scoreInfoViewCornerRadius
        $0.backgroundColor = UIColor.secondarySystemBackground
        $0.addSubview(myPhotosCountStackView)
    }
    
    private lazy var myPhotosCountStackView: UIStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 0.0
        $0.alignment = .fill
        $0.distribution = .fillProportionally
        
        $0.addArrangedSubview(myPhotosCountNum)
        $0.addArrangedSubview(myPhotosCountLabel)
    }
    
    private let myPhotosCountNum: UILabel = UILabel().then {
        $0.text = "38"
        $0.textColor = UIColor.black
        $0.font = UIFont.boldSystemFont(ofSize: AttributeValue.countFontSize)
        $0.textAlignment = .center
    }
    
    private let myPhotosCountLabel: UILabel = UILabel().then {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3

        let attrString = NSMutableAttributedString(string: Strings.myPhotosCountText)
        attrString.addAttribute(.paragraphStyle, value:paragraphStyle, range: NSMakeRange(0, attrString.length))
        
        $0.attributedText = attrString
        $0.textColor = UIColor.secondaryLabel
        $0.textAlignment = .center
        $0.font = UIFont.boldSystemFont(ofSize: AttributeValue.infoLabelFontSize)
        $0.numberOfLines = 0
    }
    
    private let calendarTitleLabel: UILabel = UILabel().then {
        $0.text = Strings.calendarName
        $0.textColor = UIColor.white
        $0.font = UIFont.boldSystemFont(ofSize: AttributeValue.calendarTitleFontSize)
        $0.backgroundColor = UIColor.black
    }
    
    private lazy var infoButton: UIButton = UIButton(type: .system).then {
        let sizeConfig = UIImage.SymbolConfiguration(pointSize: 14, weight: .bold)
        let colorConfig = UIImage.SymbolConfiguration(hierarchicalColor: UIColor.white)

        let image: UIImage? = UIImage(
            systemName: SFSymbol.exclamationMark,
            withConfiguration: sizeConfig.applying(colorConfig)
        )
        $0.setImage(image, for: .normal)
    }
    
    private lazy var titleStackView: UIStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 10.0
        $0.alignment = .fill
        $0.distribution = .fill
        
        $0.addArrangedSubview(calendarTitleLabel)
        $0.addArrangedSubview(infoButton)
    }
    
    private let calendarView: FSCalendar = FSCalendar().then {
        $0.rowHeight = 50.0
        $0.headerHeight = 0.0
        $0.weekdayHeight = 40.0
        
        $0.today = nil
        $0.scrollEnabled = false
        $0.placeholderType = .fillSixRows
        $0.adjustsBoundingRectWhenChangingMonths = true
        
        $0.appearance.selectionColor = UIColor.clear
        
        $0.appearance.titleFont = UIFont.boldSystemFont(ofSize: AttributeValue.dayFontSize)
        $0.appearance.titleDefaultColor = UIColor.white
        $0.appearance.titleSelectionColor = UIColor.white
        
        $0.appearance.weekdayFont = UIFont.systemFont(ofSize: AttributeValue.weekdayFontSize)
        $0.appearance.weekdayTextColor = UIColor.white
        $0.appearance.caseOptions = .weekdayUsesSingleUpperCase
        
        $0.appearance.titlePlaceholderColor = UIColor.systemGray.withAlphaComponent(0.3)
        
        $0.backgroundColor = UIColor.black
        
        $0.locale = Locale.autoupdatingCurrent
        $0.register(ImageMonthCalendarCell.self, forCellReuseIdentifier: ImageMonthCalendarCell.identifier)
        $0.register(PlaceholderCalendarCell.self, forCellReuseIdentifier: PlaceholderCalendarCell.identifier)
    }
    
    // MARK: - Properties
    weak var delegate: CalendarViewDelegate?
    
    static var identifier: String = "CalendarPageCell"
    
    // MARK: - Constants
    private enum Strings {
        static let calendarName: String = "추억 캘린더"
        static let allParticipatedDayCountText: String = "모두\n참여한 날"
        static let totalPhotosCountText: String = "전체\n사진 수"
        static let myPhotosCountText: String = "나의\n사진 수"
        
    }
    
    private enum AttributeValue {
        static let scoreViewCornerRadius: CGFloat = 24.0
        static let scoreInfoStackSpacing: CGFloat = 8.0
        static let scoreInfoViewCornerRadius: CGFloat = 18.0
        static let countFontSize: CGFloat = 20.0
        static let infoLabelFontSize: CGFloat = 14.0
        static let calendarTitleFontSize: CGFloat = 20.0
        static let dayFontSize: CGFloat = 20.0
        static let weekdayFontSize: CGFloat = 16.0
    }
    
    private enum AutoLayout {
        static let defaultOffsetValue: CGFloat = 16.0
        static let scoreViewBottomOffsetValue: CGFloat = 36.0
        static let infoStackHeightMultiplier: CGFloat = 0.75
        static let calendarHeightMultiplier: CGFloat = 0.9
    }
    
    private enum SFSymbol {
        static let exclamationMark: String = "exclamationmark.circle"
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
        contentView.addSubview(titleStackView)
        contentView.addSubview(calendarView)
    }
    
    override func setupAutoLayout() { 
        super.setupAutoLayout()
        scoreView.snp.makeConstraints {
            $0.leading.equalTo(contentView.snp.leading).offset(AutoLayout.defaultOffsetValue)
            $0.top.equalTo(contentView.snp.top).offset(AutoLayout.defaultOffsetValue)
            $0.trailing.equalTo(contentView.snp.trailing).offset(-AutoLayout.defaultOffsetValue)
            $0.bottom.equalTo(titleStackView.snp.top).offset(-AutoLayout.scoreViewBottomOffsetValue)
        }
        
        scoreInfoStackView.snp.makeConstraints {
            $0.leading.equalTo(scoreView.snp.leading).offset(AutoLayout.defaultOffsetValue)
            $0.trailing.equalTo(scoreView.snp.trailing).offset(-AutoLayout.defaultOffsetValue)
            $0.bottom.equalTo(scoreView.snp.bottom).offset(-AutoLayout.defaultOffsetValue)
            $0.height.equalTo(allParticipatedDayCountView.snp.width)
        }
        
        allParticiatedDayCountStackView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(AutoLayout.infoStackHeightMultiplier)
            $0.center.equalTo(allParticipatedDayCountView.snp.center)
        }
        
        totalPhotosCountStackView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(AutoLayout.infoStackHeightMultiplier)
            $0.center.equalTo(totalPhotosCountView.snp.center)
        }
        
        myPhotosCountStackView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(AutoLayout.infoStackHeightMultiplier)
            $0.center.equalTo(myPhotosCountView.snp.center)
        }
        
        titleStackView.snp.makeConstraints {
            $0.leading.equalTo(scoreView)
            $0.bottom.equalTo(calendarView.snp.top).offset(-AutoLayout.defaultOffsetValue)
        }
        
        calendarView.snp.makeConstraints {
            $0.leading.equalTo(contentView.snp.leading).offset(AutoLayout.defaultOffsetValue)
            $0.bottom.equalTo(contentView.snp.bottom)
            $0.trailing.equalTo(contentView.snp.trailing).offset(-AutoLayout.defaultOffsetValue)
            $0.height.equalTo(contentView.snp.width).multipliedBy(AutoLayout.calendarHeightMultiplier)
        }
    }
    
    override func setupAttributes() { 
        super.setupAttributes()
        calendarView.delegate = self
        calendarView.dataSource = self
    }
    
    override func bind(reactor: CalendarPageCellReactor) { 
        super.bind(reactor: reactor)
        
        // Action
        infoButton.rx.tap
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .subscribe {
                $0.0.delegate?.presentPopoverView(sourceView: $0.0.infoButton)
            }
            .disposed(by: disposeBag)
    }
}

extension CalendarPageCell: FSCalendarDelegate { 
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        delegate?.goToCalendarFeedView(date)
    }
    
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
                withIdentifier: ImageMonthCalendarCell.identifier,
                for: date,
                at: position
            ) as! ImageMonthCalendarCell
            
            // Dummy Data
            let imageUrls = [
                "https://cdn.pixabay.com/photo/2023/11/20/13/48/butterfly-8401173_1280.jpg",
                "https://cdn.pixabay.com/photo/2023/11/10/02/30/woman-8378634_1280.jpg",
                "https://cdn.pixabay.com/photo/2023/11/26/08/27/leaves-8413064_1280.jpg",
                "https://cdn.pixabay.com/photo/2023/09/03/17/00/chives-8231068_1280.jpg",
                "https://cdn.pixabay.com/photo/2023/09/25/13/42/kingfisher-8275049_1280.png",
                "", "", "", ""
            ]
            cell.configure(date, imageUrl: imageUrls.randomElement() ?? "")
            
            return cell
        // 셀의 날짜가 현재 월(月)과 동일하지 않다면
        } else {
            let cell = calendar.dequeueReusableCell(
                withIdentifier: PlaceholderCalendarCell.identifier,
                for: date,
                at: position
            ) as! PlaceholderCalendarCell
            return cell
        }
    }
}
