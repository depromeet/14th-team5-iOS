//
//  CameraViewRepository.swift
//  Data
//
//  Created by Kim dohyun on 12/6/23.
//

import Foundation

import ReactorKit
import RxCocoa
import RxSwift

public protocol CameraViewImpl: AnyObject {
    var disposeBag: DisposeBag { get }

    func toggleCameraPosition(_ isState: Bool) -> Observable<Bool>
    func toggleCameraFlash(_ isState: Bool) -> Observable<Bool>
}



public final class CameraViewRepository: CameraViewImpl {

    public var disposeBag: DisposeBag = DisposeBag()
    
    public init() { }
    
    public func toggleCameraPosition(_ isState: Bool) -> Observable<Bool> {
        return Observable<Bool>
            .create { observer in
                observer.onNext(!isState)
                
                return Disposables.create()
        }
    }
    
    
    public func toggleCameraFlash(_ isState: Bool) -> Observable<Bool> {
        return .empty()
    }
    
}
