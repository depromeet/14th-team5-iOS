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

public protocol LinkShareImpl {
    var disposeBag: DisposeBag { get }
    
    func responseInvitationUrl(_ familiyId: String) -> Observable<URL?>
}

public final class LinkShareViewRepository: LinkShareImpl {
    public let disposeBag: DisposeBag = DisposeBag()
    
    public init() { }
    
    public func responseInvitationUrl(_ familiyId: String) -> Observable<URL?> {
        return Observable<URL?>.create { observer in
            observer.onNext(URL(string: "https://www.naver.com"))
            
            return Disposables.create()
        }
    }
}
