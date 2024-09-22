//
//  BBToast.swift
//  BBToast
//
//  Created by 김건우 on 7/4/24.
//

import DesignSystem
import UIKit

// MARK: - Typealias

public typealias BBToastActionHandler = ((BBToast?) -> Void)?

/// 
public class BBToast {
    
    // MARK: - Properties
    
    private static var activeToasts = [BBToast]()
    
    public let view: BBToastView
    private var backgroundView: UIView?
    
    private var closeTimer: Timer?
    
    // pan 제스처를 위한 프로퍼티
    private var startY: CGFloat = 0
    private var startShiftY: CGFloat = 0
    
    public static var defaultImageTint: UIColor = .bibbiWhite
    
    public static var multicast = MulticastDelegate<BBToastDelegate>()
    
    public private(set) var config: BBToastConfiguration

    
    // MARK: - Toast
    
    /// 텍스트가 포함된 Toast를 생성합니다.
    /// - Parameters:
    ///   - title: 타이틀 텍스트
    ///   - titleColor: 타이틀 색상
    ///   - titleFontStyle: 타이틀의 폰트 스타일
    ///   - viewConfig: ToastView 설정값
    ///   - config: Toast 설정값
    /// - Returns: BBToast
    public static func text(
        _ title: String,
        titleColor: UIColor? = nil,
        titleFontStyle: BBFontStyle? = nil,
        viewConfig: BBToastViewConfiguration = BBToastViewConfiguration(),
        config: BBToastConfiguration = BBToastConfiguration()
    ) -> BBToast {
        let view = DefaultToastView(
            child: TextToastView(
                title,
                titleColor: titleColor,
                titleFontStyle: titleFontStyle,
                viewConfig: viewConfig
            ),
            viewConfig: viewConfig
        )
        return BBToast(view: view, config: config)
    }
    
    
    /// 이미지와 텍스트가 포함된 Toast를 생성합니다,
    /// - Parameters:
    ///   - image: 이미지
    ///   - imageTint: 이미지 강조 색상
    ///   - title: 타이틀 텍스트
    ///   - titleColor: 타이틀 색상
    ///   - titleFontStyle: 타이틀의 폰트 스타일
    ///   - viewConfig: ToastView 설정값
    ///   - config: Toast 설정값
    /// - Returns: BBToast
    public static func `default`(
        image: UIImage,
        imageTint: UIColor? = defaultImageTint,
        title: String,
        titleColor: UIColor? = nil,
        titleFontStyle: BBFontStyle? = nil,
        viewConfig: BBToastViewConfiguration = BBToastViewConfiguration(),
        config: BBToastConfiguration = BBToastConfiguration()
    ) -> BBToast {
        let view = DefaultToastView(
            child: IconToastView(
                image: image,
                imageTint: imageTint,
                title: title,
                titleColor: titleColor,
                titleFontStyle: titleFontStyle,
                viewConfig: viewConfig
            ),
            viewConfig: viewConfig
        )
        return BBToast(view: view, config: config)
    }
    
    /// 이미지, 텍스트와 버튼이 포함된 Toast를 생성합니다.
    /// - Parameters:
    ///   - image: 이미지
    ///   - imageTint: 이미지 강조 색상
    ///   - title: 타이틀 텍스트
    ///   - titleColor: 타이틀 색상
    ///   - titleFontStyle: 타이틀의 폰트 스타일
    ///   - buttonTitle: 버튼 타이틀 텍스트
    ///   - buttonTitleFontStyle: 버튼 타이틀의 폰트 스타일
    ///   - buttonTint: 버튼 강조 색상
    ///   - viewConfig: ToastView 설정값
    ///   - config: Toast 설정값
    /// - Returns: BBToast
    public static func button(
        image: UIImage? = nil,
        imageTint: UIColor? = defaultImageTint,
        title: String,
        titleColor: UIColor? = nil,
        titleFontStyle: BBFontStyle? = nil,
        buttonTitle: String,
        buttonTitleFontStyle: BBFontStyle? = nil,
        buttonTint: UIColor? = nil,
        action: BBToastActionHandler = nil,
        viewConfig: BBToastViewConfiguration = BBToastViewConfiguration(),
        config: BBToastConfiguration = BBToastConfiguration()
    ) -> BBToast {
        let view = DefaultToastView(
            child: ButtonToastView(
                image: image,
                imageTint: imageTint,
                title: title,
                titleColor: titleColor,
                titleFontStyle: titleFontStyle,
                buttonTitle: buttonTitle,
                buttonTitleFontStlye: buttonTitleFontStyle,
                buttonTint: buttonTint,
                action: action,
                viewConfig: viewConfig
            ),
            viewConfig: viewConfig
        )
        return BBToast(view: view, config: config)
    }
    
    
    /// 정해진 Style의 Toast를 생성합니다.
    /// - Parameters:
    ///   - style: 스타일
    ///   - config: Toast 설정값
    /// - Returns: BBToast
    public static func style(
        _ style: BBToastStyle,
        config: BBToastConfiguration = BBToastConfiguration()
    ) -> BBToast {
        switch style {
        case .error:
            let viewConfig = BBToastViewConfiguration(
                minWidth: 100
            )
            let view = DefaultToastView(
                child: IconToastView(
                    image: DesignSystemAsset.warning.image,
                    title: "잠시 후에 다시 시도해주세요",
                    viewConfig: viewConfig
                ),
                viewConfig: viewConfig
            )
            return BBToast(view: view, config: config)
        }
    }
    
    public static func custom(
        view: BBToastView,
        config: BBToastConfiguration = BBToastConfiguration()
    ) -> BBToast {
        return BBToast(view: view, config: config)
    }
    
    
    // MARK: - Show
    
    public func show(
        haptic type: UINotificationFeedbackGenerator.FeedbackType,
        after time: TimeInterval = 0
    ) {
        Haptic.notification(type: type)
        show(after: time)
    }
    
    public func show(after delay: TimeInterval = 0) {
        if let backgroundView = self.createBackgroundView() {
            self.backgroundView = backgroundView
            config.view?.addSubview(backgroundView) ?? BBHelper.topController()?.view.addSubview(backgroundView)
        }
        
        config.view?.addSubview(view) ?? BBHelper.topController()?.view.addSubview(view)
        view.createView(for: self)
        
        Self.multicast.invoke { $0.willShowToast(self) }
        
        config.enteringAnimation.apply(to: self.view)
        let endBackgroundColor = backgroundView?.backgroundColor
        backgroundView?.backgroundColor = .clear
        UIView.animate(
            withDuration: config.animationTime,
            delay: delay,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0.4
        ) {
            self.config.enteringAnimation.undo(from: self.view)
            self.backgroundView?.backgroundColor = endBackgroundColor
        } completion: { [self] _ in
            Self.multicast.invoke { $0.didShowToast(self) }
            
            configureCloseTimer()
            if !config.allowToastOverlap {
                closeOverlappedToasts()
            }
            BBToast.activeToasts.append(self)
        }
        
    }
    
    private func closeOverlappedToasts() {
        BBToast.activeToasts.forEach {
            $0.closeTimer?.invalidate()
            $0.close(animated: false)
        }
    }
    
    
    // MARK: - Close
    
    public func close(
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        Self.multicast.invoke { $0.willCloseToast(self) }
        
        UIView.animate(
            withDuration: config.animationTime,
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0.4
        ) {
            if animated {
                self.config.exitingAnimation.apply(to: self.view)
            }
            self.backgroundView?.backgroundColor = .clear
        } completion: { [self] _ in
            self.backgroundView?.removeFromSuperview()
            self.view.removeFromSuperview()
            if let index = BBToast.activeToasts.firstIndex(where: { $0 === self }) {
                BBToast.activeToasts.remove(at: index)
            }
            completion?()
            Self.multicast.invoke { $0.didCloseToast(self) }
        }
    }
    
    
    // MARK: - Intializer
    
    public required init(
        view: BBToastView,
        config: BBToastConfiguration
    ) {
        self.view = view
        self.config = config
        
        for dismissable in config.dismissables {
            switch dismissable {
            case .tap:
                enableTapToClose()
            case .longPress:
                enableLongPressToClose()
            case .swipe:
                enablePanToClose()
            default:
                break
            }
        }
    }
    
}


// MARK: - Extensions

extension BBToast {
    
    public func addDelegate(_ delegate: BBToastDelegate) {
        Self.multicast.add(delegate)
    }
    
    ///
    public func setAction(
        _ action: BBToastActionHandler = nil
    ) {
        if let view = view as? DefaultToastView,
           let subview = view.child as? ButtonToastView {
            subview.action = action
        }
    }
    
}

extension BBToast {
    
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
    
    private func configureCloseTimer() {
        for dismissable in config.dismissables {
            if case let .time(displayTime) = dismissable {
                closeTimer = Timer.scheduledTimer(withTimeInterval: displayTime, repeats: false) { [self] _ in
                    close()
                }
            }
        }
    }
    
}

private extension BBToast {
    
    func enablePanToClose() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(toastOnPan(_:)))
        self.view.addGestureRecognizer(pan)
    }
    
    @objc func toastOnPan(_ gesture: UIPanGestureRecognizer) {
        guard 
            let topVc = BBHelper.topController()
        else { return }
        
        switch gesture.state {
        case .began:
            startY = self.view.frame.origin.y
            startShiftY = gesture.location(in: topVc.view).y
            closeTimer?.invalidate()
            
        case .changed:
            let delta = gesture.location(in: topVc.view).y - startShiftY
            
            for dismissable in config.dismissables {
                if case let .swipe(dismissSwipeDirection) = dismissable {
                    let shouldApply = dismissSwipeDirection.shouldApply(delta, direction: config.direction)
                    
                    if shouldApply {
                        self.view.frame.origin.y = startY + delta
                    }
                }
            }
            
        case .ended:
            let threshold = 15.0
            let ammountOfUserDragged = abs(startY - self.view.frame.origin.y)
            let shouldDismissToast = ammountOfUserDragged > threshold
            
            if shouldDismissToast {
                close()
            } else {
                UIView.animate(withDuration: config.animationTime, delay: 0, options: [.curveEaseOut, .allowUserInteraction]) {
                    self.view.frame.origin.y = self.startY
                } completion: { [self] _ in
                    configureCloseTimer()
                }
            }
            
        case .cancelled, .failed:
            configureCloseTimer()
            
        default:
            break
        }
    }
    
    func enableTapToClose() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(toastOnTap))
        self.view.addGestureRecognizer(tap)
    }
    
    func enableLongPressToClose() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(toastOnTap))
        self.view.addGestureRecognizer(longPress)
    }
    
    @objc func toastOnTap(_ gesture: UITapGestureRecognizer) {
        closeTimer?.invalidate()
        close()
    }
    
}

extension BBToast: Equatable {
    
    public static func == (lhs: BBToast, rhs: BBToast) -> Bool {
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
    
}
