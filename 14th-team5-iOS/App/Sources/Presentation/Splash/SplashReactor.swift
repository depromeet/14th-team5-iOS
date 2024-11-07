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
import Data

public final class SplashReactor: Reactor {
    @Navigator var splashNavigator: SplashNavigatorProtocol
    
    // MARK: - Action
    public enum Action {
        case viewDidLoad
        case fetchFamily
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
    private let meRepository: MeUseCaseProtocol = MeUseCase(meRepository: MeAPIs.Worker()) // TODO: - Injected로 수정하기
    @Injected var familyUseCase: FamilyUseCaseProtocol
    
    @Injected var fetchFamilyCreatedAtUseCase: FetchFamilyCreatedAtUseCaseProtocol
    
    public let initialState: State = State()
    
    // MARK: - Intializer
    init() { }
    
    deinit {
        print(#function)
    }
    
    // MARK: - Mutate
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return meRepository.getAppVersion()
                    .asObservable()
                    .flatMap { [unowned self] appVersionInfo -> Observable<Mutation> in
                        guard let appVersionInfo = appVersionInfo else {
                            return Observable.just(Mutation.setUpdateNeeded(nil))
                        }
                        
                        return Observable.concat([
                            Observable.just(Mutation.setUpdateNeeded(appVersionInfo)),
                            
                            App.Repository.token.accessToken
                                .flatMap { token -> Observable<Mutation> in
                                    guard let _ = token else {
                                        self.splashNavigator.toSignIn()
                                        return Observable.just(Mutation.setMemberInfo(nil))
                                    }
                                    
                                    return self.meRepository.getMemberInfo()
                                        .asObservable()
                                        .flatMap { memberInfo -> Observable<Mutation> in
                                            guard let memberInfo = memberInfo,
                                                  let _ = memberInfo.familyId else {
                                                self.splashNavigator.toSignIn()
                                                return Observable.just(Mutation.setMemberInfo(nil))
                                            }
                                            
                                            return self.fetchFamilyCreatedAtUseCase.execute()
                                                .flatMap { familyInfo -> Observable<Mutation> in
                                                    
                                                    if memberInfo.familyId != nil {
                                                        if UserDefaults.standard.inviteCode != nil {
                                                            self.splashNavigator.toJoined()
                                                            return .just(.setMemberInfo(memberInfo))
                                                        } else {
                                                            self.splashNavigator.toHome()
                                                            return .just(.setMemberInfo(nil))
                                                        }
                                                    }
                                                    
                                                    self.splashNavigator.toJoinFamily()
                                                    return .just(.setMemberInfo(memberInfo))
                                                }
                                        }
                                }
                        ])
                    }
        case .fetchFamily:
            return familyUseCase.executeFetchPaginationFamilyMembers(query: .init())
                .asObservable()
                .flatMap { _ in return Observable<Mutation>.empty() }
        }
    }
    
    // MARK: - Reduce
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setMemberInfo(let memberInfo):
            if let memberInfo = memberInfo {
                // MeAPIWorker에서 UserDefaults와 App에 저장하고 있습니다~ (삭제해도 무방)
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
