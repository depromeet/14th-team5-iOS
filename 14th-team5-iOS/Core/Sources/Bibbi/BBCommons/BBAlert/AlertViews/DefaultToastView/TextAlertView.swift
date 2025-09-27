//
//  TextAlertView.swift
//  BBAlert
//
//  Created by 김건우 on 8/6/24.
//

import UIKit

import SnapKit



public class TextLinkAlertView: UIStackView, BBAlertStackView {
    private let titleLabel = BBLabel(textAlignment: .center)
    private let subtitleLabel = BBLabel(textAlignment: .center)
    private let linkButton: BBButton = BBButton()
    
    
    public var alert: BBAlert?
    
    public var linkAction: ((BBAlert?) -> Void)?
    
    public init(
        _ title: String?,
        titleFontStyle: BBFontStyle? = nil,
        subtitle: String? = nil,
        subtitleFontStyle: BBFontStyle? = nil,
        linkTitle: String? = nil,
        linkTitleFontStyle: BBFontStyle? = nil,
        linkAction: ((BBAlert?) -> Void)? = nil,
        viewConfig: BBAlertViewConfiguration
        
    ) {
        super.init(frame: .zero)
        setupAttributes()
        self.linkAction = linkAction
        
        titleLabel.text = title
        titleLabel.fontStyle = titleFontStyle ?? .head2Bold
        titleLabel.numberOfLines = viewConfig.titleNumberOfLines
        
        linkButton.setTitle(linkTitle, for: .normal)
        linkButton.addTarget(self, action: #selector(handleLinkButtonTapped), for: .touchUpInside)
        linkButton.setTitleFontStyle(linkTitleFontStyle ?? .caption)
        addArrangedSubviews(titleLabel, linkButton)
        
        
        subtitleLabel.text = subtitle
        
        if let subtitle = subtitle {
            subtitleLabel.text = subtitle
            subtitleLabel.textColor = .gray300
            subtitleLabel.fontStyle = titleFontStyle ?? .body1Regular
            subtitleLabel.numberOfLines = viewConfig.subtitleNumberOfLines
            addArrangedSubview(subtitleLabel)
        }
        
        setupAutoLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func handleLinkButtonTapped() {
        linkAction?(alert)
    }
    
    private func setupAutoLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.height.equalTo(25)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
    }
    
    private func setupAttributes() {
        axis = .vertical
        spacing = 8
        alignment = .fill
        distribution = .fillProportionally
    }
    
    
}



public class TextAlertView: UIStackView, BBAlertStackView {
    
    // MARK: - Views
    
    private let titleLabel = BBLabel(textAlignment: .center)
    private let subtitleLabel = BBLabel(textAlignment: .center)
    
    // MARK: - Properties
    
    public var alert: BBAlert?
    
    
    // MARK: - Intializer
    
    public init(
        _ title: String?,
        titleFontStyle: BBFontStyle? = nil,
        subtitle: String? = nil,
        subtitleFontStyle: BBFontStyle? = nil,
        viewConfig: BBAlertViewConfiguration
    ) {
        super.init(frame: .zero)
        commonInit()
        
        titleLabel.text = title
        titleLabel.fontStyle = titleFontStyle ?? .head2Bold
        titleLabel.numberOfLines = viewConfig.titleNumberOfLines
        addArrangedSubview(titleLabel)
        
        if let subtitle = subtitle {
            subtitleLabel.text = subtitle
            subtitleLabel.textColor = .gray300
            subtitleLabel.fontStyle = titleFontStyle ?? .body1Regular
            subtitleLabel.numberOfLines = viewConfig.subtitleNumberOfLines
            addArrangedSubview(subtitleLabel)
        }
        
        setupConstraints()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Helpers
    
    private func setupConstraints() {
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            titleLabel.heightAnchor.constraint(equalToConstant: 25)
        ])
        
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subtitleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 40)
        ])
        
    }
    
    private func commonInit() {
        axis = .vertical
        spacing = 8
        alignment = .fill
        distribution = .fillProportionally
    }
    
}

