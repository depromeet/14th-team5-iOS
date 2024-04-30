//
//  GetTodayUseCaseProtocol.swift
//  Domain
//
//  Created by 마경미 on 21.04.24.
//

import Foundation

import RxSwift

public protocol GetTodayMissionUseCaseProtocol {
    func execute() -> Observable<TodayMissionData?>
}
