//
//  AccountResignInterface.swift
//  Domain
//
//  Created by Kim dohyun on 1/2/24.
//

import Foundation

import RxSwift

public protocol AccountResignInterface: AnyObject {
    var disposeBag: DisposeBag { get }
    
    func fetchAccountResign(memberId: String) -> Observable<AccountResignResponse>
    func fetchAccountFcmResign(fcmToken: String) -> Observable<AccountFcmResignResponse>
}
