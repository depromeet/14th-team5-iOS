//
//  PrivacyViewInterface.swift
//  Domain
//
//  Created by Kim dohyun on 1/1/24.
//

import Foundation

import RxSwift


public protocol PrivacyViewInterface: AnyObject {
    var disposeBag: DisposeBag { get }
    
    func fetchPrivacyItem() -> Observable<Array<String>>
    func fetchAuthorizationItem() -> Observable<Array<String>>
    func fetchBibbiAppVersion(parameter: Encodable) -> Observable<BibbiStoreInfoResponse>
    func fetchAccountLogout() -> Observable<Void>
}
