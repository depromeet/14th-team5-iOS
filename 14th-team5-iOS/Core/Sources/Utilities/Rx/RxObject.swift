//
//  RxObject.swift
//  Core
//
//  Created by geonhui Yu on 12/14/23.
//

import Foundation

import RxSwift

public class RxObject: NSObject {
    
    // MARK: - Properties
    private(set) var disposeBag = DisposeBag()
    
    // MARK: - Bind
    func bind() {}
    func unbind() {
        disposeBag = DisposeBag()
    }
}
