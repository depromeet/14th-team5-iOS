//
//  UpdateExistingUserUseCase.swift
//  Domain
//
//  Created by 김도현 on 12/23/25.
//

import Foundation

public protocol UpdateExistingUserUseCaseProtocol {
    func execute()
}

public final class UpdateExistingUserUseCase: UpdateExistingUserUseCaseProtocol {
    
    private let myRepository: MyRepositoryProtocol
    
    public init(myRepository: MyRepositoryProtocol) {
        self.myRepository = myRepository
    }
    
    public func execute() {
        myRepository.updateFirstInstall(false)
    }
}
