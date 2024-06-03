//
//  MissionAlertUseCaseProtocol.swift
//  Domain
//
//  Created by 마경미 on 03.06.24.
//

import Foundation

import RxSwift

public protocol CheckMissionAlertShowUseCaseProtocol {
    func execute() -> Observable<Bool>
}
