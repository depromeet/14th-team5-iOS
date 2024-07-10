//
//  PickAPIWorker.swift
//  Data
//
//  Created by 김건우 on 4/15/24.
//

import Core
import Domain
import Foundation

import RxSwift

typealias PickAPIWorker = PickAPIs.Worker
extension PickAPIs {
    public final class Worker: APIWorker {
        static let queue = {
            ConcurrentDispatchQueueScheduler(queue: DispatchQueue(label: "PickAPIQueue", qos: .utility))
        }()
        
        override public init() {
            super.init()
            self.id = "PickAPIWorker"
        }
    }
}


// MARK: - Extensions

extension PickAPIWorker {
    
    
    // MARK: - Pick Member
    
    private func pickMember(spec: APISpec, headers: [APIHeader]?) -> Single<PickEntity?> {
        return request(spec: spec, headers: headers)
            .subscribe(on: Self.queue)
            .map(PickResponseDTO.self)
            .catchAndReturn(nil)
            .map { $0?.toDomain() }
            .asSingle()
    }
    
    public func pickMember(memberId: String) -> Single<PickEntity?> {
        let spec = PickAPIs.pick(memberId).spec
        
        return Observable<Void>.just(())
            .withLatestFrom(self._headers)
            .observe(on: Self.queue)
            .withUnretained(self)
            .flatMap { $0.0.pickMember(spec: spec, headers: $0.1) }
            .asSingle()
    }
    
    
    
    // MARK: - Who Did I Pick?
    
    private func fetchWhoDidIPickMember(spec: APISpec, headers: [APIHeader]?) -> Single<PickMemberListEntity?> {
        return request(spec: spec, headers: headers)
            .subscribe(on: Self.queue)
            .map(PickMemberListResponseDTO.self)
            .catchAndReturn(nil)
            .map { $0?.toDomain() }
            .asSingle()
    }
    
    public func fetchWhoDidIPickMember(memberId: String) -> Single<PickMemberListEntity?> {
        let spec = PickAPIs.whoDidIPick(memberId).spec
        
        return Observable<Void>.just(())
            .withLatestFrom(self._headers)
            .observe(on: Self.queue)
            .withUnretained(self)
            .flatMap { $0.0.fetchWhoDidIPickMember(spec: spec, headers: $0.1) }
            .asSingle()
    }
    
    
    
    // MARK: - Who Picked Me?
    
    private func fetchWhoPickedMeMember(spec: APISpec, headers: [APIHeader]?) -> Single<PickMemberListEntity?> {
        return request(spec: spec, headers: headers)
            .subscribe(on: Self.queue)
            .map(PickMemberListResponseDTO.self)
            .catchAndReturn(nil)
            .map { $0?.toDomain() }
            .asSingle()
    }
    
    public func fetchWhoPickedMeMember(memberId: String) -> Single<PickMemberListEntity?> {
        let spec = PickAPIs.whoPickedMe(memberId).spec
        
        return Observable<Void>.just(())
            .withLatestFrom(self._headers)
            .observe(on: Self.queue)
            .withUnretained(self)
            .flatMap { $0.0.fetchWhoPickedMeMember(spec: spec, headers: $0.1) }
            .asSingle()
    }
    
    
    
    
}
