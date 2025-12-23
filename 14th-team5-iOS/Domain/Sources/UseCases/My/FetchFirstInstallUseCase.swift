//
//  FetchFirstInstallUseCase.swift
//  Domain
//
//  Created by 김도현 on 12/23/25.
//


public protocol FetchFirstInstallUseCaseProtocol {
    func execute() -> Bool
}

public final class FetchFirstInstallUseCase: FetchFirstInstallUseCaseProtocol {
    
    private let myRepositroy: MyRepositoryProtocol
    
    public init(myRepositroy: MyRepositoryProtocol) {
        self.myRepositroy = myRepositroy
    }
    
    public func execute() -> Bool {
        let hasInstalledBefore = myRepositroy.fetchFirstInstall() ?? false
        let hasCompletedOnboarding = myRepositroy.fetchIsFirstOnboarding() ?? false
        
        if !hasInstalledBefore {
            return true
        }
        
        if !hasCompletedOnboarding {
            myRepositroy.updateFirstInstall(true)
            return true
        }
        
        return false
    }
}
