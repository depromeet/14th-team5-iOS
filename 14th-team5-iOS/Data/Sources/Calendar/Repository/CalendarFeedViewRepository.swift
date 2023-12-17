//
//  CalendarFeedViewRepository.swift
//  Data
//
//  Created by 김건우 on 12/16/23.
//

import Foundation

import ReactorKit
import RxCocoa
import RxSwift

public protocol CalendarFeedImpl {
    var disposeBag: DisposeBag { get }
}

public final class CalendarFeedViewRepository: CalendarFeedImpl {
    public let disposeBag: DisposeBag = DisposeBag()
    
    public init() { }
}
