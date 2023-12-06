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
    //TODO: 임시 코드
    func fetchUploadImage() -> Observable<Void>
    
}



public final class CameraViewRepository: CameraViewImpl {

    public var disposeBag: DisposeBag = DisposeBag()
    
    public init() { }
    
    public func fetchUploadImage() -> Observable<Void> {
        return .empty()
    }
    
}
