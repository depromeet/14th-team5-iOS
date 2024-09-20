//
//  BBAlertService.swift
//  Core
//
//  Created by 김건우 on 9/20/24.
//

import UIKit

import RxSwift


// MARK: - BBAlertActionType

public protocol BBAlertActionType {
    var title: String? { get }
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

public final class BBAlertService: BaseService, BBAlertServiceType { }
