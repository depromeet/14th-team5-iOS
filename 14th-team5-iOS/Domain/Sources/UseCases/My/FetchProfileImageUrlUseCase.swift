//
//  FetchProfileImageUrlUseCase.swift
//  Domain
//
//  Created by 김건우 on 8/10/24.
//

import Foundation

public protocol FetchProfileImageUrlUseCaseProtocol {
    func execute(memberId: String) -> URL?
}

public class FetchProfileImageUrlUseCase: FetchProfileImageUrlUseCaseProtocol {
    
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
    public func execute(memberId: String) -> URL? {
        if let urlString = myRepository.fetchProfileImageUrl(memberId: memberId) {
            return URL(string: urlString)
        }
        return nil
    }
    
}

