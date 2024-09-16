//
//  JoinFamilyRepository.swift
//  Domain
//
//  Created by 마경미 on 13.01.24.
//

import Foundation
import RxSwift

@available(*, deprecated, renamed: "FamilyRepository")
public protocol JoinFamilyRepository {
    func joinFamily(body: JoinFamilyRequest) -> Single<JoinFamilyEntity?>
}
