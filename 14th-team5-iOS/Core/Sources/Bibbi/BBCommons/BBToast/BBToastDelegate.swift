//
//  ToastDelegate.swift
//  BBToast
//
//  Created by 김건우 on 7/8/24.
//

import Foundation

/// BBToast의 생명 주기에 따라 필요한 동작을 정의하세요.
///
/// - Authors: 김소월
public protocol BBToastDelegate: AnyObject {
    
    /// Toast가 화면에 나타나기 전 호출됩니다.
    ///
    /// - Note: Optional
    func willShowToast(_ toast: BBToast)
    
    /// Toast가 화면에 나타난 후 호출됩니다.
    ///
    /// - Note: Optional
    func didShowToast(_ toast: BBToast)
    
    /// Toast가 화면에 사라진 전 호출됩니다.
    ///
    /// - Note: Optional
    func willCloseToast(_ toast: BBToast)
    
    /// Toast가 화면에 사라진 후 호출됩니다.
    ///
    /// - Note: Optional
    func didCloseToast(_ toast: BBToast)
    
    /// Toast의 버튼을 클릭하면 호출됩니다.
    ///
    /// `setAction(_:)` 메서드로 미리 액션을 전달했다면 해당 메서드를 구현할 필요가 없습니다. 런타임에 동적으로 버튼의 액션이 바뀌어야 한다면 구현하세요.
    ///
    /// Toast의 버튼을 클릭하면 이 메서드가 먼저 호출되고, 전달한 액션이 실행됩니다.
    ///
    /// - Note: Optional
    func didTapToastButton(_ toast: BBToast?, index: Int?, button: BBButton)
    
}

public extension BBToastDelegate {
    
    func willShowToast(_ toast: BBToast) { }
    func didShowToast(_ toast: BBToast) { }
    func willCloseToast(_ toast: BBToast) { }
    func didCloseToast(_ toast: BBToast) { }
    
    func didTapToastButton(_ toast: BBToast, index: Int?, button: BBButton) { }
    
}
