//
//  BBToastView.swift
//  BBToast
//
//  Created by 김건우 on 7/4/24.
//

import UIKit

import SnapKit
import Then

public class DefaultToastView: UIView, BBToastView {
    
    // MARK: - Views
    
    public let child: BBToastStackView
    
    
    // MARK: - Properties
    
    public weak var toast: BBToast?
    
    private let viewConfig: BBToastViewConfiguration
    
    
    // MARK: - Intializer
    
    public init(
        child: BBToastStackView,
        viewConfig: BBToastViewConfiguration = BBToastViewConfiguration()
    ) {
        self.viewConfig = viewConfig
        self.child = child
        super.init(frame: .zero)
        
        addSubview(child)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Create
    
    public func createView(for toast: BBToast) {
        self.toast = toast
        self.child.toast = toast
        
        setupConstraints(for: toast)
        setupAttributes()
    }
    
    private func setupConstraints(for toast: BBToast) {
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            widthAnchor.constraint(greaterThanOrEqualToConstant: viewConfig.minWidth),
            heightAnchor.constraint(greaterThanOrEqualToConstant: viewConfig.minHeight),
            leadingAnchor.constraint(greaterThanOrEqualTo: superview.leadingAnchor, constant: 10),
            trailingAnchor.constraint(lessThanOrEqualTo: superview.trailingAnchor, constant: -10),
            centerXAnchor.constraint(equalTo: superview.centerXAnchor)
        ])
        
        switch toast.config.direction {
        case let .bottom(yOffset):
            bottomAnchor.constraint(equalTo: superview.layoutMarginsGuide.bottomAnchor, constant: yOffset).isActive = true
        case let .top(yOffset):
            topAnchor.constraint(equalTo: superview.layoutMarginsGuide.topAnchor, constant: yOffset).isActive = true
        case let .center(xOffset, yOffset):
            centerXAnchor.constraint(equalTo: superview.layoutMarginsGuide.centerXAnchor, constant: xOffset).isActive = true
            centerYAnchor.constraint(equalTo: superview.layoutMarginsGuide.centerYAnchor, constant: yOffset).isActive = true
        }
        
        setupSubviewConstraints(superview: superview)
    }
    
    private func setupAttributes() {
        layoutIfNeeded()
        clipsToBounds = true
        layer.zPosition = 999
        layer.cornerRadius = viewConfig.cornerRadius ?? frame.height / 2
        backgroundColor = viewConfig.backgroundColor
        
        addShadow()
    }
    
    
    // MARK: - Helpers
    
    private func setupSubviewConstraints(superview: UIView) {
        child.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            child.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            child.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            child.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            child.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15)
        ])
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
        self.toast = nil
    }
    
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        UIView.animate(withDuration: 0.5) {
            self.setupAttributes()
        }
    }
    
}
