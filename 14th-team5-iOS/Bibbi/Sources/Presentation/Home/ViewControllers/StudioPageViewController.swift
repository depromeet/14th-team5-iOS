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

final class StudioPageViewController: ReactorViewController<StudioReactor> {
    private let bannerView = StudioBannerView(reactor: .init())
    private let uploadButton = BBButton()
    
    private let refreshControl: UIRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bind(reactor: StudioReactor) {
        super.bind(reactor: reactor)
        
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    override func setupUI() {
        super.setupUI()
        
        view.addSubviews(
            bannerView, uploadButton
        )
    }
    
    override func setupAutoLayout() {
        super.setupAutoLayout()
        
        bannerView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }

        uploadButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(12)
        }
    }
    
    override func setupAttributes() {
        super.setupAttributes()
    }
}

extension StudioPageViewController {
    private func bindInput(reactor: StudioReactor) {
    }
    
    private func bindOutput(reactor: StudioReactor) {
       
    }
}
