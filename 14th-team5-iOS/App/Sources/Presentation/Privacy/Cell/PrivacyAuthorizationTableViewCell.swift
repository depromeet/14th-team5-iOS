//
//  PrivacyAuthorizationTableViewCell.swift
//  App
//
//  Created by Kim dohyun on 12/16/23.
//

import UIKit


import Core
import RxCocoa
import RxSwift
import ReactorKit
import SnapKit
import Then


public final class PrivacyAuthorizationTableViewCell: BaseTableViewCell<PrivacyCellReactor> {
    //MARK: Views
    private let descrptionLabel: UILabel = UILabel()
    
    
    
    public override func setupUI() {
        super.setupUI()
        contentView.addSubview(descrptionLabel)
    }
    
    public override func setupAttributes() {
        super.setupAttributes()
        
        self.do {
            $0.accessoryType = .disclosureIndicator
            $0.backgroundColor = .black
        }
        
        contentView.do {
            $0.backgroundColor = .black
        }
        
        descrptionLabel.do {
            $0.textColor = UIColor(red: 255/255, green: 64/255, blue: 21/255, alpha: 1.0)
            $0.font = .systemFont(ofSize: 17, weight: .regular)
            $0.textAlignment = .left
        }
    }
    
    public override func setupAutoLayout() {
        descrptionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(11)
            $0.left.equalToSuperview().offset(16)
            $0.height.equalTo(22)
            $0.centerY.equalToSuperview()
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
