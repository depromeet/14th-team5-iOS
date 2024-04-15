//
//  PickRepository.swift
//  Data
//
//  Created by 김건우 on 4/15/24.
//

import Core
import Domain
import Foundation

import RxSwift

public final class PickRepository: PickRepositoryProtocol {
    public let disposeBag: DisposeBag = DisposeBag()
    
    private let pickApiWorker: PickAPIWorker = PickAPIWorker()
    
    public init() { }
}

extension PickRepository {
    public func pickMember(memberId: String) -> Observable<PickResponse?> {
        return pickApiWorker.pickMember(memberId: memberId)
            .asObservable()
    }
    
    public func whoDidIPickMember(memberId: String) -> Observable<PickMemberListResponse?> {
        return pickApiWorker.fetchWhoDidIPickMember(memberId: memberId)
            .asObservable()
    }
    
    public func whoPickedMeMember(memberId: String) -> Observable<PickMemberListResponse?> {
        return pickApiWorker.fetchWhoPickedMeMember(memberId: memberId)
            .asObservable()
    }
}
