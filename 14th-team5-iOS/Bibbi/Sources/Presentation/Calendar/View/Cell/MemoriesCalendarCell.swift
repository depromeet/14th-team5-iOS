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
    
    private let backgroundGray: UIView = UIView()
    private let thumbnailImage: UIImageView = UIImageView()
    private let todayStrokeView: UIView = UIView()
    private let dayLabel: BBLabel = BBLabel(.body1Regular, textAlignment: .center)
    
    private let allMembersUploadedBadge: UIImageView = UIImageView()
    
    
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
        
        todayStrokeView.isHidden = true
        thumbnailImage.image = nil
        thumbnailImage.layer.borderWidth = .zero
        thumbnailImage.layer.borderColor = UIColor.bibbiWhite.cgColor
        dayLabel.textColor = UIColor.bibbiWhite
        allMembersUploadedBadge.isHidden = true
    }
    
    
    // MARK: - Helpers
    
    public func bind(reactor: MemoriesCalendarCellReactor) {
        bindOutput(reactor: reactor)
    }
    
    private func bindOutput(reactor: MemoriesCalendarCellReactor) {
        let date = reactor.state.map { $0.date }
            .asDriver(onErrorJustReturn: .now)
        
        date.map { $0.day.description }
            .distinctUntilChanged()
            .drive(dayLabel.rx.text)
            .disposed(by: disposeBag)
        
        date.map { $0.isToday }
            .filter { $0 }
            .distinctUntilChanged()
            .drive(with: self, onNext: { owner, _ in owner.setTodayHighlight() })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.allMemebersUploaded }
            .map { !$0 }
            .bind(to: allMembersUploadedBadge.rx.isHidden)
            .disposed(by: disposeBag)
        
        reactor.state.compactMap { $0.thumbnailImageUrl }
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
        contentView.addSubviews(backgroundGray, thumbnailImage, dayLabel, todayStrokeView, allMembersUploadedBadge)
    }
    
    private func setupAutoLayout() {
        dayLabel.snp.makeConstraints {
            $0.center.equalTo(contentView.snp.center)
        }
        
        backgroundGray.snp.makeConstraints {
            $0.center.equalTo(contentView.snp.center)
            $0.size.equalTo(contentView.snp.width).inset(2.25)
        }
        
        thumbnailImage.snp.makeConstraints {
            $0.center.equalTo(contentView.snp.center)
            $0.size.equalTo(contentView.snp.width).inset(2.25)
        }
        
        todayStrokeView.snp.makeConstraints {
            $0.center.equalTo(contentView.snp.center)
            $0.size.equalTo(contentView.snp.width).inset(2.25)
        }
        
        allMembersUploadedBadge.snp.makeConstraints {
            $0.top.equalToSuperview().offset(5)
            $0.trailing.equalToSuperview().offset(-5)
            $0.size.equalTo(17)
        }
    }
    
    private func setupAttribute() {
        titleLabel.do {
            $0.isHidden = true
        }
        
        backgroundGray.do {
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
        
        todayStrokeView.do {
            $0.isHidden = true
            $0.layer.cornerRadius = 13
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.mainYellow.cgColor
        }
        
        allMembersUploadedBadge.do {
            $0.image = DesignSystemAsset.fire.image
            $0.isHidden = true
            $0.backgroundColor = UIColor.clear
        }
    }
}


// MARK: - Extensions

extension MemoriesCalendarCell {
    
    func setHighlight(with selection: Bool) {
        if selection {
            backgroundGray.alpha = 1
            thumbnailImage.alpha = 1
            thumbnailImage.layer.borderWidth = 1
            thumbnailImage.layer.borderColor = UIColor.bibbiWhite.cgColor
            todayStrokeView.isHidden = true
        } else {
            backgroundGray.alpha = 0.3
            thumbnailImage.alpha = 0.3
            thumbnailImage.layer.borderWidth = 0
            if reactor!.initialState.date.isToday { setTodayHighlight() }
        }
    }
    
    func setTodayHighlight() {
        todayStrokeView.isHidden = false
        dayLabel.textColor = UIColor.mainYellow
    }
    
    var hasThumbnailImage: Bool {
        return thumbnailImage.image != nil ? true : false
    }
    
}
