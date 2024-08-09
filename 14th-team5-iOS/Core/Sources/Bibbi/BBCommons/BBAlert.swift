//
//  BBAlert.swift
//  BBAlert
//
//  Created by 김건우 on 8/6/24.
//

import UIKit

public class BBAlert {
    
    // MARK: - Properties
    
    public static var activeAlerts: [BBAlert] = []
    
    public let view: BBAlertView
    private var backgroundView: UIView?
    
    public static var defaultImageTint: UIColor = .black
    
    private var multicast = MulticaseDelegate<BBAlertDelegate>()
    
    public private(set) var config: BBAlertConfiguration
    
    
    // MARK: - Alert
    
    public static func `image`(
        image: UIImage? = nil,
        imageTint: UIColor? = nil,
        title: String,
        subtitle: String? = nil,
        viewConfig: BBAlertViewConfiguration = BBAlertViewConfiguration(),
        config: BBAlertConfiguration = BBAlertConfiguration()
    ) -> BBAlert {
        let view = DefaultAlertView(
            child: ImageAlertView(
                image: image,
                imageTint: imageTint,
                title: title,
                subtitle: subtitle,
                viewConfig: viewConfig
            ),
            viewConfig: viewConfig
        )
        
        return BBAlert(view: view, config: config)
    }
    
    public static func custom(
        _ child: BBAlertStackView,
        viewConfig: BBAlertViewConfiguration = BBAlertViewConfiguration(),
        config: BBAlertConfiguration = BBAlertConfiguration()
    ) -> BBAlert {
        let view = DefaultAlertView(
            child: child,
            viewConfig: viewConfig
        )
        
        return BBAlert(view: view, config: config)
    }
    
    // MARK: - Show
    
    public func show(haptic type: UINotificationFeedbackGenerator.FeedbackType, after time: TimeInterval = 0) {
        UINotificationFeedbackGenerator().notificationOccurred(type)
        show(after: time)
    }
    
    public func show(after delay: TimeInterval = 0) {
        if let backgroundView = self.createBackgroundView() {
            self.backgroundView = backgroundView
            config.view?.addSubview(backgroundView) ?? BBHelper.topController()?.view.addSubview(backgroundView)
        }
        
        config.view?.addSubview(view) ?? BBHelper.topController()?.view.addSubview(view)
        view.createView(for: self)
        
        multicast.invoke { $0.willShowAlert(self) }
        
        config.enteringAnimation.apply(to: self.view)
        let endBackgroundColor = backgroundView?.backgroundColor
        backgroundView?.backgroundColor = .clear
        UIView.animate(withDuration: 0.15) {
            self.config.enteringAnimation.undo(from: self.view)
            self.backgroundView?.backgroundColor = endBackgroundColor
        } completion: { [self] _ in
            multicast.invoke { $0.didShowAlert(self) }
            
            if !config.allowOverlapAlert {
                closeOverlappedAlerts()
            }
            BBAlert.activeAlerts.append(self)
        }
        
    }
    
    
    // MARK: - Close
    
    public func close(
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        multicast.invoke { $0.willCloseAlert(self) }
        
        UIView.animate(withDuration: 0.15) {
            if animated {
                self.config.exitingAnimation.apply(to: self.view)
            }
            self.backgroundView?.backgroundColor = .clear
        } completion: { [self] _ in
            self.backgroundView?.removeFromSuperview()
            self.view.removeFromSuperview()
            if let index = BBAlert.activeAlerts.firstIndex(where: { $0 === self }) {
                BBAlert.activeAlerts.remove(at: index)
            }
            completion?()
            self.multicast.invoke { $0.didCloseAlert(self) }
        }
    }
    
    
    // MARK: - Intializer
    
    public required init(
        view: BBAlertView,
        config: BBAlertConfiguration
    ) {
        self.view = view
        self.config = config
    }
    
}


// MARK: - Extensions

extension BBAlert {
    
    public func addDelegate(_ delegate: BBAlertDelegate) {
        multicast.add(delegate)
    }
    
    private func createBackgroundView() -> UIView? {
        switch config.background {
        case .none:
            return nil
            
        case let .color(color):
            let backgroundView = UIView(frame: config.view?.frame ?? BBHelper.topController()?.view.frame ?? .zero)
            backgroundView.backgroundColor = color
            backgroundView.layer.zPosition = 887
            return backgroundView
        }
    }
    
}

extension BBAlert {
    
    private func closeOverlappedAlerts() {
        BBAlert.activeAlerts.forEach { alert in
            alert.close(animated: false)
        }
    }
    
}


extension BBAlert: Equatable {
    
    public static func == (lhs: BBAlert, rhs: BBAlert) -> Bool {
        ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
    
}
