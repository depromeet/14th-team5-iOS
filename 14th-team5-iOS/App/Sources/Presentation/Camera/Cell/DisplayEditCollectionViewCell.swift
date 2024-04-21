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
    static let id = "DisplayEditCollectionViewCell"

    private var descriptionLabel: BibbiLabel = BibbiLabel(.head1, textAlignment: .center)
    private let blurContainerView: UIVisualEffectView = UIVisualEffectView.makeBlurView(style: .dark)
    
    
    public override func setupUI() {
        super.setupUI()
        self.contentView.addSubviews(blurContainerView, descriptionLabel)
    }
  
    public override func layoutSubviews() {
      descriptionLabel.textAlignment = .center
    }
    
    public override func setupAttributes() {
        super.setupAttributes()
        
        self.contentView.do {
            $0.backgroundColor = .clear
        }
        
        
        blurContainerView.do {
            $0.alpha = 0.8
            $0.layer.cornerRadius = 8
            $0.clipsToBounds = true
        }
        
    }
    
    public override func setupAutoLayout() {
        super.setupAutoLayout()
        
        descriptionLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        blurContainerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    
    public override func bind(reactor: DisplayEditCellReactor) {
        reactor.state
            .map { $0.title }
            .bind(to: descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.radius }
            .distinctUntilChanged()
            .bind(to: blurContainerView.layer.rx.cornerRadius)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.font }
            .distinctUntilChanged()
            .bind(to: descriptionLabel.rx.fontStyle)
            .disposed(by: disposeBag)
    }
}
