//
//  MainStudioViewController.swift
//  Bibbi
//
//  Created by 마경미 on 22.09.25.
//

import UIKit

import Core
import Domain

import RxSwift
import RxCocoa
import RxDataSources

final class StudioPageViewController: BaseViewController<StudioPageReactor> {
    private let bannerView = StudioBannerView()
    
    private let refreshControl: UIRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bind(reactor: StudioPageReactor) {
        super.bind(reactor: reactor)
        
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    override func setupUI() {
        super.setupUI()
        
        view.addSubviews(
            bannerView
        )
    }
    
    override func setupAutoLayout() {
        super.setupAutoLayout()
        
        bannerView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    override func setupAttributes() {
        super.setupAttributes()
    }
}

extension StudioPageViewController {
    private func bindInput(reactor: StudioPageReactor) {
        bannerView.rx.imageTap
            .map { Reactor.Action.bannerClicked }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: StudioPageReactor) {
       
    }
}
