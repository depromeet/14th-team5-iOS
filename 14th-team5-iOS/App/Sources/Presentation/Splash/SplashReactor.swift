//
//  SplashReactor.swift
//  App
//
//  Created by 김건우 on 1/4/24.
//

import Foundation
import Core
import Domain

import ReactorKit
import RxSwift

public final class SplashViewReactor: Reactor {
    // MARK: - Action
    public enum Action {
        case viewDidLoad
    }
    
    // MARK: - Mutation
    public enum Mutation {
        case setMemberInfo(MemberInfo?)
        case setUpdateNeeded(AppVersionInfo?)
    }
    
    // MARK: - State
    public struct State {
        var memberInfo: MemberInfo?
        @Pulse var updatedNeeded: AppVersionInfo?
    }
    
    // MARK: - Properties
    private let meRepository: MeUseCaseProtocol
    public let initialState: State = State()
    
    // MARK: - Intializer
    init(meRepository: MeUseCaseProtocol) {
        self.meRepository = meRepository
    }
    
    // MARK: - Mutate
    public func mutate(action: Action) -> Observable<Mutation> {
        
        switch action {
        case .viewDidLoad:
            return meRepository.getAppVersion()
                .asObservable()
                .flatMap { appVersionInfo in
                    
                    guard let appVersionInfo = appVersionInfo else {
                        return Observable.just(Mutation.setUpdateNeeded(nil))
                    }
                    
                    return Observable.concat([
                        Observable.just(Mutation.setUpdateNeeded(appVersionInfo)),
                        self.meRepository.getMemberInfo()
                            .asObservable()
                            .flatMap { memberInfo in
                                Observable.just(Mutation.setMemberInfo(memberInfo))
                            }
                    ])
                }
        }
    }
    
    // MARK: - Reduce
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setMemberInfo(let memberInfo):
            App.Repository.member.memberID.accept(memberInfo?.memberId)
            App.Repository.member.familyId.accept(memberInfo?.familyId)
            
            newState.memberInfo = memberInfo
        case .setUpdateNeeded(let appVersion):
            newState.updatedNeeded = appVersion
        }
        
        return newState
    }
}
