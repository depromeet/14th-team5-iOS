//
//  BibbiRealEmojiViewCell.swift
//  App
//
//  Created by Kim dohyun on 1/23/24.
//

import UIKit

import Core
import DesignSystem
import Kingfisher
import ReactorKit
import SnapKit
import Then


final class BibbiRealEmojiViewCell: BaseCollectionViewCell<BibbiRealEmojiCellReactor> {
    
    
    private let realEmojiImageView = UIImageView()
    private let realEmojiPointImageView = UIImageView()
    
    
    override func setupUI() {
        contentView.addSubviews(realEmojiImageView, realEmojiPointImageView)
        
    }
    
    override func setupAttributes() {
        realEmojiImageView.do {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 40 / 2
        }
        
        realEmojiPointImageView.do {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 20 / 2
        }
    }
    
    override func setupAutoLayout() {
        realEmojiImageView.snp.makeConstraints {
            $0.width.height.equalTo(40)
            $0.center.equalToSuperview()
        }
        
        realEmojiPointImageView.snp.makeConstraints {
            $0.width.height.equalTo(20)
            $0.top.equalToSuperview()
            $0.left.equalToSuperview()
        }
    }
    
    
    
    override func bind(reactor: BibbiRealEmojiCellReactor) {
        
        //리얼이모지가 첫번쨰이고
        
        reactor.state
            .filter { !$0.defaultImage.isEmpty }
            .map { $0.defaultImage }
            .distinctUntilChanged()
            .map { DesignSystemImages.Image(named: $0, in: DesignSystemResources.bundle, with: nil)}
            .bind(to: realEmojiImageView.rx.image)
            .disposed(by: disposeBag)
        
        reactor.state
            .filter { $0.realEmojiImage != nil }
            .compactMap { $0.realEmojiImage }
            .distinctUntilChanged()
            .withUnretained(self)
            .bind(onNext: { $0.0.setupRealEmojiImage($0.1)})
            .disposed(by: disposeBag)
        
        reactor.state
            .filter { !$0.isSelected && !$0.defaultImage.isEmpty }
            .filter { $0.realEmojiImage == nil }
            .map { "un\($0.defaultImage)"}
            .map { DesignSystemImages.Image(named: $0, in: DesignSystemResources.bundle, with: nil)}
            .bind(to: realEmojiImageView.rx.image)
            .disposed(by: disposeBag)
        
        reactor.state
            .filter { $0.isSelected && !$0.defaultImage.isEmpty}
            .filter { $0.realEmojiImage == nil }
            .map { "\($0.defaultImage)"}
            .map { DesignSystemImages.Image(named: $0, in: DesignSystemResources.bundle, with: nil)}
            .bind(to: realEmojiImageView.rx.image)
            .disposed(by: disposeBag)
    }
    
}


extension BibbiRealEmojiViewCell {
    private func setupRealEmojiImage(_ url: URL) {
        realEmojiImageView.kf.indicatorType = .activity
        realEmojiImageView.kf.setImage(with: url, options: [.transition(.fade(0.5))])
    }
    
}
