//
//  DeepLinkRepository.swift
//  Core
//
//  Created by 김건우 on 3/11/24.
//

import Foundation

import RxSwift
import RxCocoa

public class DeepLinkRepository: RxObject {
    public let notificationPostId = BehaviorRelay<String?>(value: nil)
    public let notificationOpenComment = BehaviorRelay<Bool?>(value: nil)
    public let notificationPostOfDate = BehaviorRelay<Date?>(value: nil)
    
    // public let widgetPostId = BehaviorSubject<String?>(value: nil)
    
    override public func bind() {}
    
    override public func unbind() {
        super.unbind()
    }
}

extension DeepLinkRepository {
    public func clearNotficiationUserInfo() {
        notificationPostId.accept(nil)
        notificationOpenComment.accept(nil)
        notificationPostOfDate.accept(nil)
    }
}
