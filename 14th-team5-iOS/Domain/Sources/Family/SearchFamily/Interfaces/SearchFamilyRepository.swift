//
//  SearchFamilyRepository.swift
//  Domain
//
//  Created by 마경미 on 24.12.23.
//

import RxSwift

public protocol SearchFamilyRepository {
    
    func fetchFamilyMember(query: SearchFamilyQuery) -> Single<SearchFamilyPage>
    
}
