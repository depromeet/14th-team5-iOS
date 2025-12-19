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
            $0.layer.cornerRadius = 28
            uploadButton.setTitleFontStyle(.body1Bold)
            $0.setLayout([.text, .image], spacing: 8)
            $0.setImage(DesignSystemAsset.mingcute.image)
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
            .bind(with: self, onNext: { owner, isEnabled in
                owner.updateUploadButtonLayout(isEnabled)
            })
            .disposed(by: disposeBag)

        
        reactor.pulse(\.$studioCount)
            .compactMap { $0?.availableCount }
            .distinctUntilChanged()
            .map { "(\($0)/3) 이미지만들기" }
            .bind(to: uploadButton.rx.title())
            .disposed(by: disposeBag)
    }
}


extension StudioViewController {
    private func updateUploadButtonLayout(_ isEnabled: Bool) {
        let textColor = isEnabled ? DesignSystemAsset.black.color : DesignSystemAsset.gray500.color
        let backgroundColor = isEnabled ? DesignSystemAsset.graphicPink.color : DesignSystemAsset.gray800.color
        let imageTintColor = isEnabled ? DesignSystemAsset.black.color : DesignSystemAsset.gray500.color
        
        
        uploadButton.backgroundColor = backgroundColor
        uploadButton.setImageTintColor(imageTintColor)
        uploadButton.setTitleColor(textColor, for: .normal)
    }
    
}
