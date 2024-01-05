//
//  MeUseCase.swift
//  Domain
//
//  Created by geonhui Yu on 1/5/24.
//

import Foundation
import RxSwift

public protocol MeUseCaseProtocol {
    func getMemberInfo() -> Single<MemberInfo?>
}

public class MeUseCase: MeUseCaseProtocol {
    private let meRepository: MeRepositoryProtocol
    
    public init(meRepository: MeRepositoryProtocol) {
        self.meRepository = meRepository
    }
    
    public func getMemberInfo() -> Single<MemberInfo?> {
        return meRepository.fetchMemberInfo()
    }
}
