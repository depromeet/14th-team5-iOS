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

<<<<<<< HEAD
public protocol AddFamilyImpl {
    var disposeBag: DisposeBag { get }
    
    func fetchInvitationUrl() -> Observable<URL?>
    func fetchFamilyMemeber() -> Observable<PaginationResponseFamilyMemberProfile?>
}

public final class AddFamilyRepository: AddFamilyImpl {
    public let disposeBag: DisposeBag = DisposeBag()
    
    private let apiWorker: AddFamilyAPIWorker = AddFamilyAPIWorker()
=======
public protocol FamilyImpl {
    var disposeBag: DisposeBag { get }
    
    func fetchInvitationUrl() -> Observable<URL?>
    func fetchFamiliyMemeber() -> Observable<PaginationResponseFamilyMemberProfile?>
}

<<<<<<<< HEAD:14th-team5-iOS/Data/Sources/Familiy/Repository/FamiliyRepository.swift
public final class FamiliyRepository: FamilyImpl {
========
public final class AddFamilyRepository: AddFamilyImpl {
>>>>>>>> 544612a (feat: FamilyMemeber 모델 수정 (#100)):14th-team5-iOS/Data/Sources/Familiy/Repository/AddFamilyRepository.swift
    public let disposeBag: DisposeBag = DisposeBag()
    
<<<<<<< HEAD:14th-team5-iOS/Data/Sources/Familiy/Repository/FamiliyRepository.swift
    private let apiWorker: FamiliyAPIWorker = FamiliyAPIWorker()
=======
    private let apiWorker: AddFamilyAPIWorker = AddFamilyAPIWorker()
>>>>>>> eb1eb16 (fix: 오타 수정  (#100)):14th-team5-iOS/Data/Sources/AddFamiliy/Repository/AddFamiliyRepository.swift
>>>>>>> 0ca0b9d (feat: FamilyMemeber 모델 수정 (#100))
    
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
<<<<<<< HEAD
    public func fetchFamilyMemeber() -> Observable<PaginationResponseFamilyMemberProfile?> {
=======
    public func fetchFamiliyMemeber() -> Observable<PaginationResponseFamilyMemberProfile?> {
>>>>>>> 0ca0b9d (feat: FamilyMemeber 모델 수정 (#100))
        return apiWorker.fetchFamilyMemeberPage(accessToken: TempStr.accessToken)
            .asObservable()
    }
}
