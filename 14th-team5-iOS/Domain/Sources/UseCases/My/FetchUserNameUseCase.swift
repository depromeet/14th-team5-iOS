//
//  FetchUserNameProtocol.swift
//  Domain
//
//  Created by 김건우 on 8/10/24.
//

import Foundation

public protocol FetchUserNameUseCaseProtocol {
    func execute(memberId: String) -> String
}

public class FetchUserNameUseCase: FetchUserNameUseCaseProtocol {
    
    // MARK: - Repositories
    let myRepository: MyRepositoryProtocol
    
    // MARK: - Intializer
    public init(myRepository: MyRepositoryProtocol) {
        self.myRepository = myRepository
    }
    
    // MARK: - Execute
    
    /// <#Description#>
    /// - Parameter memberId: <#memberId description#>
    /// - Returns: <#description#>
    public func execute(memberId: String) -> String {
        myRepository.fetchUserName(memberId: memberId) ?? "알 수 없음"
    }
    
}
