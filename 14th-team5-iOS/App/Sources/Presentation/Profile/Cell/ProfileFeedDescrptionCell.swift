//
//  ProfileFeedDescrptionCell.swift
//  App
//
//  Created by Kim dohyun on 2/11/24.
//

import UIKit

import Core
import RxSwift
import RxCocoa
import SnapKit
import Then


final class ProfileFeedDescrptionCell: BaseCollectionViewCell<ProfileFeedDescrptionCellReactor> {
    
    private let descrptionLabel: BibbiLabel = BibbiLabel(.homeFeed, alignment: .center)
    private let blurContainerView: UIVisualEffectView = UIVisualEffectView.makeBlurView(style: .dark)
    
    
    override func setupUI() {
        super.setupUI()
        contentView.addSubviews(blurContainerView, descrptionLabel)
    }
    
    override func setupAttributes() {
        super.setupAttributes()
        
        blurContainerView.do {
            $0.alpha = 0.8
            $0.layer.cornerRadius = 7
            $0.clipsToBounds = true
        }
    }
    
    
    override func setupAutoLayout() {
        super.setupAutoLayout()
        
        descrptionLabel.snp.makeConstraints {
            $0.width.equalTo(11)
            $0.height.equalTo(17)
            $0.center.equalToSuperview()
        }
        
        blurContainerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func bind(reactor: ProfileFeedDescrptionCellReactor) {
        reactor.state
            .map { $0.content }
            .bind(to: descrptionLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
