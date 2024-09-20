//
//  BBAlertAction.swift
//  Core
//
//  Created by 김건우 on 9/18/24.
//

import UIKit
    
/// 버튼의 타이틀, 스타일과 액션을 설정하는 클래스입니다. 
///
/// BBAlert 객체의 `actions` 프로퍼티에 할당하면 얼럿에 버튼과 액션이 적용됩니다. `handler`에 아무런 액션을 적용하지 않으면 Alert을 닫는 동작이 기본적으로 적용됩니다.
///
/// - Authors: 김소월
public class BBAlertAction {
    
    // MARK: - Properties
    
    /// 버튼의 타이틀을 설정합니다.
    public var title: String?
    
    /// 버튼의 스타일을 설정합니다.
    ///
    ///  - seealso: `BBAlertAction.Style`
    public var style: BBAlertActionStyle
    
    /// 버튼의 액션을 설정합니다.
    public var handler: BBAlertActionHandler
    
    
    // MARK: - Intializer
    
    /// 버튼의 타이틀, 스타일과 액션을 설정하는 클래스입니다.
    /// - Parameters:
    ///   - title: 버튼의 타이틀
    ///   - style: 버튼의 스타일
    ///   - handler: 버튼의 액션
    public init(
        title: String? = nil,
        style: BBAlertActionStyle = .default,
        handler: BBAlertActionHandler = nil
    ) {
        self.title = title
        self.style = style
        self.handler = handler
    }
    
}
    
