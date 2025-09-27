//
//  ImageGenerateViewController.swift
//  Bibbi
//
//  Created by 김도현 on 9/20/25.
//

import UIKit
import Photos

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
            $0.setTitle("이미지 업로드", for: .normal)
            $0.setTitleFontStyle(.body1Bold)
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
        
        uploadButton.rx.tap
            .throttle(RxInterval._300milliseconds, scheduler: RxScheduler.main)
            .map { Reactor.Action.didTappedUploadButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        archiveButton
            .rx.tap
            .throttle(RxInterval._600milliseconds, scheduler: RxScheduler.main)
            .map { Reactor.Action.didTappedArchiveButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        navigationBarView.rx.leftButtonTap
            .throttle(RxInterval._600milliseconds, scheduler: RxScheduler.main)
            .map { _ in  Reactor.Action.didTappedBackButton}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .compactMap { $0.aiImageEntity }
            .compactMap { URL(string: $0.imageUrl) }
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .map { try Data(contentsOf: $0) }
            .map { UIImage(data: $0) }
            .observe(on: MainScheduler.instance)
            .bind(to: generateImagePreview.rx.image)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$isLoading)
            .map { !$0 }
            .bind(to: uploadButton.rx.isUserInteractionEnabled)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$isLoading)
            .map { !$0 }
            .bind(with: self) { owner, isUserInteractionEnabled in
                owner.updateUploadButtonLayout(isUserInteractionEnabled)
            }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$isLoading)
            .map { $0 }
            .debounce(.milliseconds(100), scheduler: MainScheduler.instance)
            .observe(on: RxScheduler.main)
            .bind(to: generateImagePreview.rx.isShimmering)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$isLoading)
            .map { !$0 }
            .bind(to: descriptionLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.archiveData }
            .bind(with: self) { owner, archiveData in
                owner.setupCameraDisplayPermission(archiveData)
            }
            .disposed(by: disposeBag)
        
        
    }
    
}

extension ImageGenerateViewController {
    
    private func updateUploadButtonLayout(_ isUserInteractionEnabled: Bool) {
        let textColor = isUserInteractionEnabled ? DesignSystemAsset.black.color : DesignSystemAsset.gray500.color
        let backgroundColor = isUserInteractionEnabled ? DesignSystemAsset.mainYellow.color : DesignSystemAsset.gray800.color
        
        uploadButton.backgroundColor = backgroundColor
        uploadButton.setTitleColor(textColor, for: .normal)
        uploadButton.isUserInteractionEnabled = isUserInteractionEnabled
    }
    
    
    private func setupCameraDisplayPermission(_ originalData: Data) {
        let status = PHPhotoLibrary.authorizationStatus(for: .addOnly)
        if status == .authorized || status == .limited {
            PHPhotoLibrary.shared().performChanges {
                let creationRequest = PHAssetCreationRequest.forAsset()
                creationRequest.addResource(with: .photo, data: originalData, options: nil)
            }
        } else {
            PHPhotoLibrary.requestAuthorization(for: .addOnly) { stauts in
                switch status {
                case .denied:
                    DispatchQueue.main.async {
                        self.showPermissionAlertController()
                    }
                default:
                    print("다른 여부의 권한을 거부 당했습니다.")
                }
            }
        }
    }
    
    private func showPermissionAlertController() {
        let permissionAlertController: UIAlertController = UIAlertController(title: "앨범 접근 권한 설정이 없습니다.", message: "앨범에 저장하려면 앨범에 접근할 수 있도록 허용되어 있어야 합니다.", preferredStyle: .alert)
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "취소", style: .cancel) { _ in
            permissionAlertController.dismiss(animated: true)
        }
        
        let settingAction: UIAlertAction = UIAlertAction(title: "설정으로 이동하기", style: .default) { _ in
            UIApplication.shared.open(URLTypes.settings.originURL)
        }
        
        [cancelAction,settingAction].forEach(permissionAlertController.addAction(_:))
        permissionAlertController.overrideUserInterfaceStyle = .dark
        present(permissionAlertController, animated: true)
    }
}
