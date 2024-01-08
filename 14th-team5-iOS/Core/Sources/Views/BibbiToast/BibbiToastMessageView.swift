//
//  AllFamilyUploadedView.swift
//  App
//
//  Created by 김건우 on 1/3/24.
//

import DesignSystem
import UIKit

import Then

final public class BibbiToastMessageView: UIView {
    // MARK: - Views
    private let containerView: UIView = UIView()
    
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
    
    public var width: CGFloat {
        didSet {
            containerView.snp.updateConstraints {
                $0.width.equalTo(width)
            }
        }
    }
    
    public var height: CGFloat {
        didSet {
            containerView.snp.updateConstraints {
                $0.height.equalTo(height)
            }
        }
    }
    
    public var containerColor: UIColor? {
        didSet {
            containerView.backgroundColor = backgroundColor
        }
    }
    
    // MARK: - Intializer
    public init(
        text: String,
        image: UIImage? = nil,
        containerColor: UIColor = .gray900,
        width: CGFloat = 300,
        height: CGFloat = 56
    ) {
        self.text = text
        self.image = image
        self.containerColor = containerColor
        self.width = width
        self.height = height
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
        addSubview(containerView)
        stackView.addArrangedSubviews(
            imageView, textLabel
        )
        containerView.addSubview(stackView)
    }
    
    private func setupAutoLayout() {
        containerView.snp.makeConstraints {
            $0.width.equalTo(width)
            $0.height.equalTo(height)
            $0.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(16.0)
            $0.centerY.equalTo(containerView.snp.centerY)
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
            $0.spacing = 5.0
            $0.alignment = .fill
            $0.distribution = .fillProportionally
        }
        
        containerView.do {
            $0.backgroundColor = containerColor
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = 28.0
        }
    }
}
