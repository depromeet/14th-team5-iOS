//
//  EmojiCollectionViewCell.swift
//  App
//
//  Created by 마경미 on 10.12.23.
//

import UIKit
import Core

final class EmojiCollectionViewCell: BaseCollectionViewCell<FeedDetailReactor> {
    static let id = "emojiCollectionViewCell"
    
    private let emojiLabel = UILabel()
    private let countLabel = UILabel()
    
    override func setupUI() {
        addSubviews(emojiLabel, countLabel)
    }
    
    override func setupAutoLayout() {
        emojiLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(9)
            $0.centerY.equalToSuperview()
        }
        
        countLabel.snp.makeConstraints {
            $0.leading.equalTo(emojiLabel.snp.trailing)
            $0.trailing.equalToSuperview().inset(5)
            $0.centerY.equalToSuperview()
        }
    }
    
    override func setupAttributes() {

    }
}

extension EmojiCollectionViewCell {
    func setCell(emoji: EmojiData) {
        emojiLabel.text = emoji.emoji
        countLabel.text = "\(emoji.count)"
    }
}
