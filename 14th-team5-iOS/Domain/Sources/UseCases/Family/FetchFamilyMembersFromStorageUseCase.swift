//
//  FetchFamilyMembersFromStorageUseCase.swift
//  Domain
//
//  Created by 김건우 on 6/15/24.
//

import Foundation

import RxSwift

public protocol FetchFamilyMembersUseCaseFromStorageProtocol {
    func execute(memberIds: [String]) -> [FamilyMemberProfileEntity]
}

public class FetchFamilyMembersFromStoragUseCase: FetchFamilyMembersUseCaseFromStorageProtocol {
    
    // MARK: - Repositories
    private var familyRepository: FamilyRepositoryProtocol
    
    // MARK: - Intializer
    public init(familyRepository: FamilyRepositoryProtocol) {
        self.familyRepository = familyRepository
    }
    
    // MARK: - Execute
    public func execute(memberIds: [String]) -> [FamilyMemberProfileEntity] {
        return familyRepository.fetchPaginationFamilyMembers(memberIds: memberIds)
    }
}

