//
//  BlueAiraplaneLottieView.swift
//  App
//
//  Created by 김건우 on 2/14/24.
//

import Core
import DesignSystem
import UIKit

import Then
import SnapKit

final public class BlurAiraplaneLottieView: UIView {
    
    // MARK: - Views
    
    private let blurContainerView: UIView = UIView()

    private let lottieStack: UIStackView = UIStackView()
    private let lottieView: LottieView = LottieView(with: .loading)
    private let loadingLabel: BBLabel = BBLabel(.body1Regular, textAlignment: .center, textColor: .gray500)
    
    
    // MARK: - Properties
    
    public var containerSize: CGFloat = 125 {
        didSet {
            blurContainerView.snp.updateConstraints {
                $0.size.equalTo(containerSize)
            }
        }
    }
    
    public var blurColor: UIColor = UIColor.gray500 {
        didSet {
            blurContainerView.backgroundColor = blurColor
        }
    }
    
    public var lottieSize: CGFloat = 60 {
        didSet {
            lottieView.snp.updateConstraints {
                $0.size.equalTo(lottieSize)
            }
        }
    }
    
    public var loadingText: String? = "불러오는 중" {
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
        blurContainerView.addSubview(lottieStack)
        addSubview(blurContainerView)
    }
    
    private func setupAutoLayout() {
        blurContainerView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.size.equalTo(containerSize)
        }
        
        lottieStack.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.center.equalToSuperview()
        }
        
        lottieView.snp.makeConstraints {
            $0.size.equalTo(lottieSize)
        }
    }
    
    private func setupAttributes() {
        blurContainerView.do {
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = 22.5
            $0.backgroundColor = UIColor.gray800
        }
        
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
