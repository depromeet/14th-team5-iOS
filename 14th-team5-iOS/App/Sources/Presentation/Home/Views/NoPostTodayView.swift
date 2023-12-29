//
//  NoPostTodayView.swift
//  App
//
//  Created by 마경미 on 18.12.23.
//

import UIKit
import DesignSystem

import SnapKit
import Then

final class NoPostTodayView: UIView {
    typealias Layout = HomeAutoLayout.NoPostTodayView
    
    private let imageView: UIImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(imageView)
    }
    
    private func setupAutoLayout() {
        imageView.snp.makeConstraints {
            $0.size.equalTo(Layout.ImageView.size)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(Layout.ImageView.topInset)
        }
    }
    
    private func setupAttributes() {
        imageView.do {
            $0.image = DesignSystemAsset.emptyCaseGraphicEmoji.image
        }
    }
}
