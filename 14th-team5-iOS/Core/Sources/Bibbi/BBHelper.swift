//
//  BBHelper.swift
//  BBToast
//
//  Created by 김건우 on 7/4/24.
//

import UIKit

final class BBHelper {
    
    /// 가장 최상위 뷰 컨트롤러를 반환합니다.
    /// UIWindow의 rootViewController에서부터 시작하여, 현재 계층 구조에서 최상위에 있는 뷰 컨트롤러를 탐색합니다.
    /// - Returns: 현재 계층에서 최상위에 있는 뷰 컨트롤러입니다. 만약 윈도우나 뷰 컨트롤러가 없다면 `nil`을 반환합니다.
    @available(*, deprecated, renamed: "topMostController")
    public static func topController() -> UIViewController? {
        if var topController = keyWindow()?.rootViewController {
            
            while let presentedController = topController.presentedViewController {
                topController = presentedController
            }
            return topController
            
        }
        
        return nil
    }
    
    
    /// 현재 최상위 뷰 컨트롤러를 재귀적으로 탐색하여 반환합니다.
    /// UINavigationController과 같은 컨테이너 컨트롤러의 경우, 선택된 하위 뷰 컨트롤러를 기준으로 탐색을 진행합니다.
    /// - Parameter base: 탐색의 시작점이 되는 UIViewController입니다. 기본값은 UIWindow의 rootViewController입니다.
    /// - Returns: 탐색을 통해 얻어진 최상위 뷰 컨트롤러입니다. 기본값인 `keyWindow()?.rootViewController`에서 시작해 최상위 컨트롤러를 반환하며, 없다면 `nil`을 반환합니다.
    public static func topMostController(base: UIViewController? = keyWindow()?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topMostController(base: nav.visibleViewController)
        }
        
        if let presented = base?.presentedViewController {
            return topMostController(base: presented)
        }
        
        return base
    }
    
    /// 키 윈도우를 반환합니다.
    /// - Returns: 키 원도우입니다.
    private static func keyWindow() -> UIWindow? {
        for scene in UIApplication.shared.connectedScenes {
            guard
                let windowScene = scene as? UIWindowScene
            else { continue }
            
            if windowScene.windows.isEmpty {
                continue
            }
            
            guard
                let window = windowScene.windows.first(where: { $0.isKeyWindow })
            else { continue }
            
            return window
        }
        
        return nil
    }
    
}
