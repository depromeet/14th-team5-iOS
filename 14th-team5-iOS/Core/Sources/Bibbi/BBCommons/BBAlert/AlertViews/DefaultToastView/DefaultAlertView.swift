//
//  DefaultAlertView.swift
//  BBAlert
//
//  Created by 김건우 on 8/6/24.
//

import UIKit

public class DefaultAlertView: UIView, BBAlertView {
    
    // MARK: - Views
    
    private let child: BBAlertStackView
    
    private let buttonStack: UIStackView = UIStackView()
    
    
    // MARK: - Properties
    
    public var id: Int = -1
    
    private var alert: BBAlert?
    private let viewConfig: BBAlertViewConfiguration
    
    private let buttonSpacing: CGFloat = 8
    
    
    // MARK: - Intializer
    
    public init(
        child: BBAlertStackView,
        viewConfig: BBAlertViewConfiguration = BBAlertViewConfiguration()
    ) {
        self.viewConfig = viewConfig
        self.child = child
        super.init(frame: .zero)
        
        addSubview(child)
        addSubview(buttonStack)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Create
    
    public func createView(for alert: BBAlert) {
        self.alert = alert
        self.child.alert = alert
        
        setupUI()
        setupConstraints(for: alert)
        setupAttributes()
    }
    
    
    // MARK: - Helpers
    
    private func setupUI() {
        
        for type in viewConfig.buttonLayout.buttons {
            let button = createAlertButton(for: type)
            buttonStack.addArrangedSubview(button)
        }
        
    }
    
    private func setupConstraints(for alert: BBAlert) {
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            widthAnchor.constraint(greaterThanOrEqualToConstant: viewConfig.minWidth),
            heightAnchor.constraint(greaterThanOrEqualToConstant: viewConfig.minHeight),
            topAnchor.constraint(greaterThanOrEqualTo: superview.layoutMarginsGuide.topAnchor),
            leadingAnchor.constraint(greaterThanOrEqualTo: superview.layoutMarginsGuide.leadingAnchor),
            trailingAnchor.constraint(lessThanOrEqualTo: superview.layoutMarginsGuide.trailingAnchor),
            bottomAnchor.constraint(lessThanOrEqualTo: superview.layoutMarginsGuide.bottomAnchor),
            centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            centerYAnchor.constraint(equalTo: superview.centerYAnchor),
        ])
        
        setupSubviewConstraints()
    }
    
    private func setupSubviewConstraints() {
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonStack.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor),
            buttonStack.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
            buttonStack.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor),
        ])
        
        if case .vertical = viewConfig.buttonLayout.axis {
            let count = CGFloat(buttonStack.arrangedSubviews.count)
            buttonStack.heightAnchor.constraint(equalToConstant: count * viewConfig.buttonLayout.height + (buttonSpacing * count)).isActive = true
        } else {
            buttonStack.heightAnchor.constraint(equalToConstant: viewConfig.buttonLayout.height).isActive = true
        }
        
        child.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            child.bottomAnchor.constraint(equalTo: buttonStack.topAnchor, constant: -16),
            child.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
            child.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor),
            child.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor)
        ])
    }
    
    private func setupButtonConstraints() {
        for button in buttonStack.arrangedSubviews {
            NSLayoutConstraint.activate([
                button.heightAnchor.constraint(equalToConstant: viewConfig.buttonLayout.height)
            ])
        }
    }
    
    private func setupAttributes() {
        layoutIfNeeded()
        clipsToBounds = true
        layer.zPosition = 888
        layer.cornerRadius = viewConfig.cornerRadius ?? 16
        backgroundColor = viewConfig.backgroundColor
        
        buttonStack.axis = viewConfig.buttonLayout.axis
        buttonStack.spacing = buttonSpacing
        buttonStack.alignment = .fill
        buttonStack.distribution = .fillEqually
        
        addShadow()
    }
    
    private func createAlertButton(for type: BBAlert.Button) -> BBButton {
        let button = BBButton(type: .system)
        
        switch type {
        case let .normal(title, titleFontStyle, titleColor, backgroundColor, action):
            setupAlertButtotAttribute(
                button,
                title: title,
                titleFontStlye: titleFontStyle,
                titleColor: titleColor,
                backgroundColor: backgroundColor,
                action: action
            )
            
        case let .confirm(title, action):
            setupAlertButtotAttribute(
                button,
                title: title,
                action: action
            )
        case let .cancel(title):
            setupAlertButtotAttribute(
                button,
                title: title,
                titleColor: .gray400,
                backgroundColor: .gray700
            )
        }
        
        return button
    }
    
    private func setupAlertButtotAttribute(
        _ button: BBButton,
        title: String?,
        titleFontStlye: BBFontStyle? = nil,
        titleColor: UIColor? = nil,
        backgroundColor: UIColor? = nil,
        action: BBAlertAction = nil
    ) {
        self.id += 1
        button.setId(id)
        
        button.setTitle(title, for: .normal)
        button.setTitleColor(titleColor ?? .bibbiBlack, for: .normal)
        button.setTitleFontStyle(titleFontStlye ?? .body1Bold)
        button.backgroundColor = backgroundColor ?? .mainYellow
        
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = false
        
        let action = UIAction { [weak self] _ in
            guard let self = self else { return }
            // 델리게이트 실행
            BBAlert.multicast.invoke {
                $0.didTapAlertButton(
                    self.alert,
                    index: button.id,
                    button: button
                )
            }
            // 액션 클로저 실행
            if let action = action {
                action(self.alert)
            } else {
                self.alert?.close()
            }
        }
        
        button.addAction(action, for: .touchUpInside)
    }
    
    private func addShadow() {
        layer.masksToBounds = false
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowColor = UIColor.black.withAlphaComponent(0.08).cgColor
        layer.shadowOpacity = 1
        layer.shadowRadius = 8
    }
    
    
    public override func removeFromSuperview() {
        super.removeFromSuperview()
        self.alert = nil
    }
    
}
