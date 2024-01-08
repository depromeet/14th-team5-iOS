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
    
    private let titleLabel = BibbiLabel(.head1, textColor: .gray100)
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
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func setupUI() {
        addSubviews(titleLabel, imageView)
    }
    
    override func setupAutoLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        imageView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    override func setupAttributes() {
        titleLabel.do {
            $0.numberOfLines = 2
        }
        
        imageView.do {
            $0.image = DesignSystemAsset.emoji.image
            $0.contentMode = (screenSize?.height == 667.0) ? .scaleAspectFit : .scaleAspectFill
        }
    }
    
    func setData(data: OnBoardingInfo) {
        titleLabel.text = data.title
        imageView.image = data.image
    }
}
