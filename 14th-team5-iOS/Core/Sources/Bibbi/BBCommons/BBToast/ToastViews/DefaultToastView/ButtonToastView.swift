//
//  ButtonToastView.swift
//  Core
//
//  Created by 김건우 on 8/5/24.
//

import UIKit

final public class ButtonToastView: UIStackView, BBToastStackView {
    
    // MARK: - Views
    
    private let button: BBButton = BBButton()
    
    // MARK: - Properties
    
    public var toast: BBToast?
    public var tapAction: ((BBToast?) -> Void)?
    
    private let viewConfig: BBToastViewConfiguration
    
    // MARK: - Intializer
    
    public init(
        image: UIImage,
        imageTint: UIColor? = nil,
        title: String,
        titleColor: UIColor? = nil,
        titleFontStyle: BBFontStyle? = nil,
        buttonTitle: String,
        buttonTitleFontStlye: BBFontStyle? = nil,
        buttonTint: UIColor? = nil,
        viewConfig: BBToastViewConfiguration
    ) {
        self.toast = nil
        self.tapAction = nil
        
        self.viewConfig = viewConfig
        super.init(frame: .zero)
        commonInit()
        
        let iconView = IconToastView(
            image: image,
            imageTint: imageTint,
            title: title,
            titleColor: titleColor,
            titleFontStyle: titleFontStyle,
            viewConfig: viewConfig
        )
        
        button.setTitle(buttonTitle, for: .normal)
        button.setTitleFontStyle(buttonTitleFontStlye ?? .body1Regular)
        button.setTitleColor(buttonTint ?? .gray100, for: .normal)
        
        addArrangedSubview(iconView)
        addArrangedSubview(button)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func commonInit() {
        axis = .horizontal
        spacing = 6
        alignment = .center
        distribution = .fillProportionally
        
        setupAttributes()
    }
    
    private func setupAttributes() {
        button.addTarget(
            self,
            action: #selector(didTapToastButton),
            for: .touchUpInside
        )
    }
    
    // TODO: - 세세한 버튼 UI 수정하기
    
    @objc public func didTapToastButton(_ button: UIButton) {
        tapAction?(toast)
    }
    
}
