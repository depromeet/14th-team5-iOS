//
//  ResignRepository.swift
//  Domain
//
//  Created by 김도현 on 11/27/24.
//

import Foundation

import RxSwift

public protocol ResignRepositoryProtocol {
    /// DELETE
    func deleteMemberItem(memberId: String) -> Observable<DeleteMemberEntity?>
}
