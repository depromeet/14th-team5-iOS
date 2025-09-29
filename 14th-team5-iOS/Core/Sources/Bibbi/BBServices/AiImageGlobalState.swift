//
//  AiImageGlobalState.swift
//  Core
//
//  Created by 김도현 on 9/29/25.
//

import Foundation

import RxSwift

public enum AiImageEvent {
    case imageUploadDidFinish(success: Bool)
}

public protocol AiImageGlobalStateType {
    var event: PublishSubject<AiImageEvent> { get }
    
    @discardableResult
    func imageUploadDidFinish(success: Bool) -> Observable<Bool>
}


public final class AiImageGlobalState: BaseService, AiImageGlobalStateType {
    
    public var event: PublishSubject<AiImageEvent> = PublishSubject<AiImageEvent>()
    
    
    public func imageUploadDidFinish(success: Bool) -> Observable<Bool> {
        event.onNext(.imageUploadDidFinish(success: success))
        
        return Observable<Bool>.just(success)
    }
    
    
    
}


