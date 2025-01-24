//
//  PrivacyAuthorizationTableViewCell.swift
//  App
//
//  Created by Kim dohyun on 12/16/23.
//

import UIKit


import Core
import DesignSystem
import RxCocoa
import RxSwift
import ReactorKit
import SnapKit
import Then


public final class PrivacyAuthorizationTableViewCell: BaseTableViewCell<PrivacyCellReactor> {
    //MARK: Views
    private let descrptionLabel: BBLabel = BBLabel(.head2Regular, textColor: .warningRed)
    private let arrowAccessView: UIImageView = UIImageView()
    
    
    
    public override func setupUI() {
        super.setupUI()
        contentView.addSubviews(descrptionLabel, arrowAccessView)
    }
    
    public override func setupAttributes() {
        super.setupAttributes()
                
        contentView.do {
            $0.backgroundColor = DesignSystemAsset.black.color
        }
        
        descrptionLabel.do {
            $0.textAlignment = .left
        }
        
        arrowAccessView.do {
            $0.contentMode = .scaleAspectFill
            $0.image = DesignSystemAsset.settingArrow.image
        }
    }
    
    public override func setupAutoLayout() {
        super.setupAutoLayout()
        descrptionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(11)
            $0.left.equalToSuperview().offset(16)
            $0.height.equalTo(22)
            $0.centerY.equalToSuperview()
        }
        
        arrowAccessView.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-16)
            $0.width.equalTo(7)
            $0.height.equalTo(12)
            $0.centerY.equalTo(descrptionLabel)
        }
        
    }
    
    
    public override func bind(reactor: PrivacyCellReactor) {
        reactor.state
            .map { $0.descrption }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: "")
            .drive(descrptionLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
}
