//
//  ProfileViewRepository.swift
//  Data
//
//  Created by Kim dohyun on 12/17/23.
//

import Foundation

import RxSwift


public protocol ProfileViewImpl: AnyObject {
    var disposeBag: DisposeBag { get }
    
}


public final class ProfileViewRepository: ProfileViewImpl {
    
    public var disposeBag: DisposeBag = DisposeBag()
    
    public init() { }
    
}
