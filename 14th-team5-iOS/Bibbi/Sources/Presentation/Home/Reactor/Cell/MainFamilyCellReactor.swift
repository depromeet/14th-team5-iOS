//
//  MainFamilyCellReactor.swift
//  App
//
//  Created by 마경미 on 21.04.24.
//


import Core
import UIKit
import DesignSystem
import Domain

import ReactorKit

enum RankBadge: Int {
    case one = 1
    case two = 2
    case three = 3
}


// MARK: - BBAlertActionType

enum PickAlertAction: BBAlertActionType {
    case pick
    case cancel
    
    var title: String? {
        switch self {
        case .pick: return "지금 하기"
        case .cancel: return "다음에 하기"
        }
    }
    
    var style: BBAlertActionStyle {
        switch self {
        case .pick: return .default
        case .cancel: return .cancel
        }
    }
}




// MARK: - Reactor

final class MainFamilyCellReactor: Reactor {
    
    // MARK: - Action
    enum Action {
        case fetchData
        
        case didTapPickButton
    }
    
    // MARK: - Mutation
    enum Mutation {
        case setData
        
        case setHiddenPickButton(Bool)
    }
    
    // MARK: - State
    struct State {
        let profileData: FamilyMemberProfileEntity
        var profile: (imageUrl: String?, name: String) = (nil, .none)
        var rank: Int? = nil
        var isShowBirthdayBadge: Bool = false
        
        var hiddenPickButton: Bool = false
    }
    
    // MARK: - Properties
    
    let initialState: State
        
    @Injected var pickMemberUseCase: CreateMembersPickUseCaseProtocol
    
    @Injected var provider: ServiceProviderProtocol
    
    // MARK: - Intializer
    init(_ profileData: FamilyMemberProfileEntity, service provider: ServiceProviderProtocol) {
        self.initialState = State(profileData: profileData)
        self.provider = provider
    }
    
    // MARK: - Transofrm
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let homeMutation = provider.mainService.event
            .flatMap { event in
                switch event {
                case let .showPickButton(show, id):
                    guard id == self.currentState.profileData.memberId else {
                        return Observable<Mutation>.empty()
                    }
                    return Observable<Mutation>.just(.setHiddenPickButton(show))
                
                default:
                    return Observable<Mutation>.empty()
                }
            }
        
        return Observable<Mutation>.merge(mutation, homeMutation)
    }
    
    // MARK: - Mutate
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchData:
            return Observable.just(.setData)
            
        case .didTapPickButton:
            let actions: [PickAlertAction] = [.pick, .cancel]
            let memberId = initialState.profileData.memberId
            let memberName = initialState.profileData.name

            return provider.bbAlertService.show(
                image: DesignSystemAsset.exhaustedBibbiGraphic.image,
                title: "생존 확인하기",
                subtitle: "\(memberName)님의 생존 여부를 물어볼까요?\n지금 알림이 전송됩니다.",
                actions: actions
            )
            .withUnretained(self)
            .flatMap {
                switch $0.1 {
                case .pick:
                    return $0.0.pickMemberUseCase.execute(memberId: memberId)
                        .withUnretained(self)
                        .flatMap {
                            guard
                                let entity = $0.1, entity.success
                            else {
                                $0.0.provider.bbToastService.show(.error)
                                return Observable<Mutation>.empty()
                            }
                            
                            $0.0.provider.bbToastService.show(
                                image: DesignSystemAsset.yellowPaperPlane.image,
                                imageTint: UIColor.mainYellow,
                                title: "\(memberName)님에게 생존신고 알림을 보냈어요"
                            )
                            return Observable<Mutation>.just(.setHiddenPickButton(true))
                        }
                    
                default:
                    return Observable<Mutation>.empty()
                }
            }
        }
    }
    
    // MARK: - Reduce
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setData:
            newState.profile = (currentState.profileData.profileImageURL, currentState.profileData.name)
            newState.rank = currentState.profileData.postRank
            newState.isShowBirthdayBadge = currentState.profileData.isShowBirthdayMark
            newState.hiddenPickButton = !currentState.profileData.isShowPickIcon
            
        case let .setHiddenPickButton(hidden):
            newState.hiddenPickButton = hidden
        }
        
        return newState
    }
    
}

// MARK: - Extensions
extension MainFamilyCellReactor: Equatable {
    
    static func == (lhs: MainFamilyCellReactor, rhs: MainFamilyCellReactor) -> Bool {
        lhs.initialState.id == rhs.initialState.id
    }
    
}

extension MainFamilyCellReactor.State: Identifiable {
    var id: UUID { UUID() }
}
