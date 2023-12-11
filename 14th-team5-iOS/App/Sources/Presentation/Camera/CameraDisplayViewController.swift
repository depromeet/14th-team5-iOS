//
//  CameraDisplayViewController.swift
//  App
//
//  Created by Kim dohyun on 12/11/23.
//

import UIKit

import Core
import DesignSystem
import RxSwift
import RxCocoa
import ReactorKit
import SnapKit


public final class CameraDisplayViewController: BaseViewController<CameraDisplayViewReactor> {
    //MARK: Views
    private let displayView: UIImageView = UIImageView()
    private let confirmButton: UIButton = UIButton.createCircleButton(radius: 36)
    private let displayIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView(style: .medium)
    
    
    //MARK: LifeCylce
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: Configure
    public override func setupUI() {
        super.setupUI()
        view.addSubviews(displayView, confirmButton, displayIndicatorView)
    }
    
    public override func setupAttributes() {
        super.setupAttributes()
        displayView.do {
            $0.layer.cornerRadius = 40
            $0.clipsToBounds = true
        }
        
        confirmButton.do {
            $0.backgroundColor = .white
            $0.setImage(DesignSystemAsset.confirm.image, for: .normal)
            
        }
        
        displayIndicatorView.do {
            $0.hidesWhenStopped = true
            $0.color = .gray
        }
    }
    
    public override func setupAutoLayout() {
        super.setupAutoLayout()
        
        displayView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(375)
            $0.center.equalToSuperview()
        }
        
        confirmButton.snp.makeConstraints {
            $0.top.equalTo(displayView.snp.bottom).offset(36)
            $0.centerX.equalTo(displayView)
        }
        
        displayIndicatorView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
    }
    
    
    public override func bind(reactor: CameraDisplayViewReactor) {
        
        Observable
            .just(())
            .map { Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$displayData)
            .map { UIImage(data: $0) }
            .asDriver(onErrorJustReturn: .none)
            .drive(displayView.rx.image)
            .disposed(by: disposeBag)
        
        
        reactor.state
            .map { $0.isLoading }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: false)
            .drive(displayIndicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
    }
}
