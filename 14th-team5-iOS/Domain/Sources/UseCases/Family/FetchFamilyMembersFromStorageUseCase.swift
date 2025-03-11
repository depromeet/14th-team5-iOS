//
//  FetchFamilyMembersFromStorageUseCase.swift
//  Domain
//
//  Created by 김건우 on 6/15/24.
//

import Foundation

import RxSwift

// NOTE:- 삭제하기
public protocol FetchFamilyMembersUseCaseFromStorageProtocol {
    func execute(memberIds: [String]) -> [MemberInfoEntity]
}

public class FetchFamilyMembersFromStoragUseCase: FetchFamilyMembersUseCaseFromStorageProtocol {
    
    // MARK: - Repositories
    private var familyRepository: FamilyRepositoryProtocol
    
    // MARK: - Intializer
    public init(familyRepository: FamilyRepositoryProtocol) {
        self.familyRepository = familyRepository
    }
    
    // MARK: - Execute
    public func execute(memberIds: [String]) -> [MemberInfoEntity] {
        return familyRepository.fetchPaginationFamilyMembers(memberIds: memberIds)
    }
}

