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
    }
    
    // MARK: - State
    public struct State {
        var memberInfo: MemberInfo?
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
            meRepository.getMemberInfo()
                .asObservable()
                .flatMap { info in
                    guard let info else {
                        return Observable.just(Mutation.setMemberInfo(nil))
                    }
                    return Observable.just(Mutation.setMemberInfo(info))
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
        }
        
        return newState
    }
}
