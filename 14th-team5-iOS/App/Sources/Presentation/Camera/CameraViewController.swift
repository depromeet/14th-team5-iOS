//
//  CameraViewController.swift
//  App
//
//  Created by Kim dohyun on 12/6/23.
//

import AVFoundation
import UIKit

import Core
import DesignSystem
import ReactorKit
import RxSwift
import RxCocoa
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
    private let shutterButton: UIButton = UIButton()
    private let flashButton: UIButton = UIButton.createCircleButton(radius: 24)
    private let toggleButton: UIButton = UIButton.createCircleButton(radius: 24)
    private let titleView: UILabel = UILabel()
    
    
    private var initialScale: CGFloat = 0
    private var zoomScaleRange: ClosedRange<CGFloat> = 1...10
    
    //MARK: LifeCylce
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupCameraPermission()
    }
    
    //MARK: Configure
    public override func setupUI() {
        super.setupUI()
        view.addSubviews(cameraView, shutterButton, flashButton, toggleButton)
    }
    
    public override func setupAttributes() {
        super.setupAttributes()
        
        titleView.do {
            $0.textColor = .white
            $0.text = "카메라"
        }
        
        navigationItem.do {
            $0.titleView = titleView
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
        
    }
    
    public override func bind(reactor: CameraViewReactor) {
        shutterButton
            .rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
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
            .panGesture
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .bind(onNext: {
                if AVCaptureDevice.Position.back == $0.0.backCamera.position {
                    print("test")
                } else {
                    print("front")
                }
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
                        //TODO: Alert 추가 예정
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
            }
        } else {
            UIView.transition(with: owner.cameraView, duration: 0.5, options: .transitionFlipFromLeft) {
                owner.captureSession.removeInput(owner.frontCameraInput)
                owner.captureSession.addInput(owner.backCameraInput)
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
        guard let originalData = photo.fileDataRepresentation() else { return }

        let cameraDisplayViewController = CameraDisplayDIContainer(displayData: originalData).makeViewController()
        self.navigationController?.pushViewController(cameraDisplayViewController, animated: true)
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
    
}
