//
//  CameraDisplayViewController.swift
//  App
//
//  Created by Kim dohyun on 12/11/23.
//

import UIKit

import Core
import DesignSystem
import SnapKit


public final class CameraDisplayViewController: BaseViewController<CameraDisplayViewReactor> {
    //MARK: Views
    private let displayView: UIImageView = UIImageView()
    private let confirmButton: UIButton = UIButton.createCircleButton(radius: 36)
    
    
    //MARK: LifeCylce
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: Configure
    public override func setupUI() {
        super.setupUI()
        view.addSubviews(displayView, confirmButton)
    }
    
    public override func setupAttributes() {
        super.setupAttributes()
        displayView.do {
            $0.layer.cornerRadius = 40
            $0.clipsToBounds = true
        }
        
        confirmButton.do {
            $0.backgroundColor = .white
            $0.setImage(DesignSystemAsset.confirm.image, for: .normal)
            
        }
    }
    
    public override func setupAutoLayout() {
        super.setupAutoLayout()
        
        displayView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(375)
            $0.center.equalToSuperview()
        }
        
        confirmButton.snp.makeConstraints {
            $0.top.equalTo(displayView.snp.bottom).offset(36)
            $0.centerX.equalTo(displayView)
        }
    }
    
}
