//
//  FeedCollectionViewCell.swift
//  App
//
//  Created by 마경미 on 07.12.23.
//

import UIKit
import Core

final class FeedCollectionViewCell: BaseCollectionViewCell<MainViewReactor> {
    static let id = "FeedCollectionViewCell"
    
    private let stackView = UIStackView()
    private let nameLabel = UILabel()
    private let timeLabel = UILabel()
    private let imageView = UIImageView()
    
    override func bind(reactor: MainViewReactor) {
        
    }
    
    override func setupUI() {
        addSubviews(stackView, imageView)
        
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(timeLabel)
    }
    
    override func setupAutoLayout() {
        stackView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(16)
        }
        
        imageView.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.top.equalTo(stackView.snp.bottom).offset(8)
        }
    }
    
    override func setupAttributes() {
        stackView.do {
            $0.distribution = .fillEqually
            $0.spacing = 0
        }
        
        imageView.do {
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 24
        }
    }
}

extension FeedCollectionViewCell {
    func setCell(data: FeedData) {
        nameLabel.text = data.name
        timeLabel.text = data.time
        imageView.kf.setImage(with: URL(string:data.imageURL)!)
    }
}
