//
//  MeRepositoryProtocol.swift
//  Domain
//
//  Created by geonhui Yu on 1/5/24.
//

import Foundation
import RxSwift

public protocol MeRepositoryProtocol {
    func fetchMemberInfo() -> Single<MemberInfo?>
    func fetchAppVersion() -> Single<AppVersionInfo?>
}
