//
//  ImageAlertView.swift
//  BBAlert
//
//  Created by 김건우 on 8/6/24.
//

import UIKit

public class ImageAlertView: UIStackView, BBAlertStackView {
    
    // MARK: - Views
    
    private let titleLabel = UILabel() // TODO: - BBLabel로 교체
    private let subtitleLabel = UILabel()
    private let imageView = UIImageView()
    
    
    // MARK: - Properties
    
    public var alert: BBAlert?
    
    
    // MARK: - Intializer
    
    public init(
        image: UIImage? = nil,
        imageTint: UIColor? = nil,
        title: String,
        subtitle: String? = nil,
        viewConfig: BBAlertViewConfiguration
    ) {
        super.init(frame: .zero)
        commonInit()
        
        titleLabel.text = title
        titleLabel.numberOfLines = viewConfig.titleNumberOfLines
        addArrangedSubview(titleLabel)
        
        if let subtitle = subtitle {
            subtitleLabel.text = subtitle
            subtitleLabel.numberOfLines = viewConfig.subtitleNumberOfLines
            addArrangedSubview(subtitleLabel)
        }
        
        if let image = image {
            imageView.image = image
            imageView.contentMode = .scaleAspectFit
            imageView.tintColor = imageTint
            addArrangedSubview(imageView)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Helpers
    
    private func commonInit() {
        axis = .vertical
        spacing = 3
        alignment = .center
        distribution = .fillProportionally
    }
    
}

