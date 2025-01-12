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
            $0.bottom.equalToSuperview()
            $0.right.equalToSuperview()
        }
    }
    
    
    
    override func bind(reactor: BibbiRealEmojiCellReactor) {
        
        reactor.state
            .filter { $0.realEmojiImage != nil }
            .compactMap { $0.realEmojiImage }
            .distinctUntilChanged()
            .withUnretained(self)
            .bind(onNext: { $0.0.setupRealEmojiImage($0.1)})
            .disposed(by: disposeBag)
        
        reactor.state
            .filter { $0.realEmojiImage != nil }
            .map { $0.indexPath }
            .withUnretained(self)
            .map { $0.0.setupPointImageView($0.1)}
            .bind(to: realEmojiPointImageView.rx.image)
            .disposed(by: disposeBag)
        
        reactor.state
            .filter { !$0.isSelected }
            .filter { $0.realEmojiImage == nil }
            .map { "unemoji\($0.indexPath + 1)" }
            .withUnretained(self)
            .map { $0.0.setupRealEmojiImage(name: $0.1)}
            .bind(to: realEmojiImageView.rx.image)
            .disposed(by: disposeBag)
        
        reactor.state
            .filter { $0.isSelected }
            .filter { $0.realEmojiImage == nil}
            .map { "emoji\($0.indexPath + 1)" }
            .withUnretained(self)
            .map { $0.0.setupRealEmojiImage(name: $0.1)}
            .bind(to: realEmojiImageView.rx.image)
            .disposed(by: disposeBag)
    }
    
}


extension BibbiRealEmojiViewCell {
    private func setupRealEmojiImage(_ url: URL) {
        realEmojiImageView.kf.indicatorType = .activity
        realEmojiImageView.clipsToBounds = true
        realEmojiImageView.kf.setImage(with: url, options: [.transition(.fade(0.5))])
    }
    
    
    private func setupRealEmojiImage(name: String) -> UIImage {
        return DesignSystemImages.Image(named: name, in: DesignSystemResources.bundle, with: nil) ?? UIImage()
    }

    private func setupPointImageView(_ type: Int) -> UIImage {
        switch type {
        case 0:
            return DesignSystemImages.Image(named: "emojipoint1", in: DesignSystemResources.bundle, with: nil) ?? UIImage()
        case 1:
            return DesignSystemImages.Image(named: "emojipoint2", in: DesignSystemResources.bundle, with: nil) ?? UIImage()
        case 2:
            return DesignSystemImages.Image(named: "emojipoint3", in: DesignSystemResources.bundle, with: nil) ?? UIImage()
        case 3:
            return DesignSystemImages.Image(named: "emojipoint4", in: DesignSystemResources.bundle, with: nil) ?? UIImage()
        case 4:
            return DesignSystemImages.Image(named: "emojipoint5", in: DesignSystemResources.bundle, with: nil) ?? UIImage()
        default:
            return UIImage()
        }
    }

    
}
