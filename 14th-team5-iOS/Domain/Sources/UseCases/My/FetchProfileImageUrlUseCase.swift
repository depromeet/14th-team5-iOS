//
//  FetchProfileImageUrlUseCase.swift
//  Domain
//
//  Created by 김건우 on 8/10/24.
//

import Foundation

public protocol FetchProfileImageUrlUseCaseProtocol {
    func execute(memberId: String) -> String?
}

public class FetchProfileImageUrlUseCase: FetchProfileImageUrlUseCaseProtocol {
    
    // MARK: - Repositories
    let myRepository: MyRepositoryProtocol
    
    // MARK: - Intializer
    public init(myRepository: MyRepositoryProtocol) {
        self.myRepository = myRepository
    }
    
    // MARK: - Execute
    public func execute(memberId: String) -> String? {
        myRepository.fetchProfileImageUrl(memberId: memberId)
    }
    
}

