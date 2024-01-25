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

final public class BibbiToastMessageView: UIView {
    // MARK: - Views
    private let capsuleView: UIView = UIView()
    
    private let stackView: UIStackView = UIStackView()
    private let textLabel: BibbiLabel = BibbiLabel(.body1Regular, alignment: .center, textColor: .bibbiWhite)
    private let imageView: UIImageView = UIImageView()
    
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
    
    // MARK: - Intializer
    public init(
        text: String,
        image: UIImage? = nil
    ) {
        self.text = text
        self.image = image
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
        stackView.addArrangedSubviews(imageView, textLabel)
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
        }
        
        capsuleView.do {
            $0.backgroundColor = UIColor.gray900
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = 28
        }
        
//        containerView.do {
//            $0.isUserInteractionEnabled = true
//            $0.backgroundColor = UIColor.clear
//        }
    }
}
