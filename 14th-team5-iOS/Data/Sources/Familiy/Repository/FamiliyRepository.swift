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
    
<<<<<<< HEAD:14th-team5-iOS/Data/Sources/Familiy/Repository/FamiliyRepository.swift
    private let apiWorker: FamiliyAPIWorker = FamiliyAPIWorker()
=======
    private let apiWorker: AddFamilyAPIWorker = AddFamilyAPIWorker()
>>>>>>> eb1eb16 (fix: 오타 수정  (#100)):14th-team5-iOS/Data/Sources/AddFamiliy/Repository/AddFamiliyRepository.swift
    
    // NOTE: - 임시 코드
    private let tempFamiliyId = "TempFamiliyID"
    private let tempToken = "eyJyZWdEYXRlIjoxNzAzMDg4ODc0MzI4LCJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiIsInR5cGUiOiJhY2Nlc3MifQ.eyJ1c2VySWQiOiJkd3EiLCJleHAiOjE3MDMxNzUyNzR9.SHUs4Sn9eb2q7TesgstMdfpSxVpKRWpiWqm6tPdYbH0"
    
    public init() { }
    
    // TODO: - FamiliyID, AccessToken 구하는 코드 구현
    public func fetchInvitationUrl() -> Observable<URL?> {
        return apiWorker.fetchInvitationUrl(tempFamiliyId, accessToken: tempToken)
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
        return apiWorker.fetchFamilyMemeberPage(accessToken: tempToken)
            .asObservable()
    }
}
