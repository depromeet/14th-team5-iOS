//
//  PopOverView.swift
//  Core
//
//  Created by 마경미 on 29.12.23.
//

import UIKit

import Core
import DesignSystem

import RxCocoa
import RxSwift

final class BalloonView: BaseView<BalloonReactor> {
    private let containerView: UIView = UIView()
    private let polygonImageView: UIImageView = UIImageView()
    private let stackView: UIStackView = UIStackView()
    private let textLabel: UILabel = BBLabel(.body2Regular)
    
    let balloonTypeRelay: BehaviorRelay<BalloonType> = BehaviorRelay(value: .normal)
    
    public var text: Binder<String?> {
        return textLabel.rx.text
    }
    
    override func bind(reactor: BalloonReactor) {
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    override func setupUI() {
        addSubviews(containerView, polygonImageView)
        containerView.addSubviews(stackView, textLabel)
    }
    
    override func setupAutoLayout() {
        containerView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().inset(12)
            $0.height.equalTo(40)
        }
        
        polygonImageView.snp.makeConstraints {
            $0.top.equalTo(containerView.snp.bottom)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(15)
            $0.height.equalTo(12)
        }
        
        stackView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.width.equalTo(0)
            $0.height.equalTo(24)
            $0.centerY.equalToSuperview()
        }
        
        textLabel.snp.makeConstraints {
            $0.leading.equalTo(stackView.snp.trailing)
            $0.trailing.equalToSuperview().inset(16)
            $0.verticalEdges.equalToSuperview().inset(10)
        }
    }
    
    override func setupAttributes() {
        backgroundColor = UIColor.clear
        
        containerView.do {
            $0.backgroundColor = DesignSystemAsset.gray700.color
            $0.layer.cornerRadius = 12
        }
        
        polygonImageView.do {
            $0.backgroundColor = .clear
        }
        
        stackView.do {
            $0.spacing = -8
            $0.distribution = .fillEqually
        }
        
        textLabel.do {
            $0.textColor = .white
            $0.textAlignment = .center
            $0.numberOfLines = 0
        }
    }
}

extension BalloonView {
    private func bindInput(reactor: BalloonReactor) {
        balloonTypeRelay.map { Reactor.Action.setType($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: BalloonReactor) {
        reactor.state.map { $0.type }
            .distinctUntilChanged()
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .bind(onNext: {
                $0.0.setBalloonView($0.1)
            })
            .disposed(by: disposeBag)
    }
    
    private func setBalloonView(_ type: BalloonType) {
        if case .picks(let pickers) = type {
            containerView.backgroundColor = .mainYellow
            polygonImageView.image = DesignSystemAsset.polygonYellow.image
            textLabel.textColor = .bibbiBlack
            
            stackView.snp.updateConstraints {
                $0.width.equalTo(pickers.count <= 1 ? 24 : 20 * pickers.count)
            }
            
            textLabel.snp.updateConstraints {
                $0.leading.equalTo(stackView.snp.trailing).offset(6)
            }
            
            pickers.forEach {
                if let url = $0.imageUrl {
                    makeImageView(url: url)
                } else {
                    makeLabel(name: $0.displayName)
                }
                
            }
        } else {
            containerView.backgroundColor = .gray700
            polygonImageView.image = DesignSystemAsset.polygonGray.image
            textLabel.textColor = .white
            
            stackView.snp.updateConstraints {
                $0.width.equalTo(0)
            }
            
            textLabel.snp.updateConstraints {
                $0.leading.equalTo(stackView.snp.trailing).offset(0)
            }
            
            stackView.removeAllArrangedSubviews()
        }
    }
    
    private func makeImageView(url: String) {
        let imageView = UIImageView(frame: .init(x: 0, y: 0, width: 20, height: 20))
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderColor = UIColor.mainYellow.cgColor
        imageView.layer.borderWidth = 2
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.kf.setImage(with: URL(string: url))
        stackView.addArrangedSubview(imageView)
    }
    
    private func makeLabel(name: String){
        let label = BBLabel(.caption2, textAlignment: .center, textColor: .gray200)
        label.backgroundColor = .gray800
        label.layer.borderWidth = 2
        label.layer.borderColor = UIColor.mainYellow.cgColor
        label.clipsToBounds = true
        label.layer.cornerRadius = 12
        label.text = "\(name.first ?? "알")"
        stackView.addArrangedSubview(label)
    }
}
