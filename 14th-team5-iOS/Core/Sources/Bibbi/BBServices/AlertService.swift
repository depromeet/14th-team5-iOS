//
//  AlertService.swift
//  Core
//
//  Created by 김건우 on 10/23/24.
//

import UIKit

import RxSwift

// MARK: - AlertActionType

public protocol AlertActionType {
    
    /// 버튼의 타이틀입니다. 필수 구현입니다.
    var title: String? { get }
    
    /// 버튼의 스타일입니다. 선택 구현이며, 기본값은 `.default`입니다.
    var style: UIAlertAction.Style { get }
    
}

public extension AlertActionType {
    var style: UIAlertAction.Style {
        return .default
    }
}


// MARK: - AlertServiceType

public protocol AlertServiceType {
    @discardableResult
    func show<Action>(
        title: String?,
        message: String?,
        preferredStyle style: UIAlertController.Style,
        actions: [Action]
    ) -> Observable<Action> where Action: AlertActionType
}

public extension AlertServiceType {
    
    /// Alert를 생성합니다.
    /// - Parameters:
    ///   - title: Alert의 타이틀입니다.
    ///   - message: Alert의 메시지입니다.
    ///   - style: Alert의 스타일입니다.
    ///   - actions: `AlertActionType` 프로토콜을 준수하는 객체 배열입니다.
    /// - Returns: `AlertActionType` 프로토콜을 준수하는 객체 타입을 방출하는 `Observable`을 반환합니다,
    @discardableResult
    func show<Action>(
        title: String?,
        message: String?,
        preferredStyle style: UIAlertController.Style = .alert,
        actions: [Action]
    ) -> Observable<Action> where Action: AlertActionType {
        
        return Observable<Action>.create { observer in
            let alert = UIAlertController(
                title: title,
                message: message,
                preferredStyle: style
            )
            
            for action in actions {
                alert.addAction(
                    UIAlertAction(title: action.title, style: action.style) { _ in
                        observer.onNext(action)
                    }
                )
            }

            BBHelper.topMostController()?.present(alert, animated: true)
            
            return Disposables.create {
                alert.dismiss(animated: true)
            }
        }
        
    }
    
}


// MARK: - AlertService

public final class AlertService: BaseService, AlertServiceType { }
