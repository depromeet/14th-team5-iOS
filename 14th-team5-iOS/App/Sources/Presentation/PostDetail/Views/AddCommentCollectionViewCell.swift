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
    private let countLabel: BibbiLabel = BibbiLabel(.body2Regular, textColor: .gray200)
    
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
        addSubviews(imageView, countLabel)
    }
    
    private func setupAutoLayout() {
        imageView.snp.makeConstraints {
            $0.size.equalTo(26)
            $0.trailing.equalToSuperview().inset(7)
            $0.centerY.equalToSuperview()
        }
        
        countLabel.snp.makeConstraints {
            $0.trailing.equalTo(imageView.snp.leading).offset(-4)
            $0.leading.equalToSuperview().inset(7)
            $0.centerY.equalToSuperview()
        }
    }
    
    private func setupAttributes() {
        backgroundColor = .gray700
        layer.cornerRadius = 20
        
        imageView.do {
            $0.image = DesignSystemAsset.chat.image
            $0.tintColor = .gray200
        }
    }
}

extension AddCommentCollectionViewCell {
    func setCount(count: Int) {
        countLabel.text = "\(count)"
    }
}
