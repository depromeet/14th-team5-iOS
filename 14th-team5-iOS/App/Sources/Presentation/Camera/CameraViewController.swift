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
import Then

public final class CameraViewController: BaseViewController<CameraViewReactor> {
    fileprivate var captureSession: AVCaptureSession!
    fileprivate var previewLayer: AVCaptureVideoPreviewLayer!
    fileprivate var backCamera: AVCaptureDevice!
    fileprivate var frontCamera: AVCaptureDevice!
    fileprivate var backCameraInput: AVCaptureDeviceInput!
    fileprivate var frontCameraInput: AVCaptureDeviceInput!
    fileprivate var cameraOuputStream: AVCaptureVideoDataOutput!
    fileprivate var captureOutputStream: AVCapturePhotoOutput!
    
    
    private let cameraView: UIView = UIView().then {
        $0.layer.cornerRadius = 40
        $0.clipsToBounds = true
    }
    
    private let shutterButton: UIButton = UIButton().then {
        $0.setImage(DesignSystemAsset.shutter.image, for: .normal)
    }
    
    private let flashButton: UIButton = UIButton.createCircleButton(radius: 24).then {
        $0.setImage(DesignSystemAsset.flash.image, for: .normal)
        $0.backgroundColor = .darkGray
    }
    
    private let toggleButton: UIButton = UIButton.createCircleButton(radius: 24).then {
        $0.setImage(DesignSystemAsset.toggle.image, for: .normal)
        $0.backgroundColor = .darkGray
    }
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupCameraPermission()
    }
    
    
    public override func setupUI() {
        super.setupUI()
        view.addSubviews(cameraView, shutterButton, flashButton, toggleButton)
    }
    
    public override func setupAttributes() {
        super.setupAttributes()
        view.backgroundColor = .black
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
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .bind { owner, _ in
                let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
                owner.captureOutputStream.capturePhoto(with: settings, delegate: owner)
            }.disposed(by: disposeBag)
        
        flashButton
            .rx.tap
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .map { Reactor.Action.didTapFlashButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        
        toggleButton
            .rx.tap
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .map { Reactor.Action.didTapToggleButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        
        reactor.pulse(\.$isSwitchPosition)
            .withUnretained(self)
            .skip(1)
            .bind { owner, isPosition in
                owner.captureSession.beginConfiguration()
                if isPosition {
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
                owner.cameraOuputStream.connections.first?.isVideoMirrored = !isPosition
                owner.captureSession.commitConfiguration()
            }.disposed(by: disposeBag)
        
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
            guard let `self` = self else { return }
            self.previewLayer.frame = self.cameraView.bounds
        }
        cameraView.layer.addSublayer(previewLayer)
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let `self` = self else { return }
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
    
    
    public func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let originalData = photo.fileDataRepresentation() else { return }
        
    }
}
