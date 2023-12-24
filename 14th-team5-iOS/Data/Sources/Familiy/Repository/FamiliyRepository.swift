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

public protocol FamilyImpl {
    var disposeBag: DisposeBag { get }
    
    func fetchInvitationUrl() -> Observable<URL?>
    func fetchFamiliyMemeber() -> Observable<PaginationResponseFamilyMemberProfile?>
}

public final class FamiliyRepository: FamilyImpl {
    public let disposeBag: DisposeBag = DisposeBag()
    
    private let apiWorker: FamiliyAPIWorker = FamiliyAPIWorker()
    
    public init() { }
    
    // TODO: - FamiliyID, AccessToken 구하는 코드 구현
    public func fetchInvitationUrl() -> Observable<URL?> {
        return apiWorker.fetchInvitationUrl(TempStr.familyId, accessToken: TempStr.accessToken)
            .asObservable()
            .compactMap { $0?.url }
            .map { urlString in
                guard let url = URL(string: urlString) else {
                    return nil
                }
                return url
            }
    }
    
    // TODO: - AccessToken 구하는 코드 구현
    public func fetchFamiliyMemeber() -> Observable<PaginationResponseFamilyMemberProfile?> {
        return apiWorker.fetchFamilyMemeberPage(accessToken: TempStr.accessToken)
            .asObservable()
    }
}
