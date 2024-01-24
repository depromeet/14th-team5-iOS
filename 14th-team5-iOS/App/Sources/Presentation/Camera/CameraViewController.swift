//
//  CameraViewController.swift
//  App
//
//  Created by Kim dohyun on 12/6/23.
//

import AVFoundation
import UIKit

import Core
import Data
import DesignSystem
import ReactorKit
import RxSwift
import RxCocoa
import RxDataSources
import SnapKit

public final class CameraViewController: BaseViewController<CameraViewReactor> {
    //MARK: Properties
    fileprivate var captureSession: AVCaptureSession!
    fileprivate var previewLayer: AVCaptureVideoPreviewLayer!
    fileprivate var backCamera: AVCaptureDevice!
    fileprivate var frontCamera: AVCaptureDevice!
    fileprivate var backCameraInput: AVCaptureDeviceInput!
    fileprivate var frontCameraInput: AVCaptureDeviceInput!
    fileprivate var cameraOuputStream: AVCaptureVideoDataOutput!
    fileprivate var captureOutputStream: AVCapturePhotoOutput!
    
    //MARK: Views
    private let cameraView: UIView = UIView()
    private let cameraNavigationBar: BibbiNavigationBarView = BibbiNavigationBarView()
    private let shutterButton: UIButton = UIButton()
    private let flashButton: UIButton = UIButton.createCircleButton(radius: 24)
    private let toggleButton: UIButton = UIButton.createCircleButton(radius: 24)
    private let cameraIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView(style: .medium)
    private let filterView: UIImageView = UIImageView()
    private let zoomView: UIImageView = UIImageView()
    private let realEmojiDescriptionLabel = BibbiLabel(.body1Regular, textColor: .mainYellow)
    private let realEmojiFaceImageView = UIImageView()
    private let realEmojiHorizontalStakView = UIStackView()
    private let realEmojiFlowLayout = UICollectionViewFlowLayout()
    private lazy var realEmojiCollectionView = UICollectionView(frame: .zero, collectionViewLayout: realEmojiFlowLayout)
    private lazy var realEmojiDataSources: RxCollectionViewSectionedReloadDataSource<EmojiSectionModel> = .init { dataSources, collectionView, indexPath, sectionItem in
        switch sectionItem {
        case let .emojiItem(cellReactor):
            guard let emojiCell = collectionView.dequeueReusableCell(withReuseIdentifier: "BibbiEmojiViewCell", for: indexPath) as? BibbiEmojiViewCell else { return UICollectionViewCell() }
            emojiCell.reactor = cellReactor
            return emojiCell
            
        case let .realEmojiItem(cellReactor):
            guard let realEmojiCell = collectionView.dequeueReusableCell(withReuseIdentifier: "BibbiRealEmojiViewCell", for: indexPath) as? BibbiRealEmojiViewCell else { return UICollectionViewCell() }
            realEmojiCell.reactor = cellReactor
            return realEmojiCell
        }
    }
    
    private var initialScale: CGFloat = 0
    private var zoomScaleRange: ClosedRange<CGFloat> = 1...10
    private var isToggle: Bool = false
    
    //MARK: LifeCylce
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupCameraPermission()
    }
    
    //MARK: Configure
    public override func setupUI() {
        super.setupUI()
        view.addSubviews(cameraView, shutterButton, flashButton, toggleButton, cameraIndicatorView, realEmojiHorizontalStakView, realEmojiCollectionView, cameraNavigationBar)
    }
    
    public override func setupAttributes() {
        super.setupAttributes()
        
        cameraIndicatorView.do {
            $0.hidesWhenStopped = true
            $0.color = .gray
        }
        
        cameraNavigationBar.do {
            $0.leftBarButtonItem = .xmark
            $0.leftBarButtonItemTintColor = .gray300
        }
        
        realEmojiDescriptionLabel.do {
            $0.text = "표정을 따라해보세요"
        }
        
        zoomView.do {
            $0.image = DesignSystemAsset.zoom.image
            $0.contentMode = .scaleAspectFill
        }
        
        realEmojiFlowLayout.do {
            $0.scrollDirection = .horizontal
            $0.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        }
        
        realEmojiCollectionView.do {
            $0.register(BibbiEmojiViewCell.self, forCellWithReuseIdentifier: "BibbiEmojiViewCell")
            $0.register(BibbiRealEmojiViewCell.self, forCellWithReuseIdentifier: "BibbiRealEmojiViewCell")
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
            $0.backgroundColor = .gray700
            $0.layer.cornerRadius = 33
            $0.clipsToBounds = true
        }
        
        realEmojiFaceImageView.do {
            $0.contentMode = .scaleAspectFill
            //TODO: DesignSystem Image 추가시 변경
            $0.image = DesignSystemAsset.emoji1.image
        }
        
        realEmojiHorizontalStakView.do {
            $0.axis = .horizontal
            $0.spacing = 4
            $0.alignment = .center
            $0.distribution = .fill
            $0.addArrangedSubviews(realEmojiFaceImageView, realEmojiDescriptionLabel)
        }
        
        filterView.do {
            $0.contentMode = .scaleAspectFill
            $0.image = DesignSystemAsset.filter.image
        }

        cameraView.do {
            $0.layer.cornerRadius = 40
            $0.clipsToBounds = true
        }
        
        shutterButton.do {
            $0.setImage(DesignSystemAsset.shutter.image, for: .normal)
        }
        
        flashButton.do {
            $0.setImage(DesignSystemAsset.flash.image, for: .normal)
            $0.backgroundColor = .darkGray
        }
        
        toggleButton.do {
            $0.setImage(DesignSystemAsset.toggle.image, for: .normal)
            $0.backgroundColor = .darkGray
        }
    }
    
    public override func setupAutoLayout() {
        super.setupAutoLayout()
        
        cameraNavigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(42)
        }
        
        realEmojiHorizontalStakView.snp.makeConstraints {
            $0.height.equalTo(24)
            $0.centerX.equalTo(cameraView)
            $0.bottom.equalTo(cameraView.snp.top).offset(-16)
        }
        
        realEmojiFaceImageView.snp.makeConstraints {
            $0.width.equalTo(24)
        }

        
        cameraView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(375)
            $0.center.equalToSuperview()
        }
        
        flashButton.snp.makeConstraints {
            $0.left.equalToSuperview().offset(30)
            $0.top.equalTo(cameraView.snp.bottom).offset(48)
        }
        
        shutterButton.snp.makeConstraints {
            $0.width.height.equalTo(72)
            $0.centerY.equalTo(flashButton)
            $0.centerX.equalTo(cameraView)
        }
        
        toggleButton.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-30)
            $0.top.equalTo(cameraView.snp.bottom).offset(48)
        }
        
        cameraIndicatorView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        realEmojiCollectionView.snp.makeConstraints {
            $0.top.equalTo(shutterButton.snp.bottom).offset(28)
            $0.width.equalTo(317)
            $0.centerX.equalTo(shutterButton)
            $0.height.equalTo(60)
        }
        
    }
    
    public override func bind(reactor: CameraViewReactor) {
        
        
        Observable.just(())
            .map { Reactor.Action.viewDidLoad}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isLoading }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: false)
            .drive(cameraIndicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
        
        
        NotificationCenter.default.rx.notification(.AVCapturePhotoOutputDidFinishProcessingPhotoNotification)
            .compactMap { notification -> Data? in
                guard let userInfo = notification.userInfo else { return nil }
                return userInfo["photo"] as? Data
            }
            .debug("Notification didTapShutter Button")
            .map { Reactor.Action.didTapShutterButton($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        cameraNavigationBar.rx.didTapLeftBarButton
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .bind { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }.disposed(by: disposeBag)
        
        reactor.state
            .map { $0.cameraType == .realEmoji ? false : true }
            .distinctUntilChanged()
            .withUnretained(self)
            .bind(onNext: {$0.0.setupRealEmojiLayoutContent(isShow: $0.1)})
            .disposed(by: disposeBag)
        
        
        reactor.state
            .map { $0.cameraType }
            .map { $0 == .realEmoji ? "리얼 이모지" : "카메라" }
            .distinctUntilChanged()
            .bind(to: cameraNavigationBar.rx.navigationTitle)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$realEmojiSection)
            .asDriver(onErrorJustReturn: [])
            .drive(realEmojiCollectionView.rx.items(dataSource: realEmojiDataSources))
            .disposed(by: disposeBag)
        
        
        reactor.pulse(\.$profileMemberEntity)
            .filter { $0 != nil }
            .withUnretained(self)
            .bind { owner, _ in
                owner.dismissCameraViewController()
                let userInfo: [AnyHashable: Any] = ["isProfileUpdate": true]
                UserDefaults.standard.isDefaultProfile = false
                NotificationCenter.default.post(name: .DidFinishProfileImageUpdate, object: nil, userInfo: userInfo)
            }.disposed(by: disposeBag)
        
        
        reactor.state
            .map { ($0.accountImage, $0.profileImageURLEntity, $0.memberId)}
            .filter { $0.0 != nil }
            .withUnretained(self)
            .subscribe(onNext: { (owner, originEntity) in
                let userInfo: [AnyHashable: Any] = ["presignedURL": originEntity.1?.imageURL, "originImage": originEntity.0]
                NotificationCenter.default.post(name: .AccountViewPresignURLDismissNotification, object: nil, userInfo: userInfo)
                owner.dismissCameraViewController()
            }).disposed(by: disposeBag)
            
        
        //두가지 방법이 있음
        //selected 로 indexPath를 조회해서 EmojiType을 가져오는 방법 단 Cell Reactor에 주입할때 Emoji Type은 ImageUrl 있을때만 넣고 없으면 빈값으로 넣어서 예외 처리 해야함
        //두번째 방법은 modelSelected로 가져오는 방법
        shutterButton
            .rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .debug("shutter Button Tap")
            .withUnretained(self)
            .subscribe { owner, _ in
                let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
                owner.captureOutputStream.capturePhoto(with: settings, delegate: owner)
            }.disposed(by: disposeBag)
        
        flashButton
            .rx.tap
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .map { Reactor.Action.didTapFlashButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
                
        cameraView.rx
            .pinchGesture
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .bind(onNext: {
                guard let currentCamera = $0.0.isToggle ? $0.0.frontCamera : $0.0.backCamera else { return }
                $0.0.transitionImageScale(owner: $0.0, gesture: $0.1, camera: currentCamera)
            }).disposed(by: disposeBag)

        
        toggleButton
            .rx.tap
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .map { Reactor.Action.didTapToggleButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$isSwitchPosition)
            .withUnretained(self)
            .skip(1)
            .bind(onNext: { $0.0.transitionPreViewLayer(owner: $0.0, state: $0.1) })
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$isFlashMode)
            .skip(1)
            .withUnretained(self)
            .bind(onNext: { $0.0.setupFlashMode(owner: $0.0, isFlash: $0.1) })
            .disposed(by: disposeBag)
        
    }
}



extension CameraViewController: AVCapturePhotoCaptureDelegate {
    
    private func setupCamera() {
        captureSession = AVCaptureSession()
        captureSession.beginConfiguration()

        if captureSession.canSetSessionPreset(.photo) {
            captureSession.sessionPreset = .photo
        }
        
        if let frontDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) {
            frontCamera = frontDevice
        } else {
            //TODO: Error 문구 설정 예정
            fatalError("정면 카메라가 없습니다.")
        }
        
        if let backDevice =  AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            backCamera = backDevice
        } else {
            //TODO: Error 문구 설정 예정
            fatalError("후면 카메라가 없습니다.")
        }
        
        guard let backDeviceInput = try? AVCaptureDeviceInput(device: backCamera) else {
            //TODO: Error 문구 설정 예정
            fatalError("후면 카메라를 입력으로 설정 할 수 없습니다. ")
        }
        
        backCameraInput = backDeviceInput
        
        if !captureSession.canAddInput(backCameraInput) {
            return
        }
        
        guard let frontDeviceInput = try? AVCaptureDeviceInput(device: frontCamera) else {
            fatalError("정면 카메라를 입력으로 설정 할 수 없습니다.")
        }
        
        frontCameraInput = frontDeviceInput
        
        if !captureSession.canAddInput(frontCameraInput) {
            return
        }
        
        captureSession.addInput(backCameraInput)
    }
    
    private func setupCameraOuputStream() {
        cameraOuputStream = AVCaptureVideoDataOutput()
        
        if captureSession.canAddOutput(cameraOuputStream) {
            captureOutputStream = AVCapturePhotoOutput()
            captureSession.addOutput(captureOutputStream)
        }
        
        cameraOuputStream.connections.first?.videoOrientation = .portrait
    }
    
    private func setupPreviewLayout() {
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.connection?.videoOrientation = .portrait
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.previewLayer.frame = self.cameraView.bounds
        }
        
        cameraView.layer.addSublayer(previewLayer)
        setupPreViewLayerContent()
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            self.captureSession.startRunning()
        }
        
        captureSession.commitConfiguration()
    }
    
    private func setupCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        
        case .authorized:
            setupCamera()
            setupCameraOuputStream()
            setupPreviewLayout()
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { isPermission in
                guard isPermission else {
                    DispatchQueue.main.async {
                        self.showPermissionAlertController()
                    }
                    return
                }
            }
            setupCamera()
            setupCameraOuputStream()
            setupPreviewLayout()
        case .denied:
            //TODO: Alert 추가 예정
            print("사용자에 의해 권한이 거부된 상태 입니다.")
        default:
            break
        }
    }
    
    
    private func transitionPreViewLayer(owner: CameraViewController, state isTransition: Bool) {
        captureSession.beginConfiguration()
        if isTransition {
            UIView.transition(with: owner.cameraView, duration: 0.5, options: .transitionFlipFromLeft) {
                owner.captureSession.removeInput(owner.backCameraInput)
                owner.captureSession.addInput(owner.frontCameraInput)
                owner.isToggle = true
            }
        } else {
            UIView.transition(with: owner.cameraView, duration: 0.5, options: .transitionFlipFromLeft) {
                owner.captureSession.removeInput(owner.frontCameraInput)
                owner.captureSession.addInput(owner.backCameraInput)
                owner.isToggle = false
            }
        }
        owner.cameraOuputStream.connections.first?.isVideoMirrored = !isTransition
        owner.captureSession.commitConfiguration()
    }
    
    
    private func setupFlashMode(owner: CameraViewController, isFlash: Bool) {
        do {
            try owner.backCamera.lockForConfiguration()
            try owner.backCamera.setTorchModeOn(level: 1.0)
            
            if isFlash {
                owner.backCamera.torchMode = .on
            } else {
                owner.backCamera.torchMode = .off
            }
            owner.backCamera.unlockForConfiguration()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    public func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let photoData = photo.fileDataRepresentation(),
        let imageData = UIImage(data: photoData)?.jpegData(compressionQuality: 1.0) else { return }
        if self.reactor?.cameraType == .profile || self.reactor?.cameraType == .realEmoji {
            output.photoOutputDidFinshProcessing(photo: imageData, error: error)
        } else {
            let cameraDisplayViewController = CameraDisplayDIContainer(displayData: imageData).makeViewController()
            self.navigationController?.pushViewController(cameraDisplayViewController, animated: true)
        }
    }
    
    
    
    private func setupImageScale(owner: CameraViewController, scale: CGFloat, camera: AVCaptureDevice) {
        do {
            
            try camera.lockForConfiguration()
            camera.videoZoomFactor = scale
            
            camera.unlockForConfiguration()
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    private func dismissCameraViewController() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func transitionImageScale(owner: CameraViewController, gesture: UIPinchGestureRecognizer, camera: AVCaptureDevice) {
        
        switch gesture.state {
            
        case .began:
            owner.initialScale = camera.videoZoomFactor
            
        case .changed:
            let minAvailableZoomScale = camera.minAvailableVideoZoomFactor
            let maxAvailableZoomScale = camera.maxAvailableVideoZoomFactor
            let availableZoomScaleRange = minAvailableZoomScale...maxAvailableZoomScale
            let resolvedZoomScaleRange = zoomScaleRange.clamped(to: availableZoomScaleRange)

            let resolvedScale = max(resolvedZoomScaleRange.lowerBound, min(gesture.scale * initialScale, resolvedZoomScaleRange.upperBound))
            setupImageScale(owner: owner, scale: resolvedScale, camera: camera)
        default:
            return
            
        }
    }
    
    private func showPermissionAlertController() {
        let permissionAlertController: UIAlertController = UIAlertController(title: "카메라 접근 권한 설정이 없습니다.", message: "사진을 촬영하시려면 카메라에 접근할 수 있도록 허용되어 있어야 합니다.", preferredStyle: .alert)
        
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
    
    private func setupPreViewLayerContent() {
        cameraView.layer.addSublayer(previewLayer)
        cameraView.addSubviews(filterView, zoomView)
        filterView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        zoomView.snp.makeConstraints {
            $0.width.height.equalTo(43)
            $0.bottom.equalToSuperview().offset(-23)
            $0.centerX.equalToSuperview()
        }
    }
    
    private func setupRealEmojiLayoutContent(isShow: Bool) {
        filterView.isHidden = isShow
        realEmojiHorizontalStakView.isHidden = isShow
        realEmojiCollectionView.isHidden = isShow
    }
    
}


extension CameraViewController: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 40, height: 40)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
}
