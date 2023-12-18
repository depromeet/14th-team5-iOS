//
//  FeedCollectionReusableView.swift
//  App
//
//  Created by 마경미 on 09.12.23.
//

import UIKit

final class FeedCollectionReusableView: UICollectionReusableView {
    static let id: String = "FeedCollectionReusableView"
    
    private let titleLabel = UILabel()
    
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
        addSubview(titleLabel)
    }
    
    private func setupAutoLayout() {
        titleLabel.snp.makeConstraints {
            $0.leading.centerY.equalToSuperview()
        }
    }
    
    private func setupAttributes() {
    }
}

extension FeedCollectionReusableView {
    func setHeader(title: String) {
        titleLabel.text = title
    }
}
