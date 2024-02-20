//
//  SearchFamilyRepository.swift
//  Domain
//
//  Created by 마경미 on 24.12.23.
//

import RxSwift

@available(*, deprecated, renamed: "FamilyRepository")
public protocol SearchFamilyRepository {
    func getSavedFamilyMember(memberIds: [String]) -> [ProfileData]?
    func fetchFamilyMember(query: SearchFamilyQuery) -> Single<SearchFamilyPage?>
}
