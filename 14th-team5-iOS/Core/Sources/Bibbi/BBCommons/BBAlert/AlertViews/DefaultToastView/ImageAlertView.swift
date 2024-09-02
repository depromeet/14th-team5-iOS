//
//  ImageAlertView.swift
//  BBAlert
//
//  Created by 김건우 on 8/6/24.
//

import UIKit

public class ImageAlertView: UIStackView, BBAlertStackView {
    
    // MARK: - Views
    
    private let titleLabel = BBLabel(textAlignment: .center)
    private let subtitleLabel = BBLabel(textAlignment: .center)
    private let titleStack = UIStackView()
    private let imageView = UIImageView()
    
    
    // MARK: - Properties
    
    public var alert: BBAlert?
    
    
    // MARK: - Intializer
    
    public init(
        image: UIImage? = nil,
        imageTint: UIColor? = nil,
        title: String?,
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
        titleStack.addArrangedSubview(titleLabel)
        
        if let subtitle = subtitle {
            subtitleLabel.text = subtitle
            subtitleLabel.fontStyle = subtitleFontStyle ?? .body2Regular
            subtitleLabel.numberOfLines = viewConfig.subtitleNumberOfLines
            titleStack.addArrangedSubview(subtitleLabel)
        }
        
        addArrangedSubview(titleStack)
        
        if let image = image {
            imageView.image = image
            imageView.contentMode = .scaleAspectFit
            imageView.tintColor = imageTint
            addArrangedSubview(imageView)
        }
        
        setupCostraints()
        setupAttributes()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Helpers

    private func setupCostraints() {

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: titleStack.topAnchor, constant: 20),
            titleLabel.heightAnchor.constraint(equalToConstant: 25)
        ])
        
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subtitleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 40)
        ])
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(greaterThanOrEqualToConstant: 151)
        ])
        
    }
    
    private func setupAttributes() {
        titleStack.axis = .vertical
        titleStack.spacing = 8
        titleStack.alignment = .fill
        titleStack.distribution = .fillProportionally
    }
    
    private func commonInit() {
        axis = .vertical
        spacing = 16
        alignment = .fill
        distribution = .fillProportionally
    }
    
}

