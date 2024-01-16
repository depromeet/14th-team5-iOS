//
//  MeAPIWorker.swift
//  Data
//
//  Created by geonhui Yu on 1/3/24.
//

import Foundation
import Domain
import Core

import RxSwift
import Alamofire

fileprivate typealias _PayLoad = MeAPIs.PayLoad
typealias MeAPIWorker = MeAPIs.Worker
extension MeAPIs {
    public final class Worker: APIWorker {
        
        static let queue = {
            ConcurrentDispatchQueueScheduler(queue: DispatchQueue(label: "MeAPIQueue", qos: .utility))
        }()
        
        public override init() {
            super.init()
            self.id = "MeAPIWorker"
        }
        
        // MARK: Values
        private var _headers: Observable<[APIHeader]?> {
            return App.Repository.token.accessToken
                .map {
                    guard let token = $0, let accessToken = token.accessToken, !accessToken.isEmpty else { return [] }
                    return [BibbiAPI.Header.xAppKey, BibbiAPI.Header.xAuthToken(accessToken), BibbiAPI.Header.acceptJson]
                }
        }
    }
}

// MARK: SignIn
extension MeAPIWorker: MeRepositoryProtocol, JoinFamilyRepository {
    private func saveFcmToken(headers: [APIHeader]?, jsonEncodable: Encodable) -> Single<String?> {
        let spec = MeAPIs.saveFcmToken.spec
        
        return request(spec: spec, headers: headers)
            .subscribe(on: Self.queue)
            .do(onNext: {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("saveFcmToken result : \(str)")
                }
            })
            .map(String.self)
            .catchAndReturn(nil)
            .asSingle()
    }
    
    public func saveFcmToken(token: String) -> Single<String?> {
        
        let payload = _PayLoad.FcmPayload(fcmToken: token)
        
        return Observable.just(())
            .withLatestFrom(self._headers)
            .withUnretained(self)
            .flatMap { $0.0.saveFcmToken(headers: $0.1, jsonEncodable: payload) }
            .asSingle()
    }
    
    private func deleteFcmToken(spec: APISpec, headers: [APIHeader]?) -> Single<String?> {
        return request(spec: spec, headers: headers)
            .subscribe(on: Self.queue)
            .do(onNext: {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("deleteFcmToken result : \(str)")
                }
            })
            .map(String.self)
            .catchAndReturn(nil)
            .asSingle()
    }
    
    public func deleteFcmToken(token: String) -> Single<String?> {
        let spec = MeAPIs.deleteFcmToken(token).spec
        
        return Observable.just(())
            .withLatestFrom(self._headers)
            .withUnretained(self)
            .flatMap { $0.0.deleteFcmToken(spec: spec, headers: $0.1) }
            .asSingle()
    }
    
    private func getMemberInfo(spec: APISpec, headers: [APIHeader]?) -> Single<MemberInfo?> {
        
        return request(spec: spec, headers: headers)
            .subscribe(on: Self.queue)
            .do(onNext: {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("getMemberInfo result : \(str)")
                }
            })
            .map(MemberInfo.self)
            .catchAndReturn(nil)
            .asSingle()
    }
    
    public func fetchMemberInfo() -> Single<MemberInfo?> {
        let spec = MeAPIs.memberInfo.spec
        return Observable.just(())
            .withLatestFrom(self._headers)
            .withUnretained(self)
            .flatMap { $0.0.getMemberInfo(spec: spec, headers: $0.1)}
            .asSingle()
    }
    
    private func joinFamily(spec: APISpec, headers: [APIHeader]?, jsonEncodable: Encodable) -> Single<FamilyInfo?> {
        
        return request(spec: spec, headers: headers, jsonEncodable: jsonEncodable)
            .subscribe(on: Self.queue)
            .do(onNext: {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("Join Family result : \(str)")
                }
            })
            .map(FamilyInfo.self)
            .catchAndReturn(nil)
            .asSingle()
    }
    
    public func joinFamily(body: JoinFamilyRequest) -> Single<JoinFamilyData?> {
        return Observable.just(())
            .withLatestFrom(self._headers)
            .withUnretained(self)
            .flatMap { $0.0.joinFamily(headers: $0.1, body: body) }
            .asSingle()
    }
    
    private func joinFamily(headers: [APIHeader]?, body: Domain.JoinFamilyRequest) -> RxSwift.Single<JoinFamilyData?> {

        let spec = MeAPIs.joinFamily.spec
        let requestDTO: JoinFamilyRequestDTO = JoinFamilyRequestDTO(inviteCode: body.inviteCode)
        return request(spec: spec, headers: headers, jsonEncodable: requestDTO)
        .subscribe(on: Self.queue)
        .do {
            if let str = String(data: $0.1, encoding: .utf8) {
                debugPrint("Join Family Fetch Result: \(str)")
            }
        }
        .map(JoinFamilyResponseDTO.self)
        .catchAndReturn(nil)
        .map { $0?.toDomain() }
        .asSingle()
    }
    
    public func joinFamily(with inviteCode: String) -> Single<FamilyInfo?> {
        
        let payload = _PayLoad.FamilyPayload(inviteCode: inviteCode)
        let spec = MeAPIs.joinFamily.spec
        
        return Observable.just(())
            .withLatestFrom(self._headers)
            .withUnretained(self)
            .flatMap { $0.0.joinFamily(spec: spec, headers: $0.1, jsonEncodable: payload) }
            .asSingle()
    }
}
