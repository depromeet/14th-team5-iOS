//
//  BBToast.swift
//  BBToast
//
//  Created by 김건우 on 7/4/24.
//

import DesignSystem
import UIKit

// MARK: - Typealias

/// BBToast 버튼의 동작을 정의하는 핸들러입니다.
public typealias BBToastActionHandler = ((BBToast?) -> Void)?

/// BBToast는 BBToast를 화면에 띄우게 도와줍니다.
///
///  **show(after:)** 메서드로 BBToastt를 띄울 수 있으며, **close(animated:, completion:)** 메서드로 BBToast를 사라지게 할 수 있습니다.
///
/// 아래는 BBToast를 띄우는 가장 기본적인 방법을 보여줍니다.
///
/// ```swift
/// let toast = BBTast.text("Hello, BBToast!")
/// toast.show()
/// ```
///
/// BBToast는 델리게이트 패턴을 지원합니다. BBToast의 생명 주기에 맞게 필요한 동작을 구현할 수 있습니다. BBToast는 멀티캐스트 델리게이트 패턴으로 구현되어 있습니다.
///
/// /아래는 BBToast에 델리게이트 패턴을 구현하는 방법을 보여줍니다.
///
///  ```swift
///  // ViewController.swift
///  let toast = BBToast.text("Hello, BBToast!")
///  toast.addDelegate(self)
///
///  extension ViewController: BBToastDelegate { ... }
///  ````
///
///  - Note: 지원하는 델리게이트 메서드에 대한 자세한 정보는 ``BBToastDelegate``를 참조하세요.
///
/// ``BBToastConfiguration``과 ``BBToastViewConfiguration`` 구조체를 활용하여 BBToast의 애니메이션, 배경 색상 및 BBToast 뷰의 크기, 둥글기 반경을 설정할 수 있습니다.
///
/// - Authors: 김소월
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
    
    /// 직접 커스텀한 뷰로 BBToast를 생성합니다.
    /// - Parameters:
    ///   - view: BBToastStackView 프로토콜을 준수하는 UIView
    ///   - config: BBToast 설정값
    /// - Returns: BBToast
    public static func custom(
        view: BBToastView,
        config: BBToastConfiguration = BBToastConfiguration()
    ) -> BBToast {
        return BBToast(view: view, config: config)
    }
    
    
    // MARK: - Show
    
    /// BBToast를 화면에 보이게 합니다.
    /// - Parameters:
    ///   - type: HapticFeedback의 타입
    ///   - time: 지연 시간
    public func show(
        haptic type: UINotificationFeedbackGenerator.FeedbackType,
        after time: TimeInterval = 0
    ) {
        Haptic.notification(type: type)
        show(after: time)
    }
    
    /// BBToast를 화면에 보이게 합니다.
    /// - Parameter delay: 지연 시간
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
    
    /// BBToast를 화면에 사라지게 합니다.
    ///
    /// BBToast가 화면에 사라지고 나면 완료 핸들러가 호출됩니다. 완료 핸들러는 델리게이트의 `didCloseToast(_:)` 메서드가 호출되기 전에 실행됩니다.
    /// - Parameters:
    ///   - animated: 애니메이션 유무
    ///   - completion: 완료 핸들러
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
    
    /// 델리게이트 패턴을 적용합니다.
    /// - Parameter delegate: BBToastDelegate 프로토콜을 준수하는 객체
    public func addDelegate(_ delegate: BBToastDelegate) {
        Self.multicast.add(delegate)
    }
    
    /// 버튼을 추가합니다.
    ///
    /// `BBToast.button` 메서드로 BBToast를 생성하는 경우, 해당 메서드로 버튼의 액션을 정의해주어야 합니다.
    /// - Parameter action: 버튼의 액션
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
