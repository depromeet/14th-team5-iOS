//
//  BBAlertDelegate.swift
//  BBAlert
//
//  Created by 김건우 on 8/9/24.
//

import Foundation

/// BBAlert의 생명 주기에 따라 필요한 동작을 정의하세요.
///
/// - Authors: 김소월
public protocol BBAlertDelegate: AnyObject {
    
    /// Alert이 화면에 나타나기 전 호출됩니다.
    ///
    /// - Note: Optional
    func willShowAlert(_ alert: BBAlert)
    
    /// Alert이 화면에 나타난 후 호출됩니다.
    ///
    /// - Note: Optional
    func didShowAlert(_ alert: BBAlert)
    
    /// Alert이 화면에 사라지기 전 호출됩니다.
    ///
    /// - Note: Optional
    func willCloseAlert(_ alert: BBAlert)
    
    /// Alert이 화면에 사라진 후 호출됩니다.
    ///
    /// - Note: Optional
    func didCloseAlert(_ alert: BBAlert)
    
    /// Alert의 버튼을 클릭하면 호출됩니다.
    ///
    /// BBAlertAction으로 미리 액션을 전달했다면 해당 메서드를 구현할 필요가 없습니다. 런타임에 동적으로 버튼의 액션이 바뀌어야 한다면 구현하세요.
    ///
    /// BBAlert 버튼의 배치 방향이 수직(vertical)라면 제일 위 버튼의 인덱스가 0이 됩니다. 배치 방향이 수평(horizontal)이라면 제일 왼쪽 버튼의 인덱스가 0이 됩니다.
    ///
    /// Alert의 버튼을 클릭하면 이 메서드가 먼저 호출되고, BBAlertAction에 정의된 액션이 실행됩니다.
    ///
    /// - Note: Optional
    func didTapAlertButton(_ alert: BBAlert?, index: Int?, button: BBButton)
    
}

public extension BBAlertDelegate {
    
    func willShowAlert(_ alert: BBAlert) { }
    func didShowAlert(_ alert: BBAlert) { }
    func willCloseAlert(_ alert: BBAlert) { }
    func didCloseAlert(_ alert: BBAlert) { }
    
    func didTapAlertButton(_ alert: BBAlert?, index: Int?, button: BBButton) { }
    
}
