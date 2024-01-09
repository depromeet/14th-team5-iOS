//
//  FeedCollectionViewCell.swift
//  App
//
//  Created by 마경미 on 07.12.23.
//

import UIKit
import Core
import Domain

final class FeedCollectionViewCell: BaseCollectionViewCell<HomeViewReactor> {
    typealias Layout = HomeAutoLayout.FeedCollectionView
    static let id = "FeedCollectionViewCell"
    
    private let stackView = UIStackView()
    private let nameLabel = BibbiLabel(.body2Regular, alignment: .left, textColor: .gray200)
    private let timeLabel = BibbiLabel(.caption, alignment: .right, textColor: .gray400)
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
            $0.horizontalEdges.equalToSuperview().inset(Layout.StackView.horizontalInset)
            $0.height.equalTo(Layout.StackView.height)
        }
    }
    
    override func setupAttributes() {
        stackView.do {
            $0.distribution = .fillProportionally
            $0.spacing = Layout.StackView.spacing
        }
        
        imageView.do {
            $0.clipsToBounds = true
            $0.layer.cornerRadius = Layout.ImageView.cornerRadius
        }
    }
}

extension FeedCollectionViewCell {
    func setCell(data: PostListData) {
        guard let imageURL = URL(string: data.imageURL) else {
            return
        }
        
        nameLabel.text = data.author?.name ?? "알 수 없음"
        timeLabel.text = data.time.toDate(with: "yyyy-MM-dd'T'HH:mm:ssZ").relativeFormatter()

        imageView.kf.setImage(with: imageURL)
    }
}
