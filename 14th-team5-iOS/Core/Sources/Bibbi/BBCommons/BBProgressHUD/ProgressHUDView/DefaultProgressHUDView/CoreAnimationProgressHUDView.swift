//
//  CAProgressView.swift
//  BBProgressHUD
//
//  Created by 김건우 on 8/16/24.
//

import UIKit

public class CoreAnimationProgressHUDView: UIStackView, BBProgressHUDStackView {
    
    // MARK: - Views
    
    private let caView = UIView()
    private let titleLabel = BBLabel()
    
    // MARK: - Properties
    
    public var viewConfig: BBProgressHUDViewConfiguration
    public var progressHud: BBProgressHUD?
    
    private var type: BBProgressHUDCAType
    
    
    // MARK: - Intializer
    
    public init(
        _ type: BBProgressHUDCAType,
        title: String? = nil,
        titleFontStyle: BBFontStyle? = nil,
        titleColor: UIColor? = nil,
        viewConfig: BBProgressHUDViewConfiguration
    ) {
        self.viewConfig = viewConfig
        self.type = type
        
        super.init(frame: .zero)
        commonInit()
        
        addArrangedSubview(caView)
        applyAnimation(for: caView)
        
        if let title = title {
            titleLabel.text = title
            titleLabel.fontStyle = titleFontStyle ?? .body1Regular
            titleLabel.textColor = titleColor ?? .bibbiWhite
            titleLabel.textAlignment = .center
            titleLabel.numberOfLines = 1
            addArrangedSubview(titleLabel)
        }
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Helpers
    
    private func commonInit() {
        axis = .vertical
        spacing = 10
        alignment = .fill
        distribution = .fillProportionally
    }
    
    private func applyAnimation(for view: UIView) {
        if type == .spinner { animationActivityIndicator(for: view) }
    }
    
}
