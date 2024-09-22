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
    public var action: BBToastActionHandler = nil
    
    private let viewConfig: BBToastViewConfiguration
    
    // MARK: - Intializer
    
    public init(
        image: UIImage? = nil,
        imageTint: UIColor? = nil,
        title: String,
        titleColor: UIColor? = nil,
        titleFontStyle: BBFontStyle? = nil,
        buttonTitle: String,
        buttonTitleFontStlye: BBFontStyle? = nil,
        buttonTint: UIColor? = nil,
        action: BBToastActionHandler = nil,
        viewConfig: BBToastViewConfiguration
    ) {
        self.toast = nil
        self.action = action
        
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
        
        button.setId(0)
        button.setTitle(buttonTitle, for: .normal)
        button.setTitleFontStyle(buttonTitleFontStlye ?? .body1Regular)
        button.setTitleColor(buttonTint ?? .gray100, for: .normal)
        
        let action = UIAction { [weak self] _ in
            guard let self else { return }
            // 델리게이트 실행
            BBToast.multicast.invoke {
                $0.didTapToastButton(
                    self.toast,
                    index: self.button.id,
                    button: self.button
                )
            }
            // 액션 클로저 실행
            self.action?(self.toast)
        }
                
        button.addAction(action, for: .touchUpInside)

        addArrangedSubview(iconView)
        addArrangedSubview(button)
        
        setupConstraints()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func commonInit() {
        axis = .horizontal
        spacing = 0
        alignment = .center
        distribution = .fillProportionally
    }
    
    private func setupConstraints() {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 24).isActive = true
    }

}
