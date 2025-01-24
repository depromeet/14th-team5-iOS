//
//  AccountResignViewReactor.swift
//  App
//
//  Created by Kim dohyun on 1/1/24.
//

import Foundation

import Core
import Domain
import Util
import ReactorKit
import RxSwift

final class AccountResignViewReactor: Reactor {
    @Navigator var resignNavigator: AccountResignNavigatorProtocol
    @Injected var deleteAccountResignUseCase: DeleteMembersUseCaseProtocol
    @Injected var updateIsFirstOnboardingUseCase: UpdateIsFirstOnboardingUseCaseProtocol
    @Injected var fetchMyMemberIdUseCase: FetchMyMemberIdUseCaseProtocol
    var initialState: State
    
    enum Action {
        case viewDidLoad
        case didTappedReasonButton(ReasonType)
        case didTapResignButton
    }
    
    enum Mutation {
        case setReasonItems([ResignReasonTableViewCellReactor])
        case setSelected(ReasonType)
    }
    
    struct State {
        @Pulse var reasonSectionModel: [AccountResignSectionModel]
        var reasonType: ReasonType
    }
    
    init() {
        self.initialState = State(
            reasonSectionModel: [],
            reasonType: .none
        )
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            
            let reasonReactor = ReasonType.allCases.map { ResignReasonTableViewCellReactor(reasonType: $0) }
            
            return .just(.setReasonItems(reasonReactor))
            
        case let .didTappedReasonButton(reasonType):
            return .just(.setSelected(reasonType))
            
            
        case .didTapResignButton:
            MPEvent.Account.withdrawl.track(with: nil)
            
            guard let memberId = fetchMyMemberIdUseCase.execute() else {
                resignNavigator.showErrorToast()
                return .empty()
            }
            
            return deleteAccountResignUseCase.execute(memberId: memberId)
                .compactMap { $0 }
                .withUnretained(self)
                .flatMap { owner, entity -> Observable<Mutation> in
                    if entity.isSuccess {
                        owner.updateIsFirstOnboardingUseCase.execute(false)
                        App.Repository.token.clearAccessToken()
                        owner.resignNavigator.toSignIn()
                        return .empty()
                    }
                    return .empty()
                }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setSelected(reasonType):
            newState.reasonType = reasonType
        case let .setReasonItems(items):
            let dataSource = AccountResignSectionModel(model: (), items: items)
            newState.reasonSectionModel = [dataSource]
        }
        
        return newState
    }
    
}
