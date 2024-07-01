//
//  DeepLinkRepository.swift
//  Core
//
//  Created by 김건우 on 3/13/24.
//

import Foundation

import RxSwift
import RxCocoa

@available(*, deprecated, message: "KeyChainWrapper 혹은 UserDefaultsWrpper 사용")
public class DeepLinkRepository: RxObject {
    public let notification = BehaviorRelay<NotificationDeepLink?>(value: nil)
    public let widget = BehaviorRelay<WidgetDeepLink?>(value: nil)
 
    public override func bind() { }
    
    public override func unbind() {
        super.unbind()
    }
}


