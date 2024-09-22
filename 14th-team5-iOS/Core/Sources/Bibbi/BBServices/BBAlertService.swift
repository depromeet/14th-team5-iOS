//
//  BBAlertService.swift
//  Core
//
//  Created by 김건우 on 9/20/24.
//

import UIKit

import RxSwift


// MARK: - BBAlertActionType

/// BBAlertActionType은 BBAlert의 버튼 스타일과 액션을 정의하도록 도와주는 프로토콜입니다.
///
/// 우리가 Reactor의 Action 열거형에 액션 케이스를 정의하듯이,  마찬가지로 BBAlertActionType 프로토콜의 준수하는 열거형의 케이스가 버튼 액션의 결과가 됩니다.
///
/// - Authors: 김소월
public protocol BBAlertActionType {
    
    /// title 프로퍼티는 필수 구현이며, 버튼의 타이틀을 의미합니다.
    var title: String? { get }
    
    /// style 프로퍼티는 버튼의 스타일을 의미합니다. 선택 구현이며, 기본값은 default입니다.
    var style: BBAlertActionStyle { get }
}

public extension BBAlertActionType {
    var style: BBAlertActionStyle {
        return .default
    }
}



// MARK: - BBAlertServiceType

public protocol BBAlertServiceType {
    @discardableResult
    func show<Action>(
        title: String,
        titleFontStyle: BBFontStyle?,
        subtitle: String?,
        subtitleFontStyle: BBFontStyle?,
        actions: [Action],
        viewConfig: BBAlertViewConfiguration,
        config: BBAlertConfiguration
    ) -> Observable<Action> where Action: BBAlertActionType
    
    @discardableResult
    func show<Action>(
        image: UIImage?,
        imageTint: UIColor?,
        title: String,
        titleFontStyle: BBFontStyle?,
        subtitle: String?,
        subtitleFontStyle: BBFontStyle? ,
        actions: [Action],
        viewConfig: BBAlertViewConfiguration,
        config: BBAlertConfiguration
    ) -> Observable<Action> where Action: BBAlertActionType
    
    @discardableResult
    func show<Action>(
        child: any BBAlertStackView,
        actions: [Action],
        viewConfig: BBAlertViewConfiguration,
        config: BBAlertConfiguration
    ) -> Observable<Action> where Action: BBAlertActionType
    
    @discardableResult
    func show<Action>(
        _ style: BBAlertStyle,
        primaryAction: Action,
        config: BBAlertConfiguration
    ) -> Observable<Action> where Action: BBAlertActionType
}

public extension BBAlertServiceType {
    
    /// 텍스트와 서브 텍스트가 포함된 Alert를 생성합니다.
    /// - Parameters:
    ///   - title: 타이틀 텍스트
    ///   - titleFontStyle: 타이틀의 폰트 스타일
    ///   - subtitle: 서브 타이틀 텍스트
    ///   - subtitleFontStyle: 서브 타이틀의 폰트 스타일
    ///   - actions: BBAlertActionType을 준수하는 열거형 케이스 배열
    ///   - viewConfig: AlertView 설정값
    ///   - config: Alert 설정값
    /// - Returns: Observable
    @discardableResult
    func show<Action>(
        title: String,
        titleFontStyle: BBFontStyle? = nil,
        subtitle: String? = nil,
        subtitleFontStyle: BBFontStyle? = nil,
        actions: [Action],
        viewConfig: BBAlertViewConfiguration = BBAlertViewConfiguration(),
        config: BBAlertConfiguration = BBAlertConfiguration()
    ) -> Observable<Action> where Action: BBAlertActionType {
        
        return Observable<Action>.create { observer in
            let alert = BBAlert.text(
                title: title,
                titleFontStyle: titleFontStyle,
                subtitle: subtitle,
                subtitleFontStyle: subtitleFontStyle,
                viewConfig: viewConfig,
                config: config
            )
            
            for action in actions {
                let action = BBAlertAction(title: action.title, style: action.style) { alert in
                    observer.onNext(action)
                    alert?.close()
                }
                alert.addAction(action)
            }
            
            alert.show()
            
            return Disposables.create {
                alert.close()
            }
        }
        
    }
    
    /// 텍스트, 서브 텍스트와 이미지가 포함된 Alert를 생성합니다.
    /// - Parameters:
    ///   - image: 이미지
    ///   - imageTint: 이미지 강조 색상
    ///   - title: 타이틀 텍스트
    ///   - titleFontStyle: 타이틀의 폰트 스타일
    ///   - subtitle: 서브 타이틀 텍스트
    ///   - subtitleFontStyle: 서브 타이틀의 폰트 스타일
    ///   - actions: BBAlertActionType을 준수하는 열거형 케이스 배열
    ///   - viewConfig: AlertView 설정값
    ///   - config: Alert 설정값
    /// - Returns: Observable
    @discardableResult
    func show<Action>(
        image: UIImage? = nil,
        imageTint: UIColor? = nil,
        title: String,
        titleFontStyle: BBFontStyle? = nil,
        subtitle: String? = nil,
        subtitleFontStyle: BBFontStyle? = nil,
        actions: [Action],
        viewConfig: BBAlertViewConfiguration = BBAlertViewConfiguration(),
        config: BBAlertConfiguration = BBAlertConfiguration()
    ) -> Observable<Action> where Action: BBAlertActionType {
        
        return Observable<Action>.create { observer in
            let alert = BBAlert.image(
                image: image,
                imageTint: imageTint,
                title: title,
                titleFontStyle: titleFontStyle,
                subtitle: subtitle,
                subtitleFontStyle: subtitleFontStyle,
                viewConfig: viewConfig,
                config: config
            )
            
            for action in actions {
                let action = BBAlertAction(title: action.title, style: action.style) { alert in
                    observer.onNext(action)
                    alert?.close()
                }
                alert.addAction(action)
            }
            
            alert.show()
            
            return Disposables.create {
                alert.close()
            }
        }
        
    }
    
    /// 직접 커스텀한 뷰로 BBAlert을 생성합니다.
    /// - Parameters:
    ///   - child: BBAlertStackView 프로토콜을 준수하는 UIView
    ///   - actions: BBAlertActionType을 준수하는 열거형 케이스 배열
    ///   - viewConfig: AlertView 설정값
    ///   - config: Alert 설정값
    /// - Returns: Observable
    @discardableResult
    func show<Action>(
        child: any BBAlertStackView,
        actions: [Action],
        viewConfig: BBAlertViewConfiguration = BBAlertViewConfiguration(),
        config: BBAlertConfiguration = BBAlertConfiguration()
    ) -> Observable<Action> where Action: BBAlertActionType {
        
        return Observable<Action>.create { observer in
            let alert = BBAlert.custom(
                child,
                viewConfig: viewConfig,
                config: config
            )
            
            for action in actions {
                let action = BBAlertAction(title: action.title, style: action.style) { alert in
                    observer.onNext(action)
                    alert?.close()
                }
                alert.addAction(action)
            }
            
            alert.show()
            
            return Disposables.create {
                alert.close()
            }
        }
        
    }
    
    /// 정해진 Style의 Alert를 생성합니다.
    /// - Parameters:
    ///   - style: 스타일
    ///   - primaryAction: BBAlertActionType을 준수하는 열거형 케이스
    ///   - config: Alert 설정값
    /// - Returns: Observable
    @discardableResult
    func show<Action>(
        _ style: BBAlertStyle,
        primaryAction action: Action,
        config: BBAlertConfiguration = BBAlertConfiguration()
    ) -> Observable<Action> {
        
        return Observable<Action>.create { observer in
            let action: BBAlertActionHandler = { alert in
                observer.onNext(action)
                alert?.close()
            }
            
            let alert = BBAlert.style(
                style,
                primaryAction: action,
                config: config
            )
            
            alert.show()
            
            return Disposables.create {
                alert.close()
            }
        }
        
    }
    
    
}



// MARK: - BBAlertService

/// BBAlert를 조금 더 Rx스럽게 사용하도록 도와주는 서비스입니다.
///
/// 서비스의 **show(_:)** 메서드를 호출하기 전 버튼의 스타일과 액션이 정의된 **BBAlertActionType** 프로토콜을 준수하는 열거형을 선언해야 합니다.
///
/// ```swift
///
/// enum PickAlertAction: BBAlertActionType {
///    case pick
///    case cancel
///
///    var title: String? {
///    switch self {
///        case .pick: return "지금 하기"
///        case .cancel: return "다음에 하기"
///        }
///    }
///
///    var style: BBAlertActionStyle {
///        switch self {
///        case .pick: return .default
///        case .cancel: return .cancel
///        }
///    }
///}
/// ```
///
/// 이렇게 정의한 PickAlertAction 열거형의 케이스는 버튼 액션의 결과가 됩니다. 예를 들어, 지금 하기 버튼을 클릭하면 pick 케이스 항목이 방출되며, 방출된 아이템에 따라 flatMap 연산자에서 액션 분기 처리를 해줄 수 있습니다. 아래 코드는 버튼 액션을 받아 처리하는 방법을 보여줍니다.
///
/// ```swift
/// let actions: [PickAlertAction] = [.pick, .cancel]
///
///return provider.bbAlertService.show(
///        image: DesignSystemAsset.missionKeyGraphic.image,
///        title: "미션 열쇠 획득!",
///        subtitle: "열쇠를 획득해 잠금이 해제되었어요.",
///        actions: actions
///    )
///    .withUnretained(self)
///    .flatMap { // 버튼을 클릭하면 곧바로 해당하는 액션 항목이 방출됨
///    switch $0.1 {
///    case .pick:
///        return Observable<Mutation>.just(.setHiddenPickButton(true))
///
///    default:
///        return Observable<Mutation>.empty()
///    }
///}
/// ```
///
/// - Authors: 김소월
///
public final class BBAlertService: BaseService, BBAlertServiceType { }
