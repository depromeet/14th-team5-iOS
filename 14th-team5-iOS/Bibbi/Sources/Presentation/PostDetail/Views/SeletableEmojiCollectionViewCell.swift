//
//  SeletableEmojiCollectionViewCell.swift
//  App
//
//  Created by 마경미 on 26.01.24.
//

import UIKit

import Core
import Domain

final class SelectableEmojiCollectionViewCell: UICollectionViewCell {
    static let id = "selectableEmojiCollectionViewCell"
    
    private let imageView: UIImageView = UIImageView()
    private let badgeView: UIImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupAutoLayout()
        setupAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupUI() {
        addSubviews(imageView, badgeView)
    }
    
    func setupAutoLayout() {
        imageView.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.size.equalTo(40)
        }
        
        badgeView.snp.makeConstraints {
            $0.trailing.bottom.equalToSuperview()
            $0.size.equalTo(20)
        }
    }
    
    func setupAttributes() {
        imageView.do {
            $0.contentMode = .scaleAspectFill
        }
    }
}

extension SelectableEmojiCollectionViewCell {
    func setData(data: Emojis) {
        badgeView.isHidden = true
        imageView.image = data.emojiImage
    }
    
    func setData(index: Int, data: MyRealEmojiEntity?) {
        if let data {
            badgeView.isHidden = false
            badgeView.image = data.type.emojiBadgeImage
            imageView.kf.setImage(with: URL(string: data.imageUrl))
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 20
        } else {
            badgeView.isHidden = true
            imageView.alpha = 0.5
            imageView.image = Emojis.getEmojiImage(index: index + 1)
            imageView.clipsToBounds = false
            imageView.layer.cornerRadius = 0
        }
    }
}
