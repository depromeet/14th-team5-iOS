//
//  InMemoryWrapper.swift
//  Core
//
//  Created by 김건우 on 5/20/24.
//

import Foundation

import RxSwift
import RxCocoa

final public class InMemoryWrapper {
    
    // MARK: - Properties
    public static var standard = InMemoryWrapper()
    
    private var userDefaults = UserDefaultsWrapper()
    
    private var disposeBag = DisposeBag()
    
    
    
    
    // MARK: - InMemoryStores
    public var familyId = InMemoryStore<String>()
    public var familyCreatedAt = InMemoryStore<String>()
    
    
    
    
    
    
    // MARK: - Intializer
    private init() { }
    
    // MARK: - Bind
    public func bind() {
        familyId.stream
            .compactMap { $0 }
            .bind(with: self) { owner, id in
                owner.userDefaults[.familyId] = id
            }
            .disposed(by: disposeBag)
        
        familyCreatedAt.stream
            .compactMap { $0 }
            .bind(with: self) { owner, createdAt in
                owner.userDefaults[.familyCreatedAt] = createdAt
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Unbind
    public func unbind() {
        disposeBag = DisposeBag()
    }
    
}
