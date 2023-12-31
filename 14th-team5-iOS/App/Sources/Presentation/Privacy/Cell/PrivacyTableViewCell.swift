//
//  PrivacyTableViewCell.swift
//  App
//
//  Created by Kim dohyun on 12/16/23.
//

import UIKit

import Core
import DesignSystem
import RxSwift
import RxCocoa
import ReactorKit
import SnapKit
import Then

public final class PrivacyTableViewCell: BaseTableViewCell<PrivacyCellReactor> {
    //MARK: Views
    private let descrptionLabel: BibbiLabel = BibbiLabel(.head2Regular, textColor: .gray200)
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
        
        arrowAccessView.do {
            $0.contentMode = .scaleToFill
            $0.image = DesignSystemAsset.arrow.image
        }
        
        descrptionLabel.do {
            $0.textAlignment = .left
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
            .map { $0.descrption}
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: "")
            .drive(descrptionLabel.rx.text)
            .disposed(by: disposeBag)
        
    }
    
}
