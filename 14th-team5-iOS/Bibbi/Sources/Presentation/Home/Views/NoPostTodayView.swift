//
//  NoPostTodayView.swift
//  App
//
//  Created by 마경미 on 18.12.23.
//

import UIKit

import Domain
import DesignSystem

import SnapKit
import Then

final class NoPostTodayView: UIView {
    typealias Layout = HomeAutoLayout.NoPostTodayView
    
    let type: PostType
    private let imageView: UIImageView = UIImageView()
    
    init(type: PostType, frame: CGRect) {
        self.type = type
        super.init(frame: frame)
        setupUI()
        setupAutoLayout()
        setupAttributes()
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
            $0.top.equalToSuperview().inset(12)
        }
    }
    
    private func setupAttributes() {
        imageView.do {
            $0.image = type == .survival ? DesignSystemAsset.emptyCaseGraphicEmoji.image: DesignSystemAsset.missionEmptyCase.image
            $0.contentMode = .scaleAspectFill
        }
    }
}
