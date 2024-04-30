//
//  PopOverView.swift
//  Core
//
//  Created by 마경미 on 29.12.23.
//

import UIKit

import DesignSystem

import RxSwift

public class BalloonView: UIView {
    private let containerView: UIView = UIView()
    private let textLabel: UILabel = BibbiLabel(.body2Regular)
    
    public var text: Binder<String?> {
        return textLabel.rx.text
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setAutoLayout()
        setAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
          addSubview(containerView)
        containerView.addSubview(textLabel)
      }
    
    private func setAutoLayout() {
        containerView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().inset(12)
            $0.height.equalTo(40)
        }
        
        textLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.verticalEdges.equalToSuperview().inset(10)
        }
    }
    
    private func setAttributes() {
        backgroundColor = UIColor.clear
        
        containerView.do {
            $0.backgroundColor = DesignSystemAsset.gray700.color
            $0.layer.cornerRadius = 12
        }
        
        textLabel.do {
            $0.textColor = .white
            $0.textAlignment = .center
            $0.numberOfLines = 0
        }
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let tipLeft = rect.origin.x + (rect.size.width / 2.0) - 6
        let tipBottom = CGPoint(x: rect.origin.x + (rect.size.width / 2.0), y: rect.size.height)
        let heightWithoutTip = 40

        // path 객체로 선분을 잇는 작업
        let path = UIBezierPath()
        path.move(to: CGPoint(x: tipLeft, y: 40))
        path.addLine(to: CGPoint(x: tipBottom.x, y: tipBottom.y))
        path.addLine(to: CGPoint(x: Int(tipLeft) + 12, y: heightWithoutTip))
        path.close()

        // 만든 path 객체를 이용하여 shapeLayer로 색칠, layer.addSublayer에 사용
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = DesignSystemAsset.gray700.color.cgColor
        layer.addSublayer(shapeLayer)

    }
}
