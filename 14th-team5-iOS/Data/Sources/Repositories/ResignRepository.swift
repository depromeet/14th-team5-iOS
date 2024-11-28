//
//  ResignRepository.swift
//  Data
//
//  Created by 김도현 on 11/27/24.
//

import Foundation

import Domain
import RxSwift

public final class ResignRepository {
    private let disposeBag: DisposeBag = DisposeBag()
    private let membersAPIWorker: MembersWorker = MembersWorker()
    
    public init() { }
}


extension ResignRepository: ResignRepositoryProtocol {
    public func deleteMemberItem(memberId: String) -> Observable<DeleteMemberEntity?> {
        
        return membersAPIWorker.deleteMember(memberId: memberId)
            .map { $0?.toDomain() }
    }
}
