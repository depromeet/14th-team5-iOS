//
//  FetchMainNightUseCaseProtocol.swift
//  Domain
//
//  Created by 마경미 on 07.05.24.
//

import Foundation

import RxSwift

public protocol FetchMainNightUseCaseProtocol {
    func execute() -> Observable<MainNightData?>
}
