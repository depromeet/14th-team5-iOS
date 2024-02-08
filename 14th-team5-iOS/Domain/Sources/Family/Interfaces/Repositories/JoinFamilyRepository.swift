//
//  JoinFamilyRepository.swift
//  Domain
//
//  Created by 마경미 on 13.01.24.
//

import Foundation
import RxSwift

public protocol JoinFamilyRepository {
    func joinFamily(body: JoinFamilyRequest) -> Single<JoinFamilyData?>
    func resignFamily() -> Single<AccountFamilyResignResponse?>
}
