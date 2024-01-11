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
    
    private var familyId: String = App.Repository.member.familyId.value ?? ""
    private var accessToken: String = App.Repository.token.accessToken.value?.accessToken ?? ""
    
    public init() { 
        bind()
    }
    
    private func bind() {
        App.Repository.member.familyId
            .withUnretained(self)
            .bind(onNext: { $0.0.familyId = $0.1 ?? "" })
            .disposed(by: disposeBag)
        
        App.Repository.token.accessToken
            .withUnretained(self)
            .bind(onNext: { $0.0.accessToken = $0.1?.accessToken ?? "" })
            .disposed(by: disposeBag)
    }
}

extension FamilyRepository {
    public func createFamily() -> Observable<FamilyResponse?> {
        return familyApiWorker.createFamily(token: accessToken)
            .asObservable()
    }
    
    public func fetchInvitationUrl() -> Observable<FamilyInvitationLinkResponse?> {
        return familyApiWorker.fetchInvitationUrl(token: accessToken, familyId: familyId)
            .asObservable()
    }
    
    public func fetchFamilyMembers() -> Observable<PaginationResponseFamilyMemberProfile?> {
        return familyApiWorker.fetchFamilyMemeberPage(token: accessToken)
            .asObservable()
    }
}
