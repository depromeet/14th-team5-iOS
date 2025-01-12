//
//  OnBoardingViewCell.swift
//  App
//
//  Created by geonhui Yu on 12/10/23.
//

import UIKit
import Core
import DesignSystem

final class OnBoardingCollectionViewCell: BaseCollectionViewCell<OnBoardingReactor> {
    static let id = "onBoardingCollectionViewCell"
    
    private let titleLabel = BBLabel(.head1, textColor: .bibbiBlack)
    private let imageView = UIImageView()
    
    private let screenSize = UIApplication.shared.connectedScenes
                    .compactMap({ scene -> UIWindow? in
                        (scene as? UIWindowScene)?.keyWindow
                    })
                    .first?
                    .frame
                    .size
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = DesignSystemAsset.mainYellow.color
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func setupUI() {
        addSubviews(titleLabel, imageView)
    }
    
    override func setupAutoLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(44)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        imageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(screenSize?.height == 667.0 ? 0 : 30)
        }
    }
    
    override func setupAttributes() {
        titleLabel.do {
            $0.numberOfLines = 2
        }
        
        imageView.do {
            $0.image = DesignSystemAsset.emoji.image
            $0.contentMode = .scaleAspectFit
        }
    }
    
    func setData(data: OnBoardingInfo) {
        titleLabel.text = data.title
        imageView.image = data.image
    }
}
