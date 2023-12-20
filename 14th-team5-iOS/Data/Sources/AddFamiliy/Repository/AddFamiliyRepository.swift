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

public protocol AddFamiliyImpl {
    var disposeBag: DisposeBag { get }
    
    func fetchInvitationUrl(_ familiyId: String) -> Observable<URL?>
    func fetchFamiliyMemeber() -> Observable<[FamiliyMember]>
}

public final class AddFamiliyRepository: AddFamiliyImpl {
    public let disposeBag: DisposeBag = DisposeBag()
    
    private let apiWorker: AddFamiliyAPIWorker = AddFamiliyAPIWorker()
    
    public init() { }
    
    public func fetchInvitationUrl(_ familiyId: String) -> Observable<URL?> {
        return apiWorker.fetchInvitationUrl(familiyId)
            .asObservable()
            .map { familiyInvigationUrl in
                return URL(string: familiyInvigationUrl?.url ?? "")
            }
    }
    
    public func fetchFamiliyMemeber() -> Observable<[FamiliyMember]> {
        return apiWorker.fetchFamiliyMemeberPage()
            .asObservable()
            .map { familiyMemberPage in
                return familiyMemberPage?.members ?? []
            }
    }
}
