//
//  AddReactionCollectionViewCell.swift
//  App
//
//  Created by 마경미 on 22.01.24.
//

import UIKit

import DesignSystem

import SnapKit

final class AddReactionCollectionViewCell: UICollectionViewCell {
    static let id = "addReactionCollectionViewCell"
    
    private let imageView: UIImageView = UIImageView()
    
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
            $0.size.equalTo(26)
            $0.center.equalToSuperview()
        }
    }
    
    private func setupAttributes() {
        backgroundColor = .gray700
        layer.cornerRadius = 20
        
        imageView.do {
            $0.image = DesignSystemAsset.addEmojiFill.image
            $0.tintColor = .gray200
        }
    }
}
