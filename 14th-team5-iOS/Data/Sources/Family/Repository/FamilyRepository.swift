//
//  LinkShareViewController.swift
//  Data
//
//  Created by 김건우 on 12/15/23.
//

import Foundation

import Domain
import ReactorKit
import RxCocoa
import RxSwift

public final class FamilyRepository: FamilyRepositoryProtocol {
    public let disposeBag: DisposeBag = DisposeBag()
    
    private let familyApiWorker: FamilyAPIWorker = FamilyAPIWorker()
    
    public init() { }
    
    public func fetchInvitationUrl() -> Observable<URL?> {
        return familyApiWorker.fetchInvitationUrl()
            .asObservable()
            .compactMap { $0?.url }
            .map { urlString in
                guard let url = URL(string: urlString) else {
                    return nil
                }
                return url
            }
    }
    
    public func fetchFamilyMembers() -> Observable<PaginationResponseFamilyMemberProfile?> {
        return familyApiWorker.fetchFamilyMemeberPage()
            .asObservable()
    }
}
