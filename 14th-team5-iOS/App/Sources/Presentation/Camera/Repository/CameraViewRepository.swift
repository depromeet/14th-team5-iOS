//
//  CameraViewRepository.swift
//  App
//
//  Created by Kim dohyun on 12/6/23.
//

import Foundation

import ReactorKit
import RxSwift

public protocol CameraViewImpl: AnyObject {
    var disposeBag: DisposeBag { get }
    
    func fetchUploadImage() -> Observable<CameraViewReactor.Mutation>
}



public final class CameraViewRepository: CameraViewImpl {

    public var disposeBag: DisposeBag = DisposeBag()
    
    public func fetchUploadImage() -> RxSwift.Observable<CameraViewReactor.Mutation> {
        
        return .empty()
    }
    
    
    
}
