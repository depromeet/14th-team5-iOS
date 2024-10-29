//
//  ObservableType+Ext.swift
//  Core
//
//  Created by 김건우 on 10/3/24.
//

import Foundation

import RxSwift

public extension ObservableType {
    
    func map<O, E>(
        with object: O,
        _ handler: @escaping (O, Element) -> E
    ) -> Observable<E> where O: AnyObject {
        flatMap { [weak object] element in
            guard let object else { return Observable<E>.empty() }
            return Observable<E>.just(handler(object, element))
        }
    }
    
    /// 기존 `flatMap` 연산자에 with 매개변수를 붙인 새로운 연산자입니다.
    /// - Parameters:
    ///   - object: 약한 참조하고자 하는 객체
    ///   - handler: flatMap 연산 핸들러
    /// - Returns: Observable\<E\>
    ///
    /// - Authors: 김소월
    func flatMap<O, E>(
        with object: O,
        _ handler: @escaping (O, Element) -> Observable<E>
    ) -> Observable<E> where O: AnyObject {
        flatMap { [weak object] element in
            guard let object else { return Observable<E>.empty() }
            return handler(object, element)
        }
    }
    
}

public extension ObservableType {
    
    /// 스트림에서 받은 error 항목이 매개변수로 주어진 `type`으로 변환이 가능하다면, 에러 처리를 합니다.
    ///
    /// - Parameters:
    ///   - object: 약한 참조를 하고자 하는 객체입니다.
    ///   - type: 변환하고자 하는 에러 타입입니다. `Error` 프로토콜을 준수하는 타입이어야 합니다. 기본값은 `(any Error).self`입니다.
    ///   - handler: 에러 처리를 하는 핸들러입니다.
    /// - Returns: Observable\<Element\>
    ///
    /// - Authors: 김소월
    func catchError<O, E>(
        with object: O,
        of type: E.Type = (any Error).self,
        handler: @escaping (O, E) -> Observable<Element>
    ) -> Observable<Element> where O: AnyObject, E: Error {
        
        return `catch` { [weak object] error in
            guard let object else { return .empty() }
            if let castedError = error as? E {
                return handler(object, castedError)
            }
            return .empty()
        }
        
    }
    
    /// 스트림에서 `APIWorker` 타입의 error 항목을 받으면 에러 처리를 합니다.
    ///
    /// - Parameters:
    ///   - object: 약한 참조를 하고자 하는 객체입니다.
    ///   - handler: 에러 처리를 하는 핸들러입니다.
    /// - Returns: Observable\<Element\>
    ///
    /// - Authors: 김소월
    func catchAPIWorkerError<O>(
        with object: O,
        handler: @escaping (O, APIWorkerError) -> Observable<Element>
    ) -> Observable<Element> where O: AnyObject {
    
        return catchError(with: object, of: APIWorkerError.self, handler: handler)
        
    }
    
    
    /// 스트림에서 error 항목을 받으면 스트림을 종료합니다.
    /// - Authors: 김소월
    func catchErrorJustComplete() -> Observable<Element> {
        return `catch` { _ in
            Observable.empty()
        }
    }
    
}
