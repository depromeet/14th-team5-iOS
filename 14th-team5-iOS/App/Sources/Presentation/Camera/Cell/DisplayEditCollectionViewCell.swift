//
//  DisplayEditCollectionViewCell.swift
//  App
//
//  Created by Kim dohyun on 12/13/23.
//

import UIKit

import Core
import RxSwift
import RxCocoa
import ReactorKit
import SnapKit
import Then


public final class DisplayEditCollectionViewCell: BaseCollectionViewCell<DisplayEditCellReactor> {
    
    private let containerView: UIView = UIView()
    private let descrptionLabel: UILabel = UILabel()
    
    
    public override func setupUI() {
        super.setupUI()
        self.contentView.addSubviews(containerView, descrptionLabel)
    }
    
    public override func setupAttributes() {
        super.setupAttributes()
        
        containerView.do {
            $0.backgroundColor = .black.withAlphaComponent(0.71)
            $0.layer.cornerRadius = 8
            $0.clipsToBounds = true
        }
        
        descrptionLabel.do {
            $0.textColor = .white
            $0.textAlignment = .center
            $0.font = .systemFont(ofSize: 32, weight: .regular)
        }
        
        
    }
    
    public override func setupAutoLayout() {
        super.setupAutoLayout()
        
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        descrptionLabel.snp.makeConstraints {
            $0.width.equalTo(30)
            $0.height.equalTo(30)
            $0.center.equalTo(containerView)
        }
    }
    
    
    public override func bind(reactor: DisplayEditCellReactor) {
        
        reactor.state
            .map { $0.title }
            .bind(to: descrptionLabel.rx.text)
            .disposed(by: disposeBag)
        
    }
    
    
}
