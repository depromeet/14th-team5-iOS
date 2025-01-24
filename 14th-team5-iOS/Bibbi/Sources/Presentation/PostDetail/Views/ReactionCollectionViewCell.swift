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

final class ReactionCollectionViewCell: BaseCollectionViewCell<TempCellReactor> {
    static let id = "reactionCollectionViewCell"
    
    private let emojiImageView = UIImageView()
    private let badgeView = UIImageView()
    private let countLabel = BBLabel(.body2Regular, textAlignment: .left)
    
    convenience init(reacter: TempCellReactor? = nil) {
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
    
    override func bind(reactor: TempCellReactor) {
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    override func setupUI() {
        addSubviews(emojiImageView, countLabel, badgeView)
    }
    
    override func setupAutoLayout() {
        emojiImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(6)
            $0.size.equalTo(26)
            $0.centerY.equalToSuperview()
        }
        
        countLabel.snp.makeConstraints {
            $0.leading.equalTo(emojiImageView.snp.trailing).offset(2)
            $0.trailing.equalToSuperview().inset(4)
            $0.centerY.equalToSuperview()
        }
        
        badgeView.snp.makeConstraints {
            $0.size.equalTo(13)
            $0.trailing.equalTo(emojiImageView).offset(2.5)
            $0.bottom.equalTo(emojiImageView).offset(2.5)
        }
    }
    
    override func setupAttributes() {
        backgroundColor =  .gray700
        layer.cornerRadius = 20
        
        emojiImageView.do {
//            $0.layer.cornerRadius = 13
//            $0.clipsToBounds = true
            $0.contentMode = .scaleAspectFill
        }
    }
}

extension ReactionCollectionViewCell {
    private func bindInput(reactor: TempCellReactor) {
        Observable.just(())
            .map { Reactor.Action.setCell }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: TempCellReactor) {
        reactor.state
            .compactMap { $0.cellData }
            .withUnretained(self)
            .bind(onNext: { $0.0.setCell(data: $0.1) })
            .disposed(by: disposeBag)
    }
    
    private func setCell(data: EmojiEntity) {
        if data.count == 0 {
            return
        }
        
        badgeView.isHidden = data.isStandard
        setSelected(isSelected: data.isSelfSelected)
        countLabel.text = "\(data.count)"
        
        if data.isStandard {
            emojiImageView.clipsToBounds = false
            emojiImageView.image = data.emojiType.emojiImage
        } else {
            emojiImageView.layer.cornerRadius = 13
            emojiImageView.clipsToBounds = true
            emojiImageView.kf.setImage(with: URL(string: data.realEmojiImageURL))
            badgeView.image = data.emojiType.emojiBadgeImage
        }
    }
    
    private func setSelected(isSelected: Bool) {
        self.isSelected = isSelected
        if isSelected {
            countLabel.textColor = .mainYellow
            layer.borderColor = UIColor.mainYellow.cgColor
            layer.borderWidth = 1
        } else {
            layer.borderWidth = 0
            countLabel.textColor = .gray300
        }
    }
}
