//
//  AddCommentCollectionViewCell.swift
//  App
//
//  Created by 마경미 on 22.01.24.
//

import UIKit

import Core
import DesignSystem

import SnapKit

final class AddCommentCollectionViewCell: UICollectionViewCell {
    static let id = "addCommentCollectionViewCell"
    
    private let imageView: UIImageView = UIImageView()
    private let countLabel: BibbiLabel = BibbiLabel(.body2Regular)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupAutoLayout()
        setupAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(imageView)
    }
    
    private func setupAutoLayout() {
        imageView.snp.makeConstraints {
            $0.size.equalTo(24)
            $0.center.equalToSuperview()
        }
    }
    
    private func setupAttributes() {
        backgroundColor = .gray700
        layer.cornerRadius = 18
        
        imageView.do {
            $0.image = DesignSystemAsset.chat.image
            $0.tintColor = .gray200
        }
        
        countLabel.do {
            $0.textBibbiColor = .gray200
        }
    }
}
