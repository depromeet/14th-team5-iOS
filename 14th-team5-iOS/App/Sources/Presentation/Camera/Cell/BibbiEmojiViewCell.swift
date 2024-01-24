//
//  BibbiEmojiViewCell.swift
//  App
//
//  Created by Kim dohyun on 1/23/24.
//

import UIKit

import Core
import DesignSystem
import ReactorKit
import SnapKit
import Then


final class BibbiEmojiViewCell: BaseCollectionViewCell<BibbiEmojiCellReactor> {
    
    private let emojiImageView = UIImageView()
    
    
    override func setupUI() {
        contentView.addSubview(emojiImageView)
    }
    
    override func setupAttributes() {
        emojiImageView.do {
            $0.contentMode = .scaleAspectFill
        }
    }
    
    override func setupAutoLayout() {
        emojiImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    
    
}


