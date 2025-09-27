//
//  MainStudioViewController.swift
//  Bibbi
//
//  Created by 마경미 on 22.09.25.
//

import UIKit

import Core
import Domain
import DesignSystem

import RxSwift
import RxCocoa
import RxDataSources

final class StudioViewController: BBNavigationViewController<StudioReactor> {
    private let bannerView = StudioBannerView()
    private let postCView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout())
    private let feedViewController = MainPostViewController(
        reactor: .init(
            initialState: .init(type: .studio)
        )
    )
    private let uploadButton = BBButton()
    
    private lazy var noPostView = NoPostTodayView(
        type: .survival,
        frame: .init()
    )
    
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
        
        addChild(feedViewController)
        
        view.addSubviews(
            bannerView,
            feedViewController.view,
            uploadButton
        )
        
        feedViewController.didMove(toParent: self)
    }
    
    override func setupAutoLayout() {
        super.setupAutoLayout()
        
        bannerView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        feedViewController.view.snp.makeConstraints {
              $0.top.equalTo(bannerView.snp.bottom).offset(12)
            $0.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
          }

        uploadButton.snp.makeConstraints {
            $0.height.equalTo(56)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(10)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(12)
        }
    }
    
    override func setupAttributes() {
        super.setupAttributes()
        
        navigationBar.do {
            $0.leftBarButtonItem = .arrowLeft
            $0.navigationTitle = "가족 사진관"
        }
        
        uploadButton.do {
            $0.imageView?.image = DesignSystemAsset.mingcute.image
            $0.backgroundColor = .init(red: 255, green: 227, blue: 101, alpha: 1)
        }
    }
}

extension StudioViewController {
    private func bindInput(reactor: StudioReactor) {
        self.rx.viewWillAppear
                .map { _ in StudioReactor.Action.fetchStudioCount }
                .bind(to: reactor.action)
                .disposed(by: disposeBag)
        
        uploadButton.rx.tap
            .map { StudioReactor.Action.didTapUpload}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: StudioReactor) {
        reactor.pulse(\.$studioCount)
            .compactMap { $0?.postCount }
            .distinctUntilChanged()
            .bind(to: bannerView.rx.count)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$isEnabledUpload)
            .distinctUntilChanged()
            .filter { !$0 }.map { _ in .gray500 }
            .bind(to: uploadButton.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$studioCount)
            .compactMap { $0?.availableCount }
            .distinctUntilChanged()
            .map { "(\($0)/3) 이미지만들기" }
            .bind(to: uploadButton.rx.title())
            .disposed(by: disposeBag)
    }
}
