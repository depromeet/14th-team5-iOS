//
//  FetchMyUserNameUseCase.swift
//  Domain
//
//  Created by 김건우 on 8/10/24.
//

import Foundation

public protocol FetchMyUserNameUseCaseProtocol {
    func execute() -> String?
}

public class FetchMyUserNameUseCase: FetchMyUserNameUseCaseProtocol {
    
    // MARK: - Repositories
    let myRepository: MyRepositoryProtocol
    
    // MARK: - Intialzier
    public init(myRepository: MyRepositoryProtocol) {
        self.myRepository = myRepository
    }
    
    // MARK: - Execute
    public func execute() -> String? {
        myRepository.fetchMyUserName()
    }
    
}
