//
//  FetchFamilyMembersUseCase.swift
//  Domain
//
//  Created by 김건우 on 6/15/24.
//

import Foundation

import RxSwift

public protocol FetchFamilyMembersUseCaseProtocol {
    func execute(query: FamilyPaginationQuery) -> Observable<PaginationResponseFamilyMemberProfileEntity?>
    func execute(memberIds: [String]) -> [MemberInfoEntity]
}

public class FetchFamilyMembersUseCase: FetchFamilyMembersUseCaseProtocol {
    
    // MARK: - Repositories
    private var familyRepository: FamilyRepositoryProtocol
    
    // MARK: - Intializer
    public init(familyRepository: FamilyRepositoryProtocol) {
        self.familyRepository = familyRepository
    }
    
    /// From Network
    public func execute(query: FamilyPaginationQuery) -> Observable<PaginationResponseFamilyMemberProfileEntity?> {
        return familyRepository.fetchPaginationFamilyMembers(query: query)
    }
    
    /// From Storage
    public func execute(memberIds: [String]) -> [MemberInfoEntity] {
        return familyRepository.fetchPaginationFamilyMembers(memberIds: memberIds)
    }
}
