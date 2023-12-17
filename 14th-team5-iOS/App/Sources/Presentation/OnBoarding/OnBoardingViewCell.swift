//
//  OnBoardingViewCell.swift
//  App
//
//  Created by geonhui Yu on 12/10/23.
//

import UIKit
import Core

final class OnBoardingCollectionViewCell: BaseCollectionViewCell<OnBoardingReactor> {
    static let id = "onBoardingCollectionViewCell"
    
    private let titleLabel = UILabel()
    private let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func setupUI() {
        addSubviews(titleLabel, imageView)
    }
    
    override func setupAutoLayout() {
        titleLabel.snp.makeConstraints {
            $0.verticalEdges.horizontalEdges.equalToSuperview()
            $0.height.equalTo(52)
        }
        
        imageView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(self.safeAreaLayoutGuide).inset(50)
        }
    }
    
    override func setupAttributes() {
        titleLabel.do {
            $0.numberOfLines = 2
            $0.textColor = .blue
            $0.textAlignment = .center
        }
        
        imageView.do {
            $0.contentMode = .center
        }
    }
    
    func setData(data: OnBoardingInfo) {
        titleLabel.text = data.title
        imageView.image = data.image
    }
}
