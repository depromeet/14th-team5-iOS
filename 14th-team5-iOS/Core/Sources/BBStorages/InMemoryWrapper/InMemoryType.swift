//
//  InMemoryType.swift
//  Hello
//
//  Created by 김건우 on 6/2/24.
//

import Foundation

import RxSwift

public protocol InMemoryType {
    var disposeBag: DisposeBag { get }
    
    var inMemory: InMemoryWrapper { get }
    
    func bind()
    func unbind()
}

extension InMemoryType {
    public var inMemory: InMemoryWrapper {
        InMemoryWrapper.standard
    }
}
