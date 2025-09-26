//
//  ImageGenerateViewController.swift
//  Bibbi
//
//  Created by 김도현 on 9/20/25.
//

import UIKit

import Core
import ReactorKit
import SnapKit
import DesignSystem



public final class ImageGenerateViewController: ReactorViewController<ImageGenerateViewReactor> {
    private let uploadButton: BBButton = BBButton()
    private let archiveButton: UIButton = UIButton.createCircleButton(radius: 24)
    private let descriptionLabel: BBLabel = BBLabel()
    private let generateImagePreview: UIImageView = UIImageView()
    private let navigationBarView: BibbiNavigationBarView = BibbiNavigationBarView()
    
    
    
    
    //MARK: LifeCylces
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if generateImagePreview.bounds.width > 0 {
            generateImagePreview.isShimmering = true
        }
    }
    
    
    //MARK: Configure
    public override func setupUI() {
        super.setupUI()
        view.addSubviews(uploadButton, generateImagePreview, descriptionLabel, archiveButton, navigationBarView)
        
        
    }
    
    public override func setupAttributes() {
        super.setupAttributes()
        navigationBarView.do {
            $0.setNavigationView(leftItem: .arrowLeft, centerItem: .label("사진 올리기"), rightItem: .empty)
        }
        
        uploadButton.do {
            $0.backgroundColor = DesignSystemAsset.gray800.color
            $0.setTitle("이미지 업로드", for: .normal)
            $0.setTitleFontStyle(.body1Bold)
            $0.setTitleColor(DesignSystemAsset.gray500.color, for: .normal)
            $0.layer.cornerRadius = 30
            $0.clipsToBounds = true
            $0.isUserInteractionEnabled = false
        }
        
        archiveButton.do {
            $0.backgroundColor = DesignSystemAsset.gray800.color
            $0.setImage(DesignSystemAsset.archive.image, for: .normal)
        }
        
        generateImagePreview.do {
            $0.clipsToBounds = true
            $0.backgroundColor = DesignSystemAsset.gray900.color
            $0.layer.cornerRadius = 40
            $0.layoutIfNeeded()
            $0.isShimmering = true
        }
        
        descriptionLabel.do {
            $0.text = "이미지 생성 중"
            $0.textColor = DesignSystemAsset.gray500.color
            $0.fontStyle = .body1Bold
            $0.textAlignment = .center
        }
                
    }
    
    public override func setupAutoLayout() {
        super.setupAutoLayout()
        
        navigationBarView.snp.makeConstraints {
            $0.horizontalEdges.top.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(52)
        }
        
        generateImagePreview.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(generateImagePreview.snp.width).multipliedBy(1.0)
            $0.center.equalToSuperview()
        }
        
        uploadButton.snp.makeConstraints {
            $0.top.equalTo(generateImagePreview.snp.bottom).offset(53)
            $0.width.equalTo(188)
            $0.height.equalTo(56)
            $0.centerX.equalTo(generateImagePreview)
        }
        
        archiveButton.snp.makeConstraints {
            $0.width.height.equalTo(48)
            $0.left.equalTo(uploadButton.snp.right).offset(16)
            $0.centerY.equalTo(uploadButton)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.width.equalTo(100)
            $0.height.equalTo(24)
            $0.center.equalTo(generateImagePreview)
        }
        
        
        
    }
    
    
    public override func bind(reactor: ImageGenerateViewReactor) {
        super.bind(reactor: reactor)
        
        Observable.just(())
            .map{ Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        navigationBarView.rx.leftButtonTap
            .bind(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        reactor.state.compactMap { $0.aiImageEntity}
            .compactMap { URL(string: $0.imageUrl) }
            .map { try Data(contentsOf: $0) }
            .map { UIImage(data: $0) }
            .bind(to: generateImagePreview.rx.image)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$isLoading)
            .debug("로딩 중입니다잉")
            .bind(to: uploadButton.rx.isUserInteractionEnabled)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$isLoading)
            .bind(to: generateImagePreview.rx.isShimmering)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$isLoading)
            .bind(to: descriptionLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        
    }
    
}
