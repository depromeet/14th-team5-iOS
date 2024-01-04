//
//  ImageCalendarCell.swift
//  App
//
//  Created by 김건우 on 12/6/23.
//

import Foundation

import Core
import DesignSystem
import FSCalendar
import Kingfisher
import ReactorKit
import RxCocoa
import RxSwift
import SnapKit
import Then

final public class ImageCalendarCell: FSCalendarCell, ReactorKit.View {    
    // MARK: - Views
    private let dayLabel: BibbiLabel = BibbiLabel(.body1Regular, alignment: .center)
    private let thumbnailBackgroundView: UIView = UIView()
    private let thumbnailView: UIImageView = UIImageView()
    private let todayStrokeView: UIView = UIView()
    private let badgeView: UIImageView = UIImageView()
    
    // MARK: - Properties
    public var disposeBag: RxSwift.DisposeBag = DisposeBag()
    
    static let id: String = "ImageCalendarCell"
    
    // MARK: - Intializer
    public override init!(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
        setupAutoLayout()
        setupAttribute()
    }
    
    required init(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func prepareForReuse() {
        dayLabel.textBibbiColor = UIColor.bibbiWhite
        thumbnailView.image = nil
        thumbnailView.layer.borderWidth = .zero
        thumbnailView.layer.borderColor = UIColor.bibbiWhite.cgColor
        badgeView.isHidden = true
        todayStrokeView.isHidden = true
    }
    
    // MARK: - Helpers
    private func setupUI() {
        contentView.insertSubview(thumbnailView, at: 0)
        contentView.insertSubview(thumbnailBackgroundView, at: 0)
        contentView.addSubviews(
            dayLabel, badgeView, todayStrokeView
        )
    }
    
    private func setupAutoLayout() {
        dayLabel.snp.makeConstraints {
            $0.center.equalTo(contentView.snp.center)
        }
        
        thumbnailBackgroundView.snp.makeConstraints {
            $0.center.equalTo(contentView.snp.center)
            $0.width.height.equalTo(contentView.snp.width).inset(CalendarCell.AutoLayout.thumbnailInsetValue)
        }
        
        thumbnailView.snp.makeConstraints {
            $0.center.equalTo(contentView.snp.center)
            $0.width.height.equalTo(contentView.snp.width).inset(CalendarCell.AutoLayout.thumbnailInsetValue)
        }
        
        todayStrokeView.snp.makeConstraints {
            $0.center.equalTo(contentView.snp.center)
            $0.width.height.equalTo(contentView.snp.width).inset(CalendarCell.AutoLayout.thumbnailInsetValue)
        }
        
        badgeView.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top).offset(CalendarCell.AutoLayout.badgeOffsetValue)
            $0.trailing.equalTo(contentView.snp.trailing).offset(-CalendarCell.AutoLayout.badgeOffsetValue)
            $0.width.height.equalTo(15.0)
        }
    }
    
    private func setupAttribute() {
        titleLabel.do {
            $0.isHidden = true
        }
        
        thumbnailBackgroundView.do {
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 13.0
            $0.backgroundColor = DesignSystemAsset.gray900.color
        }
        
        thumbnailView.do {
            $0.clipsToBounds = true
            $0.contentMode = .scaleAspectFill
            $0.layer.cornerRadius = 13.0
            $0.layer.borderWidth = .zero
            $0.layer.borderColor = DesignSystemAsset.white.color.cgColor
            $0.alpha = CalendarCell.Attribute.defaultAlphaValue
        }
        
        todayStrokeView.do {
            $0.isHidden = true
            $0.layer.cornerRadius = 13.0
            $0.layer.borderWidth = 2.0
            $0.layer.borderColor = DesignSystemAsset.mainGreen.color.cgColor
        }
        
        badgeView.do {
            $0.image = DesignSystemAsset.greenSmileEmoji.image
            $0.isHidden = true
            $0.backgroundColor = UIColor.clear
        }
    }
    
    public func bind(reactor: ImageCalendarCellReactor) {
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
                    $0.0.todayStrokeView.isHidden = false
                    $0.0.dayLabel.textBibbiColor = UIColor.mainGreen
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
        
        // 최초 셀 생성 시, 클릭 이벤트 발생 시 하이라이트를 위해 실행됨
        reactor.state.map { $0.isSelected }
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe {
                if reactor.type == .week {
                    if $0.1 {
                        $0.0.todayStrokeView.isHidden = true
                        
                        $0.0.thumbnailView.alpha = 1.0
                        $0.0.thumbnailBackgroundView.alpha = 1.0
                        $0.0.thumbnailView.layer.borderWidth = 2.0
                        $0.0.thumbnailView.layer.borderColor = UIColor.bibbiWhite.cgColor
                    } else {
                        $0.0.thumbnailView.alpha = 0.3
                        $0.0.thumbnailBackgroundView.alpha = 0.3
                        $0.0.thumbnailView.layer.borderWidth = 0.0
                        
                        if reactor.currentState.date.isToday {
                            $0.0.todayStrokeView.isHidden = false
                            $0.0.dayLabel.textBibbiColor = UIColor.mainGreen
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
