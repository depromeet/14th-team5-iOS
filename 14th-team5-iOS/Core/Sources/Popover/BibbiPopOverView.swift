//
//  BibbiPopOverView.swift
//  Core
//
//  Created by Kim dohyun on 12/19/23.
//

import UIKit

import SnapKit
import Then


public class BibbiPopOverView: UIView {
    //MARK: Views
    public let descrptionLabel: UILabel = UILabel()
    public let descrptionImageView: UIImageView = UIImageView()
    private let descrptionTitle: String
    private let descrptionImage: UIImage
    private let textColor: UIColor
    private let textFont: UIFont
    private let radius: CGFloat
    
    public var isAnimation: Bool = false {
        didSet {
            fadeInOutTranstion(isAnimation)
        }
    }
    
    
    public init(
        descrptionTitle: String,
        descrptionImage: UIImage,
        textColor: UIColor = .white,
        textFont: UIFont = .systemFont(ofSize: 16, weight: .regular),
        radius: CGFloat = 0.0
    ) {
        self.descrptionTitle = descrptionTitle
        self.descrptionImage = descrptionImage
        self.textColor = textColor
        self.textFont = textFont
        self.radius = radius
        super.init(frame: .zero)
        setupUI()
        setupAttributes()
        setupAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: Configure
    public func setupUI() {
        [descrptionLabel,descrptionImageView].forEach(addSubview(_:))
    }
    
    public func setupAttributes() {
        self.do {
            $0.layer.cornerRadius = radius
            $0.clipsToBounds = true
        }
        
        descrptionImageView.do {
            $0.image = descrptionImage
            $0.contentMode = .scaleToFill
        }
        
        descrptionLabel.do {
            $0.text = descrptionTitle
            $0.textColor = textColor
            $0.font = textFont
            $0.numberOfLines = 1
            $0.textAlignment = .center
        }
        
    }
    
    public func setupAutoLayout() {
        descrptionImageView.snp.makeConstraints {
            $0.width.height.equalTo(24)
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
        }
        
        descrptionLabel.snp.makeConstraints {
            $0.left.equalTo(descrptionImageView.snp.right).offset(8)
            $0.height.equalTo(24)
            $0.centerY.equalTo(descrptionImageView)
        }
        
    }
    
    
    public func fadeInOutTranstion(_ isAnimation: Bool) {
        if isAnimation {
            print("check Animation")
            UIView.animate(withDuration: 2.0, delay: 0.1, options: .curveEaseInOut) {
                self.alpha = 1.0
            } completion: { _ in
                self.alpha = 0.0
            }
        }
    }
    
    
}


