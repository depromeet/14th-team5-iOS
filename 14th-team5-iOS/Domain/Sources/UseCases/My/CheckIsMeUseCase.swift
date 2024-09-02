//
//  CheckIsMeUseCase.swift
//  Domain
//
//  Created by 김건우 on 8/10/24.
//

import Foundation

public protocol CheckIsMeUseCaseProtocol {
    func execute(memberId: String) -> Bool
}

public class CheckIsMeUseCase: CheckIsMeUseCaseProtocol {
    
    // MARK: - Repositories
    let myRepository: MyRepositoryProtocol
    
    // MARK: - Intializer
    public init(myRepository: MyRepositoryProtocol) {
        self.myRepository = myRepository
    }
    
    // MARK: - Execute
    public func execute(memberId: String) -> Bool {
        memberId == myRepository.fetchMyMemberId()
    }
    
}
