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
    func fetchFamiliyMemeber() -> Observable<PaginationResponseFamiliyMemberProfile?>
}

public final class AddFamiliyRepository: AddFamiliyImpl {
    public let disposeBag: DisposeBag = DisposeBag()
    
    private let apiWorker: AddFamiliyAPIWorker = AddFamiliyAPIWorker()
    
    public init() { }
    
    public func fetchInvitationUrl(_ familiyId: String) -> Observable<URL?> {
        return apiWorker.fetchInvitationUrl(familiyId)
            .asObservable()
            .compactMap { $0?.url }
            .map { urlString in
                guard let url = URL(string: urlString) else {
                    return nil
                }
                return url
            }
    }
    
    public func fetchFamiliyMemeber() -> Observable<PaginationResponseFamiliyMemberProfile?> {
        return apiWorker.fetchFamiliyMemeberPage()
            .asObservable()
    }
}
