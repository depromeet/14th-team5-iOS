//
//  FeedCollectionViewCell.swift
//  App
//
//  Created by 마경미 on 07.12.23.
//

import UIKit
import Core

final class FeedCollectionViewCell: BaseCollectionViewCell<HomeViewReactor> {
    static let id = "FeedCollectionViewCell"
    
    private let stackView = UIStackView()
    private let nameLabel = UILabel()
    private let timeLabel = UILabel()
    private let imageView = UIImageView()
    
    override func bind(reactor: HomeViewReactor) {
        
    }
    
    override func setupUI() {
        addSubviews(imageView, stackView)
        
        stackView.addArrangedSubviews(nameLabel, timeLabel)
    }
    
    override func setupAutoLayout() {
        imageView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(self.snp.width)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(36)
        }
    }
    
    override func setupAttributes() {
        stackView.do {
            $0.distribution = .fillProportionally
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
