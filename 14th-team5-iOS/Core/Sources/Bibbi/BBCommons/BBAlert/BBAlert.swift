//
//  BBAlert.swift
//  BBAlert
//
//  Created by 김건우 on 8/6/24.
//

import DesignSystem
import UIKit

// MARK: - Typelias

public typealias BBAlertAction = ((BBAlert?) -> Void)?

public class BBAlert {
    
    // MARK: - Properties
    
    public static var activeAlerts: [BBAlert] = []
    
    public let view: BBAlertView
    private var backgroundView: UIView?
    
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
    ///   - viewConfig: AlertView 설정값
    ///   - config: Alert 설정값
    /// - Returns: BBAlert
    public static func text(
        title: String,
        titleFontStyle: BBFontStyle? = nil,
        subtitle: String? = nil,
        subtitleFontStyle: BBFontStyle? = nil,
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
        
        return BBAlert(view: view, config: config)
    }
    
    
    /// 텍스트, 서브 텍스트와 이미지가 포함된 Alert를 생성합니다.
    /// - Parameters:
    ///   - image: 이미지
    ///   - imageTint: 이미지 강조 색상
    ///   - title: 타이틀 텍스트
    ///   - titleFontStyle: 타이틀의 폰트 스타일
    ///   - subtitle: 서브 타이틀 텍스트
    ///   - subtitleFontStyle: 서브 타이틀의 폰트 스타일
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
        
        return BBAlert(view: view, config: config)
    }
    
    /// 정해진 Style의 Alert를 생성합니다.
    /// - Parameters:
    ///   - style: 스타일
    ///   - primaryAction: 버튼 액션 클로저
    ///   - config: Alert 설정값
    /// - Returns: BBAlert
    public static func style(
        _ style: BBAlertStyle,
        primaryAction action: BBAlertAction = nil,
        config: BBAlertConfiguration = BBAlertConfiguration()
    ) -> BBAlert {
        switch style {
        case .logout:
            let layout = BBAlertButtonLayout(
                buttons: [.cancel(), .confirm(action: action)],
                axis: .horizontal
            )
            let viewConfig = BBAlertViewConfiguration(
                minHeight: 145,
                buttonLayout: layout
            )
            let view = DefaultAlertView(
                child: TextAlertView(
                    "로그아웃",
                    subtitle: "로그아웃 하시겠어요?",
                    viewConfig: viewConfig
                ),
                viewConfig: viewConfig
            )
            return BBAlert(view: view, config: config)
            
        case .makeNewFamily:
            let layout = BBAlertButtonLayout(
                buttons: [.cancel(), .confirm(action: action)],
                axis: .horizontal
            )
            let viewConfig = BBAlertViewConfiguration(
                minHeight: 181,
                buttonLayout: layout
            )
            let view = DefaultAlertView(
                child: TextAlertView(
                    "새 가족 방 만들기",
                    subtitle: "초대 받은 가족이 없어\n새 가족 방으로 입장할래요",
                    viewConfig: viewConfig
                ),
                viewConfig: viewConfig
            )
            return BBAlert(view: view, config: config)
            
        case .resetFamilyName:
            let layout = BBAlertButtonLayout(
                buttons: [.cancel(), .confirm(action: action)],
                axis: .horizontal
            )
            let viewConfig = BBAlertViewConfiguration(
                minHeight: 181,
                buttonLayout: layout
            )
            let view = DefaultAlertView(
                child: TextAlertView(
                    "가족 방 이름을 초기화 하겠습니까?",
                    subtitle: "홈 화면의 가족방 이름이 사라지고\nBibbi 로고로 바뀌어요",
                    viewConfig: viewConfig
                ),
                viewConfig: viewConfig
            )
            return BBAlert(view: view, config: config)
            
        case .widget:
            let layout = BBAlertButtonLayout(
                buttons: [.confirm(title: "확인하기", action: action), .cancel(title: "닫기")],
                axis: .vertical
            )
            let viewConfig = BBAlertViewConfiguration(
                minHeight: 384,
                buttonLayout: layout
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
            return BBAlert(view: view, config: config)
            
        case .mission:
            let layout = BBAlertButtonLayout(
                buttons: [.confirm(title: "미션 사진 찍기", action: action), .cancel(title: "닫기")],
                axis: .vertical
            )
            let viewConfig = BBAlertViewConfiguration(
                minHeight: 384,
                buttonLayout: layout
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
            return BBAlert(view: view, config: config)
            
        case let .picking(name):
            let layout = BBAlertButtonLayout(
                buttons: [.confirm(title: "지금 하기", action: action), .cancel(title: "다음에 하기")],
                axis: .vertical
            )
            let viewConfig = BBAlertViewConfiguration(
                minHeight: 384,
                buttonLayout: layout
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
            return BBAlert(view: view, config: config)
            
        case .takePhoto:
            let layout = BBAlertButtonLayout(
                buttons: [.confirm(title: "생존 신고 먼저하기", action: action), .cancel(title: "다음에 하기")],
                axis: .vertical
            )
            let viewConfig = BBAlertViewConfiguration(
                minHeight: 384,
                buttonLayout: layout
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
            return BBAlert(view: view, config: config)
            
        }
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
        config: BBAlertConfiguration
    ) {
        self.view = view
        self.config = config
    }
    
}


// MARK: - Extensions

extension BBAlert {
    
    public func addDelegate(_ delegate: BBAlertDelegate) {
        Self.multicast.add(delegate)
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
