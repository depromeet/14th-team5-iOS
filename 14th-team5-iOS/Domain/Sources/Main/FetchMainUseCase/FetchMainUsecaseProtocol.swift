//
//  MainUseCaseProtocol.swift
//  Domain
//
//  Created by 마경미 on 20.04.24.
//

import Foundation

import RxSwift

public protocol FetchMainUseCaseProtocol {
    func execute() -> Observable<MainData?>
}
