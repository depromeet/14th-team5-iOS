//
//  CheckWidgetAlertUseCaseprotocol.swift
//  Domain
//
//  Created by 마경미 on 15.10.24.
//

import RxSwift

public protocol CheckWidgetAlertUseCaseProtocol {
    func execute() -> Observable<Bool>
}

public class CheckWidgetAlertUseCase: CheckWidgetAlertUseCaseProtocol {
    
    private let repository: AppRepositoryProtocol
    
    public init(repository: AppRepositoryProtocol) {
        self.repository = repository
    }
    
    public func execute() -> Observable<Bool> {
        repository.loadIsFirstWidgetAlert()
            .map { ($0 ?? true) }
            .asObservable()
    }
}
