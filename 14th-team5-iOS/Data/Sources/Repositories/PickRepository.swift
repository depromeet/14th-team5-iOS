//
//  PickRepository.swift
//  Data
//
//  Created by 김도현 on 11/27/24.
//

import Foundation

import Domain
import RxSwift

public final class PickRepository {
    
    public let disposeBag: DisposeBag = DisposeBag()
    private let membersAPIWorker: MembersWorker = MembersWorker()
    
    public init() { }
}


extension PickRepository: PickRepositoryProtocol {
    public func createMemberPickItem(memberId: String) -> Observable<CreateMemberPickEntity?> {
        return membersAPIWorker.createMemberPick(memberId: memberId)
            .map { $0?.toDomain() }
    }
}
