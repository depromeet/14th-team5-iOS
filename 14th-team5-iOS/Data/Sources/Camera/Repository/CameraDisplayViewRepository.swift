//
//  CameraDisplayViewRepository.swift
//  Data
//
//  Created by Kim dohyun on 12/11/23.
//

import Foundation

import Core
import RxSwift
import RxCocoa
import ReactorKit


public protocol CameraDisplayImpl: AnyObject {
    var disposeBag: DisposeBag { get }
    func generateDescrption(with keyword: String) -> Observable<Array<String>>
}

public final class CameraDisplayViewRepository: CameraDisplayImpl {
    public init() { }
    
    
    public var disposeBag: DisposeBag = DisposeBag()
    
    
    public func generateDescrption(with keyword: String) -> RxSwift.Observable<Array<String>> {
        
        let item: Array<String> = Array(keyword).map { String($0) }
        return Observable.create { observer in
            observer.onNext(item)
            
            return Disposables.create()
        }
    }
    
}
