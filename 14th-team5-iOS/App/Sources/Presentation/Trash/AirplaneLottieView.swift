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

public class AirplaneLottieView: UIView {
    // MARK: - Views
    private let lottieStack: UIStackView = UIStackView()
    private let lottieView: LottieView = LottieView(with: .loading)
    private let loadingLabel: BBLabel = BBLabel(.body1Regular, textAlignment: .center, textColor: .gray500)
    
    // MARK: - Properties
    public var lottieSize: CGFloat = 80 {
        didSet {
            lottieView.snp.updateConstraints {
                $0.size.equalTo(lottieSize)
            }
        }
    }
    
    public var loadingText: String? = "열심히 불러오는 중" {
        didSet {
            loadingLabel.text = loadingText
        }
    }
    
    // MARK: - Intializer
    public override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
        setupAutoLayout()
        setupAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    private func setupUI() {
        lottieStack.addArrangedSubviews(lottieView, loadingLabel)
        addSubviews(lottieStack)
    }
    
    private func setupAutoLayout() {
        lottieStack.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.center.equalToSuperview()
        }
        
        lottieView.snp.makeConstraints {
            $0.size.equalTo(lottieSize)
        }
    }
    
    private func setupAttributes() {
        lottieStack.do {
            $0.axis = .vertical
            $0.spacing = 12
            $0.alignment = .fill
            $0.distribution = .fillProportionally
        }
        
        loadingLabel.do {
            $0.text = loadingText
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

