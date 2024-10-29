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
    
    /// 주어진 멤버ID를 바탕으로 멤버 프로필 이미지 URL을 반환합니다.
    /// - Parameter memberId: 멤버 ID입니다.
    /// - Returns: 이미지 URL이 있다면 `URL?`을, 그렇지 않으면 `nil`을 반환합니다.
    public func execute(memberId: String) -> URL? {
        if let urlString = myRepository.fetchProfileImageUrl(memberId: memberId) {
            return URL(string: urlString)
        }
        return nil
    }
    
}

