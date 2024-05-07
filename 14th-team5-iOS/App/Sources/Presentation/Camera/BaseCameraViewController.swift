//
//  BaseCameraViewController.swift
//  App
//
//  Created by Kim dohyun on 5/6/24.
//

import UIKit
import AVFoundation

import Then
import SnapKit
import Core
import RxSwift
import RxCocoa
import DesignSystem


//MARK: Input
final class CameraConfigurationBuilder {
    fileprivate let mediaType: AVMediaType = .video
    fileprivate let position: AVCaptureDevice.Position = .front
    fileprivate let sessionPreset: AVCaptureSession.Preset = .photo
    fileprivate var deviceTypes :[AVCaptureDevice.DeviceType] = []
    fileprivate var torchMode: AVCaptureDevice.TorchMode = .auto
    fileprivate var captureSession: AVCaptureSession!
    fileprivate var backCameraInput: AVCaptureDeviceInput!
    fileprivate var frontCameraInput: AVCaptureDeviceInput!
    fileprivate var frontCamera: AVCaptureDevice!
    fileprivate var backCamera: AVCaptureDevice!
    fileprivate var cameraOuputStream: AVCaptureVideoDataOutput!
    fileprivate var captureOutputStream: AVCapturePhotoOutput!
    
    fileprivate var videoGravity: AVLayerVideoGravity = .resizeAspectFill
    
    
    //TODO: AVCaptureDevice Front Back 인스턴스 값이 필요 즉 setMethod 있으면 좋을듯
    
    
    fileprivate func build() {
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo
        
        setDeviceInput(position: .back)
        
        cameraOuputStream = AVCaptureVideoDataOutput()
        cameraOuputStream.connections.first?.videoOrientation = .portrait
        
    }
    
    fileprivate func setPreviewLayer() -> AVCaptureVideoPreviewLayer {
        let preViewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        preViewLayer.videoGravity = videoGravity
        
        return preViewLayer
    }

    fileprivate func running() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            self.captureSession.startRunning()
        }
    }
        
    private func setDevice(position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        if #available(iOS 11.0, *) {
            deviceTypes = [.builtInTrueDepthCamera, .builtInDualCamera, .builtInWideAngleCamera]
        } else {
            deviceTypes = [.builtInDualCamera , .builtInWideAngleCamera]
        }
        
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: deviceTypes, mediaType: mediaType, position: .unspecified)
        
        let devices = discoverySession.devices
        guard !devices.isEmpty else { fatalError("카메라 장치가 없습니다.") }
          
        return devices.first(where: { device in device.position == position })
    }
    
    fileprivate func setAuthorization(completion: @escaping(AVAuthorizationStatus) -> ()) {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            completion(status)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { isPermission in
                guard isPermission else {
                    DispatchQueue.main.async {
                        print("test Authorization Notdetern")
                        completion(status)
                    }
                    return
                }
            }
        case .denied:
            completion(status)
        default:
            break
        }
    }
    
    fileprivate func setPrewView(isSwap: Bool) {
        captureSession.beginConfiguration()
        if isSwap {
            captureSession.removeInput(backCameraInput)
            
            captureSession.addInput(frontCameraInput)
        }
        
        captureSession.connections.first?.isVideoMirrored = !isSwap
        captureSession.commitConfiguration()
    }
    
    private func setDeviceInput(position: AVCaptureDevice.Position) {
        //1. AVCaptureDevice 생성함
        
        guard let cameraDevice = setDevice(position: position) else { fatalError("카메라가 없습니다.") }
        captureOutputStream = AVCapturePhotoOutput()
        
        //2. Position에 따라 AVCaptureDeviceInput을 생성함
        switch position {
        case .back:
            guard let backCameraDeviceInput = try? AVCaptureDeviceInput(device: cameraDevice) else { fatalError("후면 카메라를 입력으로 설정 할 수 없습니다.")}
            backCameraInput = backCameraDeviceInput
            captureSession.addInput(backCameraInput)
            captureSession.addOutput(captureOutputStream)
        case .front:
            guard let frontCameraDeviceInput = try? AVCaptureDeviceInput(device: cameraDevice) else { fatalError("정면 카메라를 입력으로 설정 할 수 없습니다.")}
            frontCameraInput = frontCameraDeviceInput
            captureSession.addInput(frontCameraDeviceInput)
            captureSession.addOutput(captureOutputStream)
        default:
            break
        }
        
    }
    
    fileprivate func setFlashMode(isFlash: Bool) {
        do {
            if backCamera.hasTorch {
                try backCamera.lockForConfiguration()
                try backCamera.setTorchModeOn(level: 1.0)
                
                if isFlash {
                    backCamera.torchMode = .on
                } else {
                    backCamera.torchMode = .off
                }
                backCamera.unlockForConfiguration()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
}


final class BaseCameraViewController: UIViewController {
    //MARK: Proeprty
    fileprivate var previewLayer: AVCaptureVideoPreviewLayer!
    fileprivate var cameraBuilder: CameraConfigurationBuilder = CameraConfigurationBuilder()
    
    private let flashButton: UIButton = UIButton.createCircleButton(radius: 24)
    private let toggleButton: UIButton = UIButton.createCircleButton(radius: 24)
    private let zoomView: UIButton = UIButton()
    private let shutterButton: UIButton = UIButton()
    private let cameraView: UIView = UIView()
    private let disposeBag: DisposeBag = DisposeBag()
    
    private var isSwap: Bool = false {
        didSet {
            UIView.transition(with: cameraView, duration: 0.5, options: .transitionFlipFromLeft) { [weak self] in
                guard let self = self else { return }
                self.cameraBuilder.setPrewView(isSwap: isSwap)
            }
        }
    }
    
    private var isFlashMode: Bool = false {
        didSet {
            cameraBuilder.setFlashMode(isFlash: isFlashMode)
        }
    }
    

        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupAutoLayout()
        setupAttributeds()
        build()
        
        bindAction()
    }
    
    private func setupUI() {
        view.addSubviews(cameraView, toggleButton, flashButton, shutterButton)
        cameraView.addSubview(zoomView)
    }
    
    private func setupAutoLayout() {
        cameraView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(cameraView.snp.width).multipliedBy(1.0)
            $0.center.equalToSuperview()
        }
        
        toggleButton.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-30)
            $0.top.equalTo(cameraView.snp.bottom).offset(48)
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
        
        zoomView.snp.makeConstraints {
            $0.width.height.equalTo(43)
            $0.bottom.equalToSuperview().offset(-23)
            $0.centerX.equalToSuperview()
        }
        
    }
    
    private func setupAttributeds() {
        cameraView.do {
            $0.layer.cornerRadius = 40
            $0.clipsToBounds = true
        }
        
        toggleButton.do {
            $0.setImage(DesignSystemAsset.toggle.image, for: .normal)
            $0.backgroundColor = .darkGray
        }
        
        flashButton.do {
            $0.setImage(DesignSystemAsset.flash.image, for: .normal)
            $0.backgroundColor = .darkGray
        }
        
        shutterButton.do {
            $0.setImage(DesignSystemAsset.shutter.image, for: .normal)
        }
        
        zoomView.do {
            $0.setBackgroundImage(DesignSystemAsset.zoomin.image, for: .normal)
            $0.setTitle("", for: .normal)
        }
    }
    
    private func build() {
        cameraBuilder.setAuthorization { [weak self] status in
            guard let self = self else { return }
            switch status {
            case .notDetermined:
                self.showAuthorizationAlertController()
            case .denied:
                self.showAuthorizationAlertController()
            case .authorized:
                self.cameraBuilder.build()
                self.previewLayer = self.cameraBuilder.setPreviewLayer()
                self.cameraView.layer.addSublayer(self.previewLayer)
                self.cameraView.bringSubviewToFront(zoomView)
                
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    //이부분을 ViewController가 책임을 질까 Builder가 책임을 질까 고민
                    self.previewLayer.frame = self.cameraView.bounds
                }
                
                self.cameraBuilder.running()
            default:
                break
            }
        }
    }
    
    
    private func showAuthorizationAlertController()  {
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
    
    
    private func bindAction() {
        toggleButton
            .rx.tap
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .scan(false) { lastState, _ in !lastState }
            .bind(to: self.rx.isSwap)
            .disposed(by: disposeBag)
        
        flashButton
            .rx.tap
            .throttle(.microseconds(300), scheduler: MainScheduler.instance)
            .scan(false) { lastState, _ in !lastState }
            .bind(to: self.rx.isFlashMode)
            .disposed(by: disposeBag)
    }
}


//print("cameraBuilder.mediaType : \(cameraBuilder.mediaType)")
//print("camera Build Method: \(cameraBuilder.build()) or \(cameraBuilder.captureSession) and \(cameraBuilder.frontCamera) back \(cameraBuilder.backCamera)")
