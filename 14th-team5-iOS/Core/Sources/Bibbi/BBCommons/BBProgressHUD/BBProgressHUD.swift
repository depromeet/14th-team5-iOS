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
    
    /// 로띠가 포함된 ProgressHUD를 생성합니다.
    /// - Parameters:
    ///   - kind: 로띠 종류
    ///   - viewConfig: ProgressHUDView 설정값
    ///   - config: ProgressHUD 설정값
    /// - Returns: BBProgressHUD
    public static func lottie(
        _ kind: BBLottieKind,
        title: String? = nil,
        titleFontStyle: BBFontStyle? = nil,
        titleColor: UIColor? = nil,
        viewConfig: BBProgressHUDViewConfiguration = BBProgressHUDViewConfiguration(),
        config: BBProgressHUDConfiguration = BBProgressHUDConfiguration()
    ) -> BBProgressHUD {
        let view = DefaultProgressHUDView(
            child: LottieProgressHUDView(
                of: kind,
                title: title,
                titleFontStyle: titleFontStyle,
                titleColor: titleColor,
                viewConfig: viewConfig
            ),
            viewConfig: viewConfig
        )
        
        return BBProgressHUD(view: view, config: config)
    }
    
    /// 코어 애니메이션이 포함된 ProgressHUD를 생성합니다.
    /// - Parameters:
    ///   - type: 코어 애니메이션 타입
    ///   - viewConfig: ProgressHUDView 설정값
    ///   - config: ProgressHUD 설정값
    /// - Returns: BBProgressHUD
    public static func animation(
        _ type: BBProgressHUDCAType,
        title: String? = nil,
        titleFontStyle: BBFontStyle? = nil,
        titleColor: UIColor? = nil,
        viewConfig: BBProgressHUDViewConfiguration = BBProgressHUDViewConfiguration(),
        config: BBProgressHUDConfiguration = BBProgressHUDConfiguration()
    ) -> BBProgressHUD {
        let view = DefaultProgressHUDView(
            child: CoreAnimationProgressHUDView(
                type,
                title: title,
                titleFontStyle: titleFontStyle,
                titleColor: titleColor,
                viewConfig: viewConfig
            ),
            viewConfig: viewConfig
        )
        
        return BBProgressHUD(view: view, config: config)
    }
    
    /// 정해진 Style의 ProgressHUD를 생성합니다.
    /// - Parameters:
    ///   - style: 스타일
    ///   - config: ProgressHUD 설정값
    /// - Returns: BBProgressHUD
    public static func style(
        _ style: BBProgressHUDStyle,
        config: BBProgressHUDConfiguration = BBProgressHUDConfiguration()
    ) -> BBProgressHUD {
        switch style {
        case .airplane:
            let view = DefaultProgressHUDView(
                child: LottieProgressHUDView(
                    of: .airplane,
                    viewConfig: .lottie
                ),
                viewConfig: .lottie
            )
            return BBProgressHUD(view: view, config: config)
            
        case let .airplaneWithTitle(title, titleFontStyle, titleColor):
            let view = DefaultProgressHUDView(
                child: LottieProgressHUDView(
                    of: .airplane,
                    title: title,
                    titleFontStyle: titleFontStyle,
                    titleColor: titleColor,
                    viewConfig: .lottieWithTitle
                ),
                viewConfig: .lottieWithTitle
            )
            return BBProgressHUD(view: view, config: config)
        }
    }
    
    public static func custom(
        _ child: BBProgressHUDStackView,
        viewConfig: BBProgressHUDViewConfiguration = BBProgressHUDViewConfiguration(),
        config: BBProgressHUDConfiguration = BBProgressHUDConfiguration()
    ) -> BBProgressHUD {
        let view = DefaultProgressHUDView(
            child: child,
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
