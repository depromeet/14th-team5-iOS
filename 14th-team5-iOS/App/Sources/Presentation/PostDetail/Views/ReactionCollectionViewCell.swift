//
//  ReactionCollectionViewCell.swift
//  App
//
//  Created by 마경미 on 21.01.24.
//

import UIKit

import Core
import Domain
import DesignSystem

import Kingfisher
import RxSwift
import RxDataSources

final class ReactionCollectionViewCell: BaseCollectionViewCell<TempReactor> {
    static let id = "reactionCollectionViewCell"
    
    private let selectedSubject: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    
    private let isRealEmoji: Bool = false
    private let emojiImageView = UIImageView()
    private let countLabel = BibbiLabel(.body1Regular, alignment: .right)
    
    convenience init(reacter: TempReactor? = nil) {
        self.init(frame: .zero)
        self.reactor = reacter
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupAutoLayout()
        setupAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func bind(reactor: TempReactor) {
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    override func setupUI() {
        addSubviews(emojiImageView, countLabel)
    }
    
    override func setupAutoLayout() {
        emojiImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(8)
            $0.size.equalTo(28)
            $0.centerY.equalToSuperview()
        }
        
        countLabel.snp.makeConstraints {
            $0.leading.equalTo(emojiImageView.snp.trailing).offset(5)
            $0.trailing.equalToSuperview().inset(8)
            $0.centerY.equalToSuperview()
        }
    }
    
    override func setupAttributes() {
        backgroundColor =  .gray700
        layer.cornerRadius = 18
    }
}

extension ReactionCollectionViewCell {
    private func bindInput(reactor: TempReactor) {
//        self.selectedSubject
//            .bind(to: self.rx.isSelected)
//            .disposed(by: disposeBag)
        
//        self.selectedSubject
//            .map { _ in Reactor.Action.selectCell }
//            .bind(to: reactor.action)
//            .disposed(by: disposeBag)
//    }
//    
//    private func bindOutput(reactor: SelectableEmojiReactor) {
//        reactor.state
//            .map { $0.isSelected }
//            .distinctUntilChanged()
//            .withUnretained(self)
//            .bind(onNext: {
//                $0.0.setSelected()
//            })
//            .disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: TempReactor) {
        
    }
    
    private func setSelected() {
        if isSelected {
            countLabel.textBibbiColor = .mainGreen
            layer.borderColor = UIColor.mainGreen.cgColor
            layer.borderWidth = 1
        } else {
            layer.borderWidth = 0
            countLabel.textBibbiColor = .gray300
        }
    }
}
