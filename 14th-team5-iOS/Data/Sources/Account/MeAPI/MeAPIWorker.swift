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
extension MeAPIWorker: MeRepositoryProtocol {
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
    
    private func saveMemberInfo(_ memberInfo: MemberInfo) {
        App.Repository.member.memberID.accept(memberInfo.memberId)
        App.Repository.member.familyId.accept(memberInfo.familyId)
        
        let member: ProfileData = ProfileData(memberId: memberInfo.memberId, profileImageURL: memberInfo.imageUrl, name: memberInfo.name)
        FamilyUserDefaults.saveMemberToUserDefaults(familyMember: member)
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
            .do {
                guard let memberInfo = $0 else { return }
                self.saveMemberInfo(memberInfo)
            }
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
}
