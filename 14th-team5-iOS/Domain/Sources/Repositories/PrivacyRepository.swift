//
//  PrivacyRepository.swift
//  Domain
//
//  Created by Kim dohyun on 9/11/24.
//

import Foundation

import RxSwift
import RxCocoa


public protocol PrivacyRepositoryProtocol {
    func fetchPrivacyItems() -> Observable<Array<String>>
    func fetchAuthorizationItems() -> Observable<Array<String>>
}
