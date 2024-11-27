//
//  PickRepository.swift
//  Domain
//
//  Created by 김도현 on 11/27/24.
//

import Foundation

import RxSwift

public protocol PickRepositoryProtocol {
    /// CREATE
    func createMemberPickItem(memberId: String) -> Observable<CreateMemberPickEntity?>
}
