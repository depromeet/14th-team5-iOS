//
//  LinkShareViewController.swift
//  Data
//
//  Created by 김건우 on 12/15/23.
//

import Foundation

import ReactorKit
import RxCocoa
import RxSwift

public protocol AddFamiliyImpl {
    var disposeBag: DisposeBag { get }
    
    func fetchInvitationUrl(_ familiyId: String) -> Observable<URL?>
}

public final class AddFamiliyViewRepository: AddFamiliyImpl {
    public let disposeBag: DisposeBag = DisposeBag()
    
    public init() { }
    
    public func fetchInvitationUrl(_ familiyId: String) -> Observable<URL?> {
        return Observable<URL?>.create { observer in
            observer.onNext(URL(string: "https://www.naver.com"))
            
            return Disposables.create()
        }
    }
}
