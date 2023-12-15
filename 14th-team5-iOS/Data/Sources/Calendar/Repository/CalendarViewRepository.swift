//
//  CalendarViewRepository.swift
//  Data
//
//  Created by 김건우 on 12/15/23.
//

import Foundation

import ReactorKit
import RxAlamofire
import RxCocoa
import RxSwift

protocol CalendarImpl {
    var disposeBag: DisposeBag { get }
}

public final class CalendarViewRepository: CalendarImpl {
    let disposeBag: DisposeBag = DisposeBag()
    
    public init() { }
}
