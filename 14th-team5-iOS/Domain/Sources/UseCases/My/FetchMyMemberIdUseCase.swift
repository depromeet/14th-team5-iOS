//
//  FetchMyMemberIdUseCase.swift
//  Domain
//
//  Created by 김건우 on 8/10/24.
//

import Foundation

public protocol FetchMyMemberIdUseCaseProtocol {
    func execute() -> String?
}

public class FetchMyMemberIdUseCase: FetchMyMemberIdUseCaseProtocol {
    
    // MARK: - Properties
    let myRepository: MyRepositoryProtocol
    
    // MARK: - Intializer
    public init(myRepository: MyRepositoryProtocol) {
        self.myRepository = myRepository
    }
    
    // MARK: - Execute
    public func execute() -> String? {
        myRepository.fetchMyMemberId()
    }
    
}
