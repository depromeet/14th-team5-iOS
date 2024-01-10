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
    
    private let familyId: String = App.Repository.member.familyId.value ?? "(가족ID 없음)"
    private let accessToken: String = App.Repository.token.accessToken.value?.accessToken ?? "(토큰 없음)"
    
    public init() { }
}

extension FamilyRepository {
    public func createFamily() -> Observable<FamilyResponse?> {
        return familyApiWorker.createFamily(token: accessToken)
            .asObservable()
    }
    
    public func fetchInvitationUrl() -> Observable<FamilyInvitationLinkResponse?> {
        debugPrint("= familyId: \(familyId)")
        debugPrint("= accessToken: \(accessToken)")
        return familyApiWorker.fetchInvitationUrl(token: accessToken, familyId: familyId)
            .asObservable()
    }
    
    public func fetchFamilyMembers() -> Observable<PaginationResponseFamilyMemberProfile?> {
        return familyApiWorker.fetchFamilyMemeberPage(token: accessToken)
            .asObservable()
    }
}
