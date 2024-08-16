//
//  ProgressHUD.swift
//  BBProgressHUD
//
//  Created by 김건우 on 8/16/24.
//

import UIKit

public class BBProgressHUD {
    
    // MARK: - Properties
    
    public static var activeProgressHUDs = [BBProgressHUD]()
    
    public let view: BBProgressHUDView
    private var backgroundView: UIView?
    
    public static var defaultImageTint: UIColor = .bibbiBlack
    
    public static var multicast = MulticastDelegate<BBProgressHUDDelegate>()
    
    public private(set) var config: BBProgressHUDConfiguration
    
    
    // MARK: - ProgressHUD
    
    public static func lottie(
        _ kind: BBLottieKind,
        viewConfig: BBProgressHUDViewConfiguration = BBProgressHUDViewConfiguration(),
        config: BBProgressHUDConfiguration = BBProgressHUDConfiguration()
    ) -> BBProgressHUD {
        let view = DefaultProgressHUDView(
            child: LottieProgressHUDView(
                of: kind,
                viewConfig: viewConfig
            ),
            viewConfig: viewConfig
        )
        
        return BBProgressHUD(view: view, config: config)
    }
    
    public static func animation(
        _ type: BBProgressHUDCAType,
        viewConfig: BBProgressHUDViewConfiguration = BBProgressHUDViewConfiguration(),
        config: BBProgressHUDConfiguration = BBProgressHUDConfiguration()
    ) -> BBProgressHUD {
        let view = DefaultProgressHUDView(
            child: CoreAnimationProgressHUDView(
                of: type,
                viewConfig: viewConfig
            ),
            viewConfig: viewConfig
        )
        
        return BBProgressHUD(view: view, config: config)
    }
    
    
    // MARK: - Show
    
    public func show(
        after delay: TimeInterval = 0,
        animated: Bool = true
    ) {
        if let backgroundView = self.createBackgroundView() {
            self.backgroundView = backgroundView
            config.view?.addSubview(backgroundView) ?? BBHelper.topController()?.view.addSubview(backgroundView)
        }
        
        config.view?.addSubview(view) ?? BBHelper.topController()?.view.addSubview(view)
        view.createView(for: self)
        
        Self.multicast.invoke { $0.willShowProgressHUD(self) }
        
        config.enteringAnimation.apply(to: self.view)
        let endBackgroundColor = backgroundView?.backgroundColor
        backgroundView?.backgroundColor = .clear
        UIView.animate(
            withDuration: animated ? config.animationTime : 0,
            delay: delay,
            options: [.curveEaseOut]
        ) {
            self.config.enteringAnimation.undo(from: self.view)
            self.backgroundView?.backgroundColor = endBackgroundColor
        } completion: { [self] _ in
            Self.multicast.invoke { $0.didShowProgressHUD(self) }
            
            if !config.allowProgressHUDOverlap {
                closeOverlappedProgressHUDs()
            }
            Self.activeProgressHUDs.append(self)
        }
    }
    
    
    // MARK: - Close
    
    public func close(
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        Self.multicast.invoke { $0.willHideProgressHUD(self) }
        
        UIView.animate(
            withDuration: config.animationTime,
            delay: 0,
            options: [.curveEaseOut]
        ) {
            if animated {
                self.config.exitingAnimation.apply(to: self.view)
            }
            self.backgroundView?.backgroundColor = .clear
        } completion: { [self] _ in
            self.backgroundView?.removeFromSuperview()
            self.view.removeFromSuperview()
            if let index = Self.activeProgressHUDs.firstIndex(where: { $0 === self }) {
                Self.activeProgressHUDs.remove(at: index)
            }
            completion?()
            Self.multicast.invoke { $0.didHideProgressHUD(self) }
        }
        
    }
    
    public static func close(
        _ closeToProgressHud: BBProgressHUD,
        animated: Bool = true
    ) {
        if let index = Self.activeProgressHUDs.firstIndex(where: { $0 === closeToProgressHud }) {
            Self.activeProgressHUDs[index].close(animated: animated)
        }
    }
    
    public static func closeAll(animated: Bool = true) {
        Self.activeProgressHUDs.forEach {
            $0.close(animated: animated)
        }
    }
    
    private func closeOverlappedProgressHUDs() {
        Self.activeProgressHUDs.forEach {
            $0.close(animated: false)
        }
    }
    
    
    
    
    
    // MARK: - Intializer
    
    public required init(
        view: BBProgressHUDView,
        config: BBProgressHUDConfiguration
    ) {
        self.view = view
        self.config = config
    }
    
}


// MARK: - Extensions

extension BBProgressHUD {
    
    public func addDelegate(_ delegate: BBProgressHUDDelegate) {
        Self.multicast.add(delegate)
    }
    
    private func createBackgroundView() -> UIView? {
        switch config.background {
        case .none:
            return nil
            
        case let .color(color):
            let backgroundView = UIView(frame: config.view?.frame ?? BBHelper.topController()?.view.frame ?? .zero)
            backgroundView.backgroundColor = color
            backgroundView.layer.zPosition = 998
            return backgroundView
        }
    }
    
    
    
}

extension BBProgressHUD: Equatable {
    
    public static func == (lhs: BBProgressHUD, rhs: BBProgressHUD) -> Bool {
        ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
    
}
