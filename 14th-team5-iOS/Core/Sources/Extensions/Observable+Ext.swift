//
//  Observable+Ext.swift
//  Core
//
//  Created by 김건우 on 9/25/24.
//

import Foundation

import RxSwift
import RxCocoa

public extension Observable where Element == (HTTPURLResponse, Data) {
    
    /// 상태 코드가 올바른지 검사합니다.
    ///
    /// 상태 코드가 `range` 매개변수로 주어진 범위 내에 있다면 next 항목을 반환하고, 그렇지 않다면 error 항목을 방출합니다.
    /// - Parameter range: 정상 상태 코드 범위
    /// - Returns: Observable\<Data\>
    ///
    /// - Authors: 김소월
    func validate(statusCode range: Range<Int> = 200..<300) -> Observable<Data> {
        flatMap { element -> Observable<Data> in
            Observable<Data>.create { observer in
                let statusCode = element.0.statusCode
                if range ~= statusCode {
                    observer.onNext(element.1)
                } else {
                    observer.onError(BBAPIError.statusCode(statusCode))
                }
                return Disposables.create()
            }
        }
    }
    
}


public extension Observable where Element == Data {
    
    /// next 항목을 디코딩합니다.
    /// - Parameters:
    ///   - type: 디코딩하고자 하는 타입
    ///   - decoder: JSONDecoder 객체
    /// - Returns: Observable\<T\>
    ///
    /// - Authors: 김소월
    func decode<T: Decodable>(
        _ type: T.Type,
        using decoder: JSONDecoder = JSONDecoder()
    ) -> Observable<T> {
        flatMap { element -> Observable<T> in
            Observable<T>.create { observer in
                do {
                    let decodedData = try decoder.decode(type, from: element)
                    observer.onNext(decodedData)
                } catch {
                    observer.onError(BBAPIError.canNotDecode)
                }
                return Disposables.create()
            }
        }
    }
    
}
