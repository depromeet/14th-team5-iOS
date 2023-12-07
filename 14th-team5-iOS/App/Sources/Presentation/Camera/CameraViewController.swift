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
}
