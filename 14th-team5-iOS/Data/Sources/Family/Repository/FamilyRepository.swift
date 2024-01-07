//
//  LinkShareViewController.swift
//  Data
//
//  Created by 김건우 on 12/15/23.
//

import Core
import Domain
import Foundation

import RxSwift

public final class FamilyRepository: FamilyRepositoryProtocol {
    public let disposeBag: DisposeBag = DisposeBag()
    
    private let familyApiWorker: FamilyAPIWorker = FamilyAPIWorker()
    
    private let familyId: String = App.Repository.member.familyId.value ?? ""
    private let accessToken: String = App.Repository.token.accessToken.value?.accessToken ?? ""
    public init() { }
}

extension FamilyRepository {
    public func fetchInvitationUrl() -> Observable<FamilyInvitationLinkResponse?> {
        return familyApiWorker.fetchInvitationUrl(token: accessToken, familyId: familyId)
            .asObservable()
    }
    
    public func fetchFamilyMembers() -> Observable<PaginationResponseFamilyMemberProfile?> {
        return familyApiWorker.fetchFamilyMemeberPage(token: accessToken)
            .asObservable()
    }
}
