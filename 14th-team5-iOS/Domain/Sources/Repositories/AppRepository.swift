//
//  AppRepository.swift
//  Domain
//
//  Created by 김건우 on 7/10/24.
//

import Foundation

import RxSwift

public protocol AppRepositoryProtocol {
    func fetchAppVersion() -> Observable<AppVersionEntity?>
}
