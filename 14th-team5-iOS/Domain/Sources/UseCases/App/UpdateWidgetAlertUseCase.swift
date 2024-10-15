//
//  UpdateWidgetAlertUseCase.swift
//  Domain
//
//  Created by 마경미 on 16.10.24.
//

import Foundation

import RxSwift

public protocol UpdateWidgetAlertUseCaseProtocol {
    func execute(_ isFirst: Bool)
}

public class UpdateWidgetAlertUseCase: UpdateWidgetAlertUseCaseProtocol {
    
    private let repository: AppRepositoryProtocol
    
    public init(repository: AppRepositoryProtocol) {
        self.repository = repository
    }
    
    public func execute(_ isFirst: Bool) {
        repository.saveIsFirstWidgetAlert(isFirst: isFirst)
    }
}
