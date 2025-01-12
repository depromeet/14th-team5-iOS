//
//  MakeNewFamilyView.swift
//  App
//
//  Created by geonhui Yu on 2/8/24.
//

import UIKit
import Core
import DesignSystem

final class MakeNewFamilyView: UIView {
    private let imageView = UIImageView()
    private let titleLabel = BBLabel(.body2Regular)
    private let captionLabel = BBLabel(.head2Bold)
    private let labelStack = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupAutoLayout()
        setupAttributes()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        addStroke()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        labelStack.addArrangedSubviews(titleLabel, captionLabel)
        addSubviews(imageView, labelStack)
    }
    
    private func setupAutoLayout() {
        imageView.snp.makeConstraints {
            $0.size.equalTo(29)
            $0.leading.equalToSuperview().offset(25)
            $0.centerY.equalToSuperview()
        }
        
        labelStack.snp.makeConstraints {
            $0.centerY.equalTo(imageView)
            $0.leading.equalTo(imageView.snp.trailing).offset(22)
        }
    }
    
    private func setupAttributes() {
        layer.cornerRadius = 16
        backgroundColor = .clear
        
        titleLabel.do {
            $0.text = "초대 받은 가족이 없다면"
        }
        
        captionLabel.do {
            $0.text = "새 가족 방 만들기"
        }
        
        imageView.do {
            $0.image = DesignSystemAsset.plus.image
        }
        
        labelStack.do {
            $0.axis = .vertical
            $0.spacing = 8
            $0.alignment = .fill
            $0.distribution = .fillProportionally
        }
    }
    
    private func addStroke() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 16).cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.gray600.cgColor
        shapeLayer.lineWidth = 2.0
        shapeLayer.lineCap = .butt
        shapeLayer.lineJoin = .miter
        shapeLayer.lineDashPattern = [10, 4]
        
        layer.addSublayer(shapeLayer)
    }
}
