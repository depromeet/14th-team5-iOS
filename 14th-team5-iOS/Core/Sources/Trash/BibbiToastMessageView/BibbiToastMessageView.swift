//
//  AllFamilyUploadedView.swift
//  App
//
//  Created by 김건우 on 1/3/24.
//

import DesignSystem
import UIKit

import SnapKit
import Then

@available(*, deprecated)
final public class BibbiToastMessageView: UIView {
    // MARK: - Views
    private let capsuleView: UIView = UIView()
    
    private let stackView: UIStackView = UIStackView()
    private let textLabel: BBLabel = BBLabel(.body1Regular, textAlignment: .center, textColor: .bibbiWhite)
    private let imageView: UIImageView = UIImageView()
    private let transtionButton: UIButton = UIButton()
    
    // MARK: - Properteis
    public var text: String {
        didSet {
            textLabel.text = text
        }
    }
    
    public var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
    
    private var transtionText: String
    
    // MARK: - Intializer
    public init(
        transtionText: String,
        text: String,
        image: UIImage? = nil
    ) {
        self.transtionText = transtionText
        self.text = text
        self.image = image
        print("transtion Text: \(transtionText) or \(self.transtionText)")
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
        addSubview(capsuleView)
        capsuleView.addSubview(stackView)
        if !transtionText.isEmpty {
            stackView.addArrangedSubviews(imageView, textLabel ,transtionButton)
        } else {
            stackView.addArrangedSubviews(imageView, textLabel)
        }
    }
    
    private func setupAutoLayout() {
        capsuleView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.leading.equalTo(stackView.snp.leading).offset(-16)
            $0.trailing.equalTo(stackView.snp.trailing).offset(16)
            $0.centerX.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
        }
    }
    
    private func setupAttributes() {
        textLabel.do {
            $0.text = text
        }
        
        imageView.do {
            $0.image = image
            $0.contentMode = .scaleAspectFit
        }
        
        stackView.do {
            $0.axis = .horizontal
            $0.spacing = 5
            $0.alignment = .fill
            $0.distribution = .fillProportionally
            $0.isUserInteractionEnabled = true
        }
        
        capsuleView.do {
            $0.backgroundColor = UIColor.gray900
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = 28
        }
        
        transtionButton.do {
            $0.configuration = .plain()
            $0.configuration?.attributedTitle = AttributedString(NSAttributedString(string: transtionText, attributes: [
                .foregroundColor: DesignSystemAsset.mainYellow.color,
                .font: DesignSystemFontFamily.Pretendard.regular.font(size: 16),
                .underlineStyle: NSUnderlineStyle.single.rawValue,
                .underlineColor: DesignSystemAsset.mainYellow.color,
                .kern: -0.3
            ]))
            $0.configuration?.baseBackgroundColor = .clear
            $0.configuration?.imagePlacement = .trailing
            $0.configuration?.image = DesignSystemAsset.arrowYellowRight.image
            $0.addTarget(self, action: #selector(didTapTranstionButton), for: .touchUpInside)
        }
        
        
//        containerView.do {
//            $0.isUserInteractionEnabled = true
//            $0.backgroundColor = UIColor.clear
//        }
    }
    
    @objc
    private func didTapTranstionButton() {
        NotificationCenter.default.post(name: .didTapBibbiToastTranstionButton, object: nil, userInfo: nil)
    }
}
