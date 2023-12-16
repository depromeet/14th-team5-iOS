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
    private let descrptionLabel: UILabel = UILabel()
    private let arrowAccessView: UIImageView = UIImageView()
    private let underLineView: UIView = UIView()
    
    
    
    public override func setupUI() {
        super.setupUI()
        contentView.addSubviews(descrptionLabel, arrowAccessView, underLineView)
    }
    
    public override func setupAttributes() {
        super.setupAttributes()
                
        contentView.do {
            $0.backgroundColor = .black
        }
        
        descrptionLabel.do {
            $0.textColor = UIColor(red: 255/255, green: 64/255, blue: 21/255, alpha: 1.0)
            $0.font = .systemFont(ofSize: 17, weight: .regular)
            $0.textAlignment = .left
        }
        
        arrowAccessView.do {
            $0.contentMode = .scaleToFill
            $0.image = DesignSystemAsset.arrow.image
        }
        
        underLineView.do {
            $0.backgroundColor = UIColor(red: 56/255, green: 56/255, blue: 58/255, alpha: 1.0)
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
        
        underLineView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview()
            $0.height.equalTo(1)
            $0.bottom.equalToSuperview().offset(-1)
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
