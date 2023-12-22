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
