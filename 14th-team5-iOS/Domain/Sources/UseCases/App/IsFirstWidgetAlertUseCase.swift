//
//  CheckWidgetAlertUseCaseprotocol.swift
//  Domain
//
//  Created by 마경미 on 15.10.24.
//

import RxSwift

public protocol IsFirstWidgetAlertUseCaseProtocol {
    func execute() -> Observable<Bool>
}

public class IsFirstWidgetAlertUseCase: IsFirstWidgetAlertUseCaseProtocol {
    
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
