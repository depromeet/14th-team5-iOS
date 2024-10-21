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
    
    /// 매개변수로 주어진 멤버ID를 바탕으로 멤버 이름을 가져옵니다.
    /// - Parameter memberId: 멤버 ID입니다.
    /// - Returns: 멤버 이름 가져오기에 성공하면 멤버 이름을, 실패한다면 "알 수 없음" 문자열을 반환합니다.
    public func execute(memberId: String) -> String {
        myRepository.fetchUserName(memberId: memberId) ?? "알 수 없음"
    }
    
}
