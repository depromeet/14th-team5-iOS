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
    // MARK: - Views
    private let dayLabel: UILabel = UILabel()
    private let noThumbnailView: UIView = UIView()
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
    
    override func prepareForReuse() {
        dayLabel.textColor = UIColor.white
        thumbnailView.image = nil
        thumbnailView.layer.borderWidth = .zero
        thumbnailView.layer.borderColor = UIColor.white.cgColor
        badgeView.isHidden = true
    }
    
    // MARK: - Helpers
    private func setupUI() {
        contentView.insertSubview(thumbnailView, at: 0)
        contentView.insertSubview(noThumbnailView, at: 0)
        contentView.addSubviews(
            dayLabel, badgeView
        )
    }
    
    private func setupAutoLayout() {
        dayLabel.snp.makeConstraints {
            $0.center.equalTo(contentView.snp.center)
        }
        
        noThumbnailView.snp.makeConstraints {
            $0.center.equalTo(contentView.snp.center)
            $0.width.height.equalTo(contentView.snp.width).inset(CalendarCell.AutoLayout.thumbnailInsetValue)
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
    
    private func setupAttribute() {
        titleLabel.do {
            $0.isHidden = true
        }
        
        dayLabel.do {
            $0.text = "0"
            $0.textColor = UIColor.white
            $0.textAlignment = .center
            $0.font = UIFont.boldSystemFont(ofSize: 16)
        }
        
        noThumbnailView.do {
            $0.clipsToBounds = true
            $0.contentMode = .scaleAspectFill
            $0.layer.cornerRadius = CalendarCell.Attribute.thumbnailCornerRadius
            $0.backgroundColor = UIColor.darkGray
        }
        
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
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    private func bindInput(reactor: ImageCalendarCellReactor) { }
    
    private func bindOutput(reactor: ImageCalendarCellReactor) {
        reactor.state.map { "\($0.date.day)" }
            .distinctUntilChanged()
            .bind(to: dayLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.date.isToday }
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe {
                if $0.1 {
                    $0.0.dayLabel.textColor = UIColor.green
                    $0.0.thumbnailView.layer.borderWidth = 1.5
                    $0.0.thumbnailView.layer.borderColor = UIColor.green.cgColor
                }
            }
            .disposed(by: disposeBag)
            
        reactor.state.map { !$0.allFamilyMemebersUploaded }
            .distinctUntilChanged()
            .bind(to: badgeView.rx.isHidden)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.representativeThumbnailUrl }
            .compactMap { $0 }
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe {
                $0.0.thumbnailView.kf.setImage(
                    with: URL(string: $0.1),
                    options: [
                        .transition(.fade(0.25))
                    ]
                )
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isSelected }
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe {
                if reactor.type == .week {
                    if $0.1 {
                        $0.0.thumbnailView.layer.borderWidth = 1.5
                        $0.0.thumbnailView.layer.borderColor = UIColor.white.cgColor
                    } else {
                        $0.0.thumbnailView.layer.borderWidth = 0.0
                        
                        if reactor.currentState.date.isToday {
                            $0.0.dayLabel.textColor = UIColor.green
                            $0.0.thumbnailView.layer.borderWidth = 1.5
                            $0.0.thumbnailView.layer.borderColor = UIColor.green.cgColor
                        }
                    }
                }
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Extensions
extension ImageCalendarCell {
    var hasThumbnailImage: Bool {
        return thumbnailView.image != nil ? true : false
    }
}
