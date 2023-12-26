//
//  DisplayEditCollectionViewCell.swift
//  App
//
//  Created by Kim dohyun on 12/13/23.
//

import UIKit

import Core
import DesignSystem
import RxSwift
import RxCocoa
import ReactorKit
import SnapKit
import Then


public final class DisplayEditCollectionViewCell: BaseCollectionViewCell<DisplayEditCellReactor> {
    

    private let descrptionLabel: UILabel = UILabel()
    private let blurContainerView: UIVisualEffectView = UIVisualEffectView.makeBlurView(style: .dark)
    
    
    public override func setupUI() {
        super.setupUI()
        self.contentView.addSubviews(blurContainerView, descrptionLabel)
    }
    
    public override func setupAttributes() {
        super.setupAttributes()
        
        self.contentView.do {
            $0.backgroundColor = .clear
        }
        
        descrptionLabel.do {
            $0.textColor = DesignSystemAsset.white.color
            $0.textAlignment = .center
            $0.font = DesignSystemFontFamily.Pretendard.bold.font(size: 18)
        }
        
        blurContainerView.do {
            $0.alpha = 0.8
            $0.layer.cornerRadius = 8
            $0.clipsToBounds = true
        }
        
    }
    
    public override func setupAutoLayout() {
        super.setupAutoLayout()
        
        descrptionLabel.snp.makeConstraints {
            $0.width.equalTo(30)
            $0.height.equalTo(30)
            $0.center.equalToSuperview()
        }
        
        blurContainerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    
    public override func bind(reactor: DisplayEditCellReactor) {
        
        reactor.state
            .map { $0.title }
            .bind(to: descrptionLabel.rx.text)
            .disposed(by: disposeBag)
        
    }
    
    
}
