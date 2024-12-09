//
//  BBAlert.swift
//  BBAlert
//
//  Created by 김건우 on 8/6/24.
//

import DesignSystem
import UIKit

// MARK: - Typelias

/// BBAlert 버튼의 동작을 정의하는 핸들러입니다.
public typealias BBAlertActionHandler = ((BBAlert?) -> Void)?


// MARK: - BBAlert

/// BBAlert는 BBAlert을 화면에 띄우게 도와줍니다.
///
/// BBAlertAction 클래스로 BBAlert 버튼의 액션과 스타일을 설정할 수 있습니다. **show(after:)** 메서드로 BBAlert를 띄울 수 있으며, **close(animated:, completion:)** 메서드로 BBAlert를 사라지게 할 수 있습니다.
///
///  아래는 BBAlert를 띄우는 가장 기본적인 방법을 보여줍니다.
///
///  ```swift
///  let cancelAction = BBAlertAction("취소", style: .cancel)
///  let okAction = BBAlertAction("확인") { [weak self] in
///     self?.didTapOkAction()
///  }
///  let alert = BBAlert.text(
///     "Hello, BBAlert!",
///     actions: [cancelAction, okAction]
///  )
///  alert.show()
///  ```
///
///  - Important: BBAlert에 아무런 BBAlertAction을 추가하지 않고 **show(after:)** 메서드를 호출하면 크래시가 발생합니다. 적어도 하나 이상의 BBAlertAction이 필요합니다. 이는 BBAlert의 안전한 사용을 위해 의도되었습니다.
///
///  BBAlert는 델리게이트 패턴을 지원합니다. BBAlert의 생명 주기에 맞게 필요한 동작을 구현할 수 있습니다. BBAlert는 멀티캐스트 델리게이트 패턴으로 구현되어 있습니다.
///
///  아래는 BBAlert에 델리게이트 패턴을 구현하는 방법을 보여줍니다.
///
///  ```swift
///  // ViewController.swift
///  let alert = BBAlert.text("Hello, BBAlert!")
///  alert.addDelegate(self)
///
///  extension ViewController: BBAlertDelgate { ... }
///  ````
///
///  - Note: 지원하는 델리게이트 메서드에 대한 자세한 정보는 ``BBAlertDelegate``를 참조하세요.
///
/// ``BBAlertConfiguration``과 ``BBAlertViewConfiguration`` 구조체를 활용하여 BBAlert의 애니메이션, 배경 색상 및 BBAlert 뷰의 크기, 둥글기 반경, 버튼 배치 방향을 설정할 수 있습니다.
///
/// - Authors: 김소월
public class BBAlert {
    
    // MARK: - Properties
    
    public static var activeAlerts: [BBAlert] = []
    
    public let view: BBAlertView
    private var backgroundView: UIView?

    public private(set) var actions: [BBAlertAction] = []
    
    public static var defaultImageTint: UIColor = .bibbiBlack
    
    public static var multicast = MulticastDelegate<BBAlertDelegate>()
    
    public private(set) var config: BBAlertConfiguration
    
    
    // MARK: - Alert
    
    /// 텍스트와 서브 텍스트가 포함된 Alert를 생성합니다.
    /// - Parameters:
    ///   - title: 타이틀 텍스트
    ///   - titleFontStyle: 타이틀의 폰트 스타일
    ///   - subtitle: 서브 타이틀 텍스트
    ///   - subtitleFontStyle: 서브 타이틀의 폰트 스타일
    ///   - actions: 버튼의 액션과 스타일
    ///   - viewConfig: AlertView 설정값
    ///   - config: Alert 설정값
    /// - Returns: BBAlert
    public static func text(
        title: String,
        titleFontStyle: BBFontStyle? = nil,
        subtitle: String? = nil,
        subtitleFontStyle: BBFontStyle? = nil,
        actions: [BBAlertAction] = [],
        viewConfig: BBAlertViewConfiguration = BBAlertViewConfiguration(),
        config: BBAlertConfiguration = BBAlertConfiguration()
    ) -> BBAlert {
        let view = DefaultAlertView(
            child: TextAlertView(
                title,
                titleFontStyle: titleFontStyle,
                subtitle: subtitle,
                subtitleFontStyle: subtitleFontStyle,
                viewConfig: viewConfig
            ),
            viewConfig: viewConfig
        )
        
        return BBAlert(view: view, actions: actions, config: config)
    }
    
    
    /// 텍스트, 서브 텍스트와 이미지가 포함된 Alert를 생성합니다.
    /// - Parameters:
    ///   - image: 이미지
    ///   - imageTint: 이미지 강조 색상
    ///   - title: 타이틀 텍스트
    ///   - titleFontStyle: 타이틀의 폰트 스타일
    ///   - subtitle: 서브 타이틀 텍스트
    ///   - subtitleFontStyle: 서브 타이틀의 폰트 스타일
    ///   - actions: 버튼의 액션과 스타일
    ///   - viewConfig: AlertView 설정값
    ///   - config: Alert 설정값
    /// - Returns: BBAlert
    public static func image(
        image: UIImage? = nil,
        imageTint: UIColor? = nil,
        title: String,
        titleFontStyle: BBFontStyle? = nil,
        subtitle: String? = nil,
        subtitleFontStyle: BBFontStyle? = nil,
        actions: [BBAlertAction] = [],
        viewConfig: BBAlertViewConfiguration = BBAlertViewConfiguration(),
        config: BBAlertConfiguration = BBAlertConfiguration()
    ) -> BBAlert {
        let view = DefaultAlertView(
            child: ImageAlertView(
                image: image,
                imageTint: imageTint,
                title: title,
                titleFontStyle: titleFontStyle,
                subtitle: subtitle,
                subtitleFontStyle: subtitleFontStyle,
                viewConfig: viewConfig
            ),
            viewConfig: viewConfig
        )
        
        return BBAlert(view: view, actions: actions, config: config)
    }
    
    /// 정해진 Style의 Alert를 생성합니다.
    /// - Parameters:
    ///   - style: 스타일
    ///   - primaryAction: 버튼 액션 클로저
    ///   - config: Alert 설정값
    /// - Returns: BBAlert
    public static func style(
        _ style: BBAlertStyle,
        primaryAction primaryHandler: BBAlertActionHandler = nil,
        secondaryAction secondaryHandler: BBAlertActionHandler = nil,
        config: BBAlertConfiguration = BBAlertConfiguration()
    ) -> BBAlert {
        switch style {
        case .logout:
            let actions = [
                BBAlertAction(title: "취소", style: .cancel),
                BBAlertAction(title: "확인", handler: primaryHandler)
            ]
            let viewConfig = BBAlertViewConfiguration(
                minHeight: 145,
                buttonAxis: .horizontal
            )
            let view = DefaultAlertView(
                child: TextAlertView(
                    "로그아웃",
                    subtitle: "로그아웃 하시겠어요?",
                    viewConfig: viewConfig
                ),
                viewConfig: viewConfig
            )
            return BBAlert(view: view, actions: actions, config: config)
            
        case .makeNewFamily:
            let actions = [
                BBAlertAction(title: "취소", style: .cancel),
                BBAlertAction(title: "확인", handler: primaryHandler)
            ]
            let viewConfig = BBAlertViewConfiguration(
                minHeight: 181,
                buttonAxis: .horizontal
            )
            let view = DefaultAlertView(
                child: TextAlertView(
                    "새 가족 방 만들기",
                    subtitle: "초대 받은 가족이 없어\n새 가족 방으로 입장할래요",
                    viewConfig: viewConfig
                ),
                viewConfig: viewConfig
            )
            return BBAlert(view: view, actions: actions, config: config)
            
        case .resetFamilyName:
            let actions = [
                BBAlertAction(title: "취소", style: .cancel),
                BBAlertAction(title: "확인", handler: primaryHandler)
            ]
            let viewConfig = BBAlertViewConfiguration(
                minHeight: 181,
                buttonAxis: .horizontal
            )
            let view = DefaultAlertView(
                child: TextAlertView(
                    "가족 방 이름을 초기화 하겠습니까?",
                    subtitle: "홈 화면의 가족방 이름이 사라지고\nBibbi 로고로 바뀌어요",
                    viewConfig: viewConfig
                ),
                viewConfig: viewConfig
            )
            return BBAlert(view: view, actions: actions, config: config)
            
        case .widget:
            let actions = [
                BBAlertAction(title: "확인하기", handler: primaryHandler),
                BBAlertAction(title: "닫기", style: .cancel)
            ]
            let viewConfig = BBAlertViewConfiguration(
                minHeight: 384,
                buttonAxis: .vertical
            )
            let view = DefaultAlertView(
                child: ImageAlertView(
                    image: DesignSystemAsset.widgetGraphic.image,
                    title: "위젯 추가하셨나요?",
                    subtitle: "홈 화면에서 위젯으로\n가족의 소식을 한눈에 파악할 수 있어요",
                    viewConfig: viewConfig
                ),
                viewConfig: viewConfig
            )
            return BBAlert(view: view, actions: actions, config: config)
            
        case .mission:
            let actions = [
                BBAlertAction(title: "미션 사진 찍기", handler: primaryHandler),
                BBAlertAction(title: "닫기", style: .cancel)
            ]
            let viewConfig = BBAlertViewConfiguration(
                minHeight: 384,
                buttonAxis: .vertical
            )
            let view = DefaultAlertView(
                child: ImageAlertView(
                    image: DesignSystemAsset.missionKeyGraphic.image,
                    title: "미션 열쇠 획득!",
                    subtitle: "열쇠를 획득해 잠금이 해제되었어요.\n미션 사진을 찍을 수 있어요!",
                    viewConfig: viewConfig
                ),
                viewConfig: viewConfig
            )
            return BBAlert(view: view, actions: actions, config: config)
            
        case let .picking(name):
            let actions = [
                BBAlertAction(title: "지금 하기", handler: primaryHandler),
                BBAlertAction(title: "다음에 하기", style: .cancel)
            ]
            let viewConfig = BBAlertViewConfiguration(
                minHeight: 384,
                buttonAxis: .vertical
            )
            let view = DefaultAlertView(
                child: ImageAlertView(
                    image: DesignSystemAsset.exhaustedBibbiGraphic.image,
                    title: "생존 확인하기",
                    subtitle: "\(name)님의 생존 여부를 물어볼까요?\n지금 알림이 전송됩니다.",
                    viewConfig: viewConfig
                ),
                viewConfig: viewConfig
            )
            return BBAlert(view: view, actions: actions, config: config)
            
        case .takePhoto:
            let actions = [
                BBAlertAction(title: "생존 신고 먼저하기", handler: primaryHandler),
                BBAlertAction(title: "다음에 하기", style: .cancel)
            ]
            let viewConfig = BBAlertViewConfiguration(
                minHeight: 384,
                buttonAxis: .vertical
            )
            let view = DefaultAlertView(
                child: ImageAlertView(
                    image: DesignSystemAsset.takeSurvivalGraphic.image,
                    title: "생존신고 사진을 먼저 찍으세요!",
                    subtitle: "미션 사진을 올리려면\n생존신고 사진을 먼저 업로드해야해요.",
                    viewConfig: viewConfig
                ),
                viewConfig: viewConfig
            )
            return BBAlert(view: view, actions: actions, config: config)
            
        case .uploadFailed:
            
            let actions = [
                BBAlertAction(title: "다시 촬영하기", handler: primaryHandler),
                BBAlertAction(
                    title: "홈으로 이동",
                    style: .custom(
                        titleFontStyle: .body1Bold,
                        titleColor: .gray400,
                        backgroundColor: .gray700
                    ),
                    handler: secondaryHandler
                )
            ]
            let viewConfig = BBAlertViewConfiguration(
                minHeight: 384,
                buttonAxis: .vertical
            )
            let view = DefaultAlertView(
                child: ImageAlertView(
                    image: DesignSystemAsset.uploadFailed.image,
                    title: "업로드에 실패했어요",
                    subtitle: "같은 문제가 반복된다면 앱을 껐다 켜거나\n 삭제하고 다시 설치해주세요.",
                    viewConfig: viewConfig
                ),
                viewConfig: viewConfig
            )
            return BBAlert(view: view, actions: actions, config: config)
        }
    }
    
    /// 직접 커스텀한 뷰로 BBAlert을 생성합니다.
    /// - Parameters:
    ///   - child: BBAlertStackView 프로토콜을 준수하는 UIView
    ///   - actions: 버튼의 액션과 스타일
    ///   - viewConfig: AlertView 설정값
    ///   - config: Alert 설정값
    /// - Returns: BBAlert
    public static func custom(
        _ child: any BBAlertStackView,
        actions: [BBAlertAction] = [],
        viewConfig: BBAlertViewConfiguration = BBAlertViewConfiguration(),
        config: BBAlertConfiguration = BBAlertConfiguration()
    ) -> BBAlert {
        let view = DefaultAlertView(
            child: child,
            viewConfig: viewConfig
        )
        
        return BBAlert(view: view, actions: actions, config: config)
    }
    
    // MARK: - Show
    
    
    /// BBAlert를 화면에 보이게 합니다.
    /// - Parameters:
    ///   - type: HapticFeedback의 타입
    ///   - time: 지연 시간
    public func show(haptic type: UINotificationFeedbackGenerator.FeedbackType, after time: TimeInterval = 0) {
        Haptic.notification(type: type)
        show(after: time)
    }
    
    
    /// BBAlert를 화면에 보이게 합니다.
    /// - Parameter delay: 지연 시간
    public func show(after delay: TimeInterval = 0) {
        if let backgroundView = self.createBackgroundView() {
            self.backgroundView = backgroundView
            config.view?.addSubview(backgroundView) ?? BBHelper.topController()?.view.addSubview(backgroundView)
        }
        
        config.view?.addSubview(view) ?? BBHelper.topController()?.view.addSubview(view)
        view.createView(for: self, actions: self.actions)
        
        Self.multicast.invoke { $0.willShowAlert(self) }
        
        config.enteringAnimation.apply(to: self.view)
        let endBackgroundColor = backgroundView?.backgroundColor
        backgroundView?.backgroundColor = .clear
        UIView.animate(withDuration: 0.15) {
            self.config.enteringAnimation.undo(from: self.view)
            self.backgroundView?.backgroundColor = endBackgroundColor
        } completion: { [self] _ in
            Self.multicast.invoke { $0.didShowAlert(self) }
            
            if !config.allowOverlapAlert {
                closeOverlappedAlerts()
            }
            BBAlert.activeAlerts.append(self)
        }
        
    }
    
    
    // MARK: - Close
    
    
    /// BBAlert를 화면에 사라지게 합니다.
    ///
    /// BBAlert이 화면에 사라지고 나면 완료 핸들러가 호출됩니다. 완료 핸들러는 델리게이트의  `didCloseAlert(_:)` 메서드가 호출되기 전에 실행됩니다.
    /// - Parameters:
    ///   - animated: 애니메이션 유무
    ///   - completion: 완료 핸들러
    public func close(
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        Self.multicast.invoke { $0.willCloseAlert(self) }
        
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
            Self.multicast.invoke { $0.didCloseAlert(self) }
        }
    }
    
    
    // MARK: - Intializer
    
    public required init(
        view: BBAlertView,
        actions: [BBAlertAction],
        config: BBAlertConfiguration
    ) {
        self.view = view
        self.actions = actions
        self.config = config
    }
    
}


// MARK: - Extensions

extension BBAlert {
    
    /// 델리게이트 패턴을 적용합니다.
    /// - Parameter delegate: BBAlertDelgate 프로토콜을 준수하는 객체
    public func addDelegate(_ delegate: BBAlertDelegate) {
        Self.multicast.add(delegate)
    }
    
    /// 버튼을 추가합니다.
    /// - Parameter action: 버튼의 액션과 스타일
    public func addAction(_ action: BBAlertAction) {
        self.actions.append(action)
    }
    
    /// 버튼을 추가합니다.
    /// - Parameter action: 버튼의 액션과 스타일
    public func addAction(_ actions: BBAlertAction...) {
        actions.forEach {
            self.actions.append($0)
        }
    }
    
    /// 버튼을 추가합니다.
    /// - Parameters:
    ///   - title: 버튼의 타이틀
    ///   - style: 버튼의 스타일
    ///   - handler: 버튼의 액션
    public func addAction(
        title: String? = nil,
        style: BBAlertActionStyle = .default,
        handler: BBAlertActionHandler = nil
    ) {
        self.actions.append(
            BBAlertAction(title: title, style: style, handler: handler)
        )
    }
    
    
    /// 특정 인덱스에 위치한 버튼을 삭제합니다.
    /// - Parameter index: 인덱스
    /// - Returns: BBAlertAction
    @discardableResult
    public func removeAction(_ index: Int) -> BBAlertAction {
        self.actions.remove(at: index)
    }
    
    /// 모든 버튼을 삭제합니다.
    public func removeAllAction() {
        self.actions.removeAll()
    }
    
}

extension BBAlert {
    
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
