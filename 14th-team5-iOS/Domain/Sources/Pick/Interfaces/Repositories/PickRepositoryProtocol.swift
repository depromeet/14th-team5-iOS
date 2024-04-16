//
//  PickRepositoryProtocol.swift
//  Domain
//
//  Created by 김건우 on 4/15/24.
//

import Foundation

import RxSwift

public protocol PickRepositoryProtocol {
    var disposeBag: DisposeBag { get }
    
    func pickMember(memberId: String) -> Observable<PickResponse?>
    func whoDidIPickMember(memberId: String) -> Observable<PickMemberListResponse?>
    func whoPickedMeMember(memberId: String) -> Observable<PickMemberListResponse?>
}
