//
//  DefaultProgressView.swift
//  BBProgressHUD
//
//  Created by 김건우 on 8/16/24.
//

import UIKit

public class DefaultProgressHUDView: UIView, BBProgressHUDView {
    
    // MARK: - Views
    
    private let child: BBProgressHUDStackView
    
    // MARK: - Properties
    
    private weak var progressHud: BBProgressHUD?
    private var viewConfig: BBProgressHUDViewConfiguration
    
    // MARK: - Intializer
    
    public init(
        child: BBProgressHUDStackView,
        viewConfig: BBProgressHUDViewConfiguration
    ) {
        self.child = child
        self.viewConfig = viewConfig
        super.init(frame: .zero)
        
        addSubview(child)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Helpers
 
    public func createView(for progressHud: BBProgressHUD) {
        self.progressHud = progressHud
        
        setupConstraints()
        setupAttributes()
    }
    
    private func setupConstraints() {
        guard let superview = superview else { return }
        
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(greaterThanOrEqualToConstant: viewConfig.minWidth),
            self.heightAnchor.constraint(greaterThanOrEqualToConstant: viewConfig.minHeight),
            self.centerXAnchor.constraint(equalTo: superview.centerXAnchor, constant: viewConfig.xOffset),
            self.centerYAnchor.constraint(equalTo: superview.centerYAnchor, constant: viewConfig.yOffset)
        ])
        
        child.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            child.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.75),
            child.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.75),
            child.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            child.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
    }
    
    private func setupAttributes() {
        layoutIfNeeded()
        clipsToBounds = true
        layer.zPosition = 999
        layer.cornerCurve = .continuous
        layer.cornerRadius = viewConfig.cornerRadius ?? 0
        backgroundColor = viewConfig.backgroundColor
        
        addShadow()
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
        self.progressHud = nil
    }
    
}
