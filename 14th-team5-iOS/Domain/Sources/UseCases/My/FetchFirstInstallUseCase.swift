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
        let isFirstInstall = myRepositroy.fetchFirstInstall()
        let hasCompletedOnboarding = myRepositroy.fetchIsFirstOnboarding()
        
        guard let firstInstall = isFirstInstall else {
            myRepositroy.updateFirstInstall(true)
            return true
        }
        
        if firstInstall {
            return true
        }
        
        if let onboarded = hasCompletedOnboarding, !onboarded {
            return true
        }
        
        return false
    }
}
