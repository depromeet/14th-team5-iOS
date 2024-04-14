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
        @Pulse var memberInfo: MemberInfo?
        @Pulse var updatedNeeded: AppVersionInfo?
    }
    
    // MARK: - Properties
    private let meRepository: MeUseCaseProtocol
    private let familyUseCase: FamilyUseCaseProtocol
    public let initialState: State = State()
    
    // MARK: - Intializer
    init(meRepository: MeUseCaseProtocol, familyUseCase: FamilyUseCaseProtocol) {
        self.meRepository = meRepository
        self.familyUseCase = familyUseCase
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
                            
                            App.Repository.token.accessToken
                                .flatMap { token -> Observable<Mutation> in
                                    guard let _ = token else {
                                        return Observable.just(Mutation.setMemberInfo(nil))
                                    }
                                    
                                    return self.meRepository.getMemberInfo()
                                        .asObservable()
                                        .withUnretained(self)
                                        .flatMap { owner, memberInfo in
                                            guard let memberInfo = memberInfo,
                                                  let familyId = memberInfo.familyId else {
                                                return Observable.just(Mutation.setMemberInfo(nil))
                                            }
                                            
                                            return Observable.concat([
                                                Observable.just(Mutation.setMemberInfo(memberInfo)),
                                                
                                                owner.familyUseCase.executeFetchCreatedAtFamily(familyId)
                                                    .flatMap { _ in Observable<Mutation>.empty() }
                                            ])
                                        }
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
            if let memberInfo = memberInfo {
                App.Repository.member.memberID.accept(memberInfo.memberId)
                App.Repository.member.familyId.accept(memberInfo.familyId)
            }
            newState.memberInfo = memberInfo
        case .setUpdateNeeded(let appVersion):
            newState.updatedNeeded = appVersion
        }
        
        return newState
    }
}
