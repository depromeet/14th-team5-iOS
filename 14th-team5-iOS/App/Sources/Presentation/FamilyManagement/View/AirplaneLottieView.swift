//
//  AirplaneLottieView.swift
//  App
//
//  Created by 김건우 on 1/30/24.
//


import Core
import DesignSystem
import UIKit

import Then
import SnapKit

final class AirplaneLottieView: UIView {
    // MARK: - Views
    private let lottieStack: UIStackView = UIStackView()
    private let lottieView: LottieView = LottieView(kind: .loading)
    private let loadingLabel: BibbiLabel = BibbiLabel(.body1Regular, alignment: .center, textColor: .gray500)
    
    // MARK: - Intializer
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
        setupAutoLayout()
        setupAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    func setupUI() {
        lottieStack.addArrangedSubviews(lottieView, loadingLabel)
        addSubviews(lottieStack)
    }
    
    func setupAutoLayout() {
        lottieStack.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        
        lottieView.snp.makeConstraints {
            $0.size.equalTo(100)
        }
    }
    
    func setupAttributes() {
        lottieStack.do {
            $0.axis = .vertical
            $0.spacing = 12
            $0.alignment = .fill
            $0.distribution = .fillProportionally
        }
        
        loadingLabel.do {
            $0.text = "열심히 불러오는 중"
        }
    }
    
    public override var isHidden: Bool {
        didSet {
            if self.isHidden {
                lottieView.stop()
            } else {
                lottieView.play()
            }
        }
    }
}

