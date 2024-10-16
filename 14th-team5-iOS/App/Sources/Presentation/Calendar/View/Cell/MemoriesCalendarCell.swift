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

final public class MemoriesCalendarCell: FSCalendarCell, ReactorKit.View {
    
    // MARK: - Id
    
    static let id: String = "ImageCalendarCell"
    
    // MARK: - Views
    
    private let dayLabel: BBLabel = BBLabel(.body1Regular, textAlignment: .center)
    private let containerView: UIView = UIView()
    private let thumbnailImage: UIImageView = UIImageView()
    private let todayStroke: UIView = UIView()
    private let allMemberUploadedBadge: UIImageView = UIImageView()
    
    
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
        super.prepareForReuse()
        
        dayLabel.textColor = UIColor.bibbiWhite
        thumbnailImage.image = nil
        thumbnailImage.layer.borderWidth = .zero
        thumbnailImage.layer.borderColor = UIColor.bibbiWhite.cgColor
        todayStroke.isHidden = true
        allMemberUploadedBadge.isHidden = true
    }
    
    
    // MARK: - Helpers
    
    public func bind(reactor: MemoriesCalendarCellReactor) {
        bindOutput(reactor: reactor)
    }
    
    private func bindOutput(reactor: MemoriesCalendarCellReactor) {
        let date = reactor.state.map { $0.entity.date }
            .asDriver(onErrorJustReturn: .now)
        
        date.map { "\($0.day)" }
            .distinctUntilChanged()
            .drive(dayLabel.rx.text)
            .disposed(by: disposeBag)
        
        date.map { $0.isToday }
            .filter { $0 }
            .distinctUntilChanged()
            .drive(with: self, onNext: { owner, _ in
                owner.todayStroke.isHidden = false
                owner.dayLabel.textColor = UIColor.mainYellow
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.entity.allFamilyMemebersUploaded }
            .map { !$0 }
            .bind(to: allMemberUploadedBadge.rx.isHidden)
            .disposed(by: disposeBag)
        
        reactor.state.compactMap { $0.entity.representativeThumbnailUrl }
            .compactMap { URL(string: $0) }
            .distinctUntilChanged()
            .bind(to: thumbnailImage.rx.kfImage)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isSelected }
            .filter { _ in reactor.type == .daily }
            .distinctUntilChanged()
            .bind(with: self) { $0.setHighlight(with: $1) }
            .disposed(by: disposeBag)
    }
    
    private func setupUI() {
        contentView.insertSubview(thumbnailImage, at: 0)
        contentView.insertSubview(containerView, at: 0)
        contentView.addSubviews(dayLabel, todayStroke, allMemberUploadedBadge)
    }
    
    private func setupAutoLayout() {
        dayLabel.snp.makeConstraints {
            $0.center.equalTo(contentView.snp.center)
        }
        
        containerView.snp.makeConstraints {
            $0.center.equalTo(contentView.snp.center)
            $0.size.equalTo(contentView.snp.width).inset(2.25)
        }
        
        thumbnailImage.snp.makeConstraints {
            $0.center.equalTo(contentView.snp.center)
            $0.size.equalTo(contentView.snp.width).inset(2.25)
        }
        
        todayStroke.snp.makeConstraints {
            $0.center.equalTo(contentView.snp.center)
            $0.size.equalTo(contentView.snp.width).inset(2.25)
        }
        
        allMemberUploadedBadge.snp.makeConstraints {
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
        
        thumbnailImage.do {
            $0.clipsToBounds = true
            $0.contentMode = .scaleAspectFill
            $0.layer.cornerRadius = 13
            $0.layer.borderWidth = .zero
            $0.layer.borderColor = UIColor.bibbiWhite.cgColor
            $0.alpha = 0.8
        }
        
        todayStroke.do {
            $0.isHidden = true
            $0.layer.cornerRadius = 13
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.mainYellow.cgColor
        }
        
        allMemberUploadedBadge.do {
            $0.image = DesignSystemAsset.fire.image
            $0.isHidden = true
            $0.backgroundColor = UIColor.clear
        }
    }
}


// MARK: - Extensions

extension MemoriesCalendarCell {
    
    var hasThumbnailImage: Bool {
        return thumbnailImage.image != nil ? true : false
    }
    
    func setHighlight(with selection: Bool) {
        if selection {
            todayStroke.isHidden = true
            
            thumbnailImage.alpha = 1
            containerView.alpha = 1
            thumbnailImage.layer.borderWidth = 1
            thumbnailImage.layer.borderColor = UIColor.bibbiWhite.cgColor
        } else {
            thumbnailImage.alpha = 0.3
            containerView.alpha = 0.3
            thumbnailImage.layer.borderWidth = 0
            
            if reactor?.currentState.entity.date.isToday == true {
                todayStroke.isHidden = false
                dayLabel.textColor = UIColor.mainYellow
            }
        }
    }
    
}
