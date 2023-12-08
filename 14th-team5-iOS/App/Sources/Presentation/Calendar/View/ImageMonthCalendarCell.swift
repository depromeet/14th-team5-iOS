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

final class ImageMonthCalendarCell: FSCalendarCell {
    // MARK: - Enums
    enum CellType {
        case month
        case week
    }
    
    // MARK: - Views
    private let thumbnailView: UIImageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = AttributeValue.thumbnailCornerRadius
        $0.layer.borderWidth = 0.0
        $0.layer.borderColor = UIColor.white.cgColor
        $0.alpha = AttributeValue.defaultAlphaValue
    }
    
    private let badgeView: UIView = UIView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = AutoLayout.badgeHeightValue / 2.0
        $0.backgroundColor = UIColor.white
        $0.isHidden = true
    }
    
    // MARK: - Properties
    static let identifier: String = "ImageMonthCalendarCell"
    
    // MARK: - Constants
    private enum AttributeValue {
        static let defaultAlphaValue: CGFloat = 0.8
        static let deselectAlphaValue: CGFloat = 0.4
        static let selectAlphaValue: CGFloat = 0.8
        static let thumbnailCornerRadius: CGFloat = 10.0
        static let thumbnailBorderWidth: CGFloat = 2.5
    }
    
    private enum AutoLayout {
        static let thumbnailInsetValue: CGFloat = 5.0
        static let badgeHeightValue: CGFloat = 9.0
        static let badgeOffsetValue: CGFloat = 2.0
    }
    
    // MARK: - Intializer
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
        setupAutoLayout()
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
            $0.width.height.equalTo(contentView.snp.width).inset(AutoLayout.thumbnailInsetValue)
        }
        
        badgeView.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top).offset(AutoLayout.badgeOffsetValue)
            $0.trailing.equalTo(contentView.snp.trailing).offset(-AutoLayout.badgeOffsetValue)
            $0.width.height.equalTo(AutoLayout.badgeHeightValue)
        }
        
    }
    
    override func prepareForReuse() {
        thumbnailView.image = nil
        thumbnailView.layer.borderWidth = .zero
        badgeView.isHidden = true
    }
}

extension ImageMonthCalendarCell {
    // Temp Code
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
                thumbnailView.layer.borderWidth = AttributeValue.thumbnailBorderWidth
            }
        }
    }
}
