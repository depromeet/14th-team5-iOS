//
//  CAProgressView.swift
//  BBProgressHUD
//
//  Created by 김건우 on 8/16/24.
//

import UIKit

public class CoreAnimationProgressHUDView: UIView, BBProgressHUDSubView {
    
    // MARK: - Properties
    
    public var viewConfig: BBProgressHUDViewConfiguration

    private var type: BBProgressHUDCAType
    
    
    // MARK: - Intializer
    
    public init(
        of type: BBProgressHUDCAType,
        viewConfig: BBProgressHUDViewConfiguration
    ) {
        self.type = type
        self.viewConfig = viewConfig
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Helpers
    
    public func applyAnimation(for progressHud: BBProgressHUD?) {
        if type == .spinner { animationActivityIndicator(for: self) }
    }
    
}
