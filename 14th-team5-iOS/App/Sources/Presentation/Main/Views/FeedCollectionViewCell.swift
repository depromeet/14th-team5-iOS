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
    
    private let nameLabel = UILabel()
    private let timeLabel = UILabel()
    private let imageView = UIImageView()
    
    override func bind(reactor: MainViewReactor) {
        
    }
    
    override func setupUI() {
    }
    
    override func setupAutoLayout() { 
        addSubviews(nameLabel, timeLabel, imageView)
        
        nameLabel.snp.makeConstraints {
            $0.leading.top.equalToSuperview()
        }
        
        timeLabel.snp.makeConstraints {
            $0.leading.equalTo(nameLabel.snp.trailing)
            $0.top.trailing.equalToSuperview()
        }
        
        imageView.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.top.equalTo(nameLabel.snp.bottom).offset(8)
        }
    }
    
    override func setupAttributes() { 
        
    }
}

extension FeedCollectionViewCell {
    func setCell(data: FeedData) {
        nameLabel.text = data.name
        timeLabel.text = data.time
        imageView.kf.setImage(with: URL(string:data.imageURL)!)
    }
}
