//
//  ImageCalendarCell.swift
//  App
//
//  Created by 김건우 on 12/6/23.
//

import Foundation

import Core
import FSCalendar
import Kingfisher
import ReactorKit
import RxCocoa
import RxSwift
import SnapKit
import Then

final class ImageCalendarCell: FSCalendarCell, ReactorKit.View {
    // MARK: - Enums
    enum CellType {
        case month
        case week
    }
    
    // MARK: - Views
    private let thumbnailView: UIImageView = UIImageView()
    private let badgeView: UIView = UIView()
    
    // MARK: - Properties
    var disposeBag: RxSwift.DisposeBag = DisposeBag()
    
    static let id: String = "ImageCalendarCell"
    
    // MARK: - Intializer
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
        setupAutoLayout()
        setupAttribute()
    }
    
    required init(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    func setupUI() {
        contentView.insertSubview(thumbnailView, at: 0)
        contentView.addSubview(badgeView)
    }
    
    func setupAutoLayout() {
        titleLabel.snp.makeConstraints {
            $0.center.equalTo(contentView.snp.center)
        }
        
        thumbnailView.snp.makeConstraints {
            $0.center.equalTo(contentView.snp.center)
            $0.width.height.equalTo(contentView.snp.width).inset(CalendarCell.AutoLayout.thumbnailInsetValue)
        }
        
        badgeView.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top).offset(CalendarCell.AutoLayout.badgeOffsetValue)
            $0.trailing.equalTo(contentView.snp.trailing).offset(-CalendarCell.AutoLayout.badgeOffsetValue)
            $0.width.height.equalTo(CalendarCell.AutoLayout.badgeHeightValue)
        }
    }
    
    func setupAttribute() {
        thumbnailView.do {
            $0.clipsToBounds = true
            $0.contentMode = .scaleAspectFill
            $0.layer.cornerRadius = CalendarCell.Attribute.thumbnailCornerRadius
            $0.layer.borderWidth = 0.0
            $0.layer.borderColor = UIColor.white.cgColor
            $0.alpha = CalendarCell.Attribute.defaultAlphaValue
        }
        
        badgeView.do {
            $0.clipsToBounds = true
            $0.layer.cornerRadius = CalendarCell.AutoLayout.badgeHeightValue / 2.0
            $0.backgroundColor = UIColor.white
            $0.isHidden = true
        }
    }
    
    func bind(reactor: ImageCalendarCellReactor) {
        thumbnailView.kf.setImage(with: URL(string: reactor.currentState.imageUrl ?? ""))
        badgeView.isHidden = reactor.currentState.isHidden
    }
    
    override func prepareForReuse() {
        thumbnailView.image = nil
        thumbnailView.layer.borderWidth = .zero
        badgeView.isHidden = true
    }
}

// NOTE: - 임시 코드
extension ImageCalendarCell {
    func configure(_ date: Date, imageUrl: String, cellType type: CellType = .month) {
        if let url = URL(string: imageUrl) {
            thumbnailView.kf.setImage(with: url)
            
            let random = Bool.random()
            badgeView.isHidden = random
        }
        
        if type == .week {
            thumbnailView.alpha = 0.4
        } else {
            if date.isToday {
                thumbnailView.layer.borderWidth = CalendarCell.Attribute.thumbnailBorderWidth
            }
        }
    }
}
