//
//  NotificationRepositoryProtocol.swift
//  Domain
//
//  Created by 마경미 on 20.02.24.
//

import Foundation

import RxSwift

public protocol FCMRepositoryProtocol {
    func saveFCMToken(token: FCMToken) -> Single<Void?>
    func deleteFCMToken() -> Single<Void?>
}
