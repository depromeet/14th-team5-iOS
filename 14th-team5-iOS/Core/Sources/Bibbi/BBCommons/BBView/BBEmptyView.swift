//
//  BBEmptyView.swift
//  Core
//
//  Created by 마경미 on 15.04.25.
//

import UIKit

import DesignSystem

final public class BBEmptyView: UIView {
    public struct Configure {
        /// full - 화면 전체를 가리며, 화면 중앙에 갈 수 있도록 설정 됨
        /// fit - 지정된 사이즈만큼만 가리며, 화면 위쪽에 갈 수 있도록 설정 됨
        public enum ViewType {
            case full
            case fit
        }
        
        /// Empty Case에 사용되는 이미지가 추가 될 경우 Asset에 추가해서 사용.
        public enum Asset {
            case emptyGraphic

            var image: UIImage {
                switch self {
                case .emptyGraphic:
                    return DesignSystemAsset.emptyCaseGraphicEmoji.image
                }
            }
        }
        
        /// Empty Case에 사용되는 이미지 사이즈 (big: 148, medium: 32, small: 24)
        public enum AssetSize {
            case big
            case medium
            case small
            
            var value: (CGFloat, CGFloat) {
                switch self {
                case .big: /// notification View
                    return (125, 115)
                case .medium:
                    return (32, 32)
                case .small:
                    return (24, 24)
                }
            }
        }
        
        let viewType: ViewType
        let asset: Asset
        let text: String?
        let assetSize: AssetSize
        
        /// default: viewType = full, asset = emptyGraphic, assetSize: big
        public init(
            viewType: ViewType = .full,
            asset: Asset = .emptyGraphic,
            assetSize: AssetSize = .big,
            text: String?
        ) {
            self.viewType = viewType
            self.asset = asset
            self.assetSize = assetSize
            self.text = text
        }
    }
    
    private let configure: Configure
    
    private let stackView: UIStackView = UIStackView()
    private let imageView: UIImageView = .init()
    private let label: BBLabel = .init(
        .body1Regular,
        textAlignment: .center,
        textColor: .gray500
    )
    
    public init(configure: Configure) {
        self.configure = configure
        super.init(frame: .zero)
        setupUI()
        setupAutoLayout()
        setupAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BBEmptyView {
    private func setupUI() {
        addSubviews(stackView)
        stackView.addArrangedSubviews(imageView, label)
    }
    
    private func setupAutoLayout() {
        switch configure.viewType {
        case .fit: setFitTypeAutoLayout()
        case .full: setFullTypeAutoLayout()
        }
    }
    
    private func setupAttributes() {
        backgroundColor = .bibbiBlack
        
        stackView.do {
            $0.axis = .vertical
            $0.spacing = 20
        }
        
        imageView.do {
            $0.image = configure.asset.image
            $0.contentMode = .scaleAspectFit
        }
        
        label.do {
            $0.numberOfLines = 0
            $0.text = configure.text
            $0.sizeToFit()
        }
    }
}

extension BBEmptyView {
    private func setFitTypeAutoLayout() {
        imageView.snp.makeConstraints {
            $0.width.equalTo(configure.assetSize.value.0)
            $0.height.equalTo(configure.assetSize.value.1)
        }

        stackView.snp.makeConstraints {
            $0.directionalVerticalEdges.equalToSuperview()
        }
    }
    
    private func setFullTypeAutoLayout() {
        if let topVC = UIApplication.topViewController() {
            let safeTop = topVC.view.safeAreaInsets.top
            let screenHeight = UIScreen.main.bounds.height
            let topOffset = (screenHeight / 2) - safeTop
            
            imageView.snp.makeConstraints {
                $0.width.equalTo(configure.assetSize.value.0)
                $0.height.equalTo(configure.assetSize.value.1)
            }

            stackView.snp.makeConstraints {
                $0.directionalHorizontalEdges.equalToSuperview()
                $0.centerY.equalToSuperview().offset(-safeTop)
            }
        }
    }
}
