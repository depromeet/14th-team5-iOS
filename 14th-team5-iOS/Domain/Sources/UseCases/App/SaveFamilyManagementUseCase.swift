//
//  SaveFamilyManagementUseCase.swift
//  Domain
//
//  Created by 마경미 on 16.09.24.
//

import Foundation

import RxSwift

public protocol SaveFamilyManagementUseCaseProtocol {
    func execute(_ isFirst: Bool)
}

public class SaveFamilyManagementUseCase: SaveFamilyManagementUseCaseProtocol {
    
    private let repository: AppRepositoryProtocol
    
    public init(repository: AppRepositoryProtocol) {
        self.repository = repository
    }
    
    public func execute(_ isFirst: Bool) {
        repository.saveIsFirstFamilyManagement(isFirst: isFirst)
    }
}
