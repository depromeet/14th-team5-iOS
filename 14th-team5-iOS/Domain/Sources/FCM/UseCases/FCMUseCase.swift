//
//  NotificationUseCase.swift
//  Domain
//
//  Created by 마경미 on 20.02.24.
//

import Foundation

import RxSwift

public protocol FCMUseCaseProtocol {
    func executeSavingFCMToken(token: FCMToken) -> Single<Void?>
}

public class FCMUseCase: FCMUseCaseProtocol {
    private let FCMRepository: FCMRepositoryProtocol
    
    public init(FCMRepository: FCMRepositoryProtocol) {
        self.FCMRepository = FCMRepository
    }
    
    public func executeSavingFCMToken(token: FCMToken) -> RxSwift.Single<Void?> {
        return FCMRepository.saveFCMToken(token: token)
    }
}
