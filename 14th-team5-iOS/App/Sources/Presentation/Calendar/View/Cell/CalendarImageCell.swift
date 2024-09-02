//
//  ImageCalendarCell.swift
//  App
//
//  Created by 김건우 on 12/6/23.
//

import Core
import DesignSystem
import Foundation

import FSCalendar
import Kingfisher
import ReactorKit
import RxCocoa
import RxSwift
import SnapKit
import Then

final public class CalendarImageCell: FSCalendarCell, ReactorKit.View {   
    // MARK: - Id
    static let id: String = "ImageCalendarCell"
    
    // MARK: - Views
    private let dayLabel: BBLabel = BBLabel(.body1Regular, textAlignment: .center)
    private let containerView: UIView = UIView()
    private let thumbnailView: UIImageView = UIImageView()
    private let todayStrokeView: UIView = UIView()
    private let allFamilyUploadedBadge: UIImageView = UIImageView()
    
    // MARK: - Properties
    public var disposeBag: RxSwift.DisposeBag = DisposeBag()
    
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
    
    // MARK: - LifeCycles
    public override func prepareForReuse() {
        dayLabel.textColor = UIColor.bibbiWhite
        thumbnailView.image = nil
        thumbnailView.layer.borderWidth = .zero
        thumbnailView.layer.borderColor = UIColor.bibbiWhite.cgColor
        todayStrokeView.isHidden = true
        allFamilyUploadedBadge.isHidden = true
    }
    
    // MARK: - Helpers
    public func bind(reactor: CalendarImageCellReactor) {
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    private func bindInput(reactor: CalendarImageCellReactor) { }
    
    private func bindOutput(reactor: CalendarImageCellReactor) {
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
                    $0.0.dayLabel.textColor = UIColor.mainYellow
                }
            }
            .disposed(by: disposeBag)
            
        reactor.state.map { !$0.allFamilyMemebersUploaded }
            .distinctUntilChanged()
            .bind(to: allFamilyUploadedBadge.rx.isHidden)
            .disposed(by: disposeBag)
        
        reactor.state.compactMap { $0.representativeThumbnailUrl }
            .distinctUntilChanged()
            .bind(to: thumbnailView.rx.kingfisherImage)
            .disposed(by: disposeBag)
        
        // 최초 셀 생성 시, 클릭 이벤트 발생 시 하이라이트를 위해 실행됨
        reactor.state.map { $0.isSelected }
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe {
                if reactor.type == .week {
                    if $0.1 {
                        $0.0.todayStrokeView.isHidden = true
                        
                        $0.0.thumbnailView.alpha = 1
                        $0.0.containerView.alpha = 1
                        $0.0.thumbnailView.layer.borderWidth = 1
                        $0.0.thumbnailView.layer.borderColor = UIColor.bibbiWhite.cgColor
                    } else {
                        $0.0.thumbnailView.alpha = 0.3
                        $0.0.containerView.alpha = 0.3
                        $0.0.thumbnailView.layer.borderWidth = 0
                        
                        if reactor.currentState.date.isToday {
                            $0.0.todayStrokeView.isHidden = false
                            $0.0.dayLabel.textColor = UIColor.mainYellow
                        }
                    }
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func setupUI() {
        contentView.insertSubview(thumbnailView, at: 0)
        contentView.insertSubview(containerView, at: 0)
        contentView.addSubviews(dayLabel, todayStrokeView, allFamilyUploadedBadge)
    }
    
    private func setupAutoLayout() {
        dayLabel.snp.makeConstraints {
            $0.center.equalTo(contentView.snp.center)
        }
        
        containerView.snp.makeConstraints {
            $0.center.equalTo(contentView.snp.center)
            $0.size.equalTo(contentView.snp.width).inset(2.25)
        }
        
        thumbnailView.snp.makeConstraints {
            $0.center.equalTo(contentView.snp.center)
            $0.size.equalTo(contentView.snp.width).inset(2.25)
        }
        
        todayStrokeView.snp.makeConstraints {
            $0.center.equalTo(contentView.snp.center)
            $0.size.equalTo(contentView.snp.width).inset(2.25)
        }
        
        allFamilyUploadedBadge.snp.makeConstraints {
            $0.top.equalToSuperview().offset(5)
            $0.trailing.equalToSuperview().offset(-5)
            $0.size.equalTo(17)
        }
    }
    
    private func setupAttribute() {
        titleLabel.do {
            $0.isHidden = true
        }
        
        containerView.do {
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 13
            $0.backgroundColor = .gray900
        }
        
        thumbnailView.do {
            $0.clipsToBounds = true
            $0.contentMode = .scaleAspectFill
            $0.layer.cornerRadius = 13
            $0.layer.borderWidth = .zero
            $0.layer.borderColor = UIColor.bibbiWhite.cgColor
            $0.alpha = 0.8
        }
        
        todayStrokeView.do {
            $0.isHidden = true
            $0.layer.cornerRadius = 13
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.mainYellow.cgColor
        }
        
        allFamilyUploadedBadge.do {
            $0.image = DesignSystemAsset.fire.image
            $0.isHidden = true
            $0.backgroundColor = UIColor.clear
        }
    }
}

// MARK: - Extensions
extension CalendarImageCell {
    var hasThumbnailImage: Bool {
        return thumbnailView.image != nil ? true : false
    }
}
