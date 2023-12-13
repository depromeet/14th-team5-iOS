//
//  CameraDisplayViewRepository.swift
//  Data
//
//  Created by Kim dohyun on 12/11/23.
//

import Foundation

import RxSwift
import RxCocoa
import ReactorKit


public protocol CameraDisplayImpl: AnyObject {
    var disposeBag: DisposeBag { get }
    
}

public final class CameraDisplayViewRepository: CameraDisplayImpl {
    public init() { }
    
    
    public var disposeBag: DisposeBag = DisposeBag()
    
}
