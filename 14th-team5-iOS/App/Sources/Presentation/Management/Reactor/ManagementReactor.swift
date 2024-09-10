//
//  LinkShareViewReactor.swift
//  App
//
//  Created by 김건우 on 12/11/23.
//

import UIKit

import Core
import Domain
import Differentiator
import ReactorKit
import RxSwift

public final class ManagementReactor: Reactor {
    
    // MARK: - Action
    
    public enum Action {
        case fetchPaginationFamilyMemebers(Bool)
        case didTapSharingContainer
        case didTapSettingBarButton
        case didSelectTableCell(IndexPath)
    }
    
    
    // MARK: - Mutate
    
    public enum Mutation {
        case setMemberDatasource([FamilyMemberCellReactor])
    }
    
    
    // MARK: - State
    
    public struct State {
        @Pulse var memberDatasource: [FamilyMemberSectionModel] = [.init(model: (), items: [])]
    }
    
    
    // MARK: - Properties
    
    public let initialState: State
    
    @Navigator var navigator: ManagementNavigatorProtocol
    
    @Injected var fetchMyMemberIdIUseCase: FetchMyMemberIdUseCaseProtocol
    @Injected var fetchFamilyMemberUseCase: FetchFamilyMembersUseCaseProtocol
    @Injected var fetchSharingUrlUseCase: FetchInvitationLinkUseCaseProtocol
    @Injected var checkIsMeUseCase: CheckIsMeUseCaseProtocol
    
    @Injected var provider: ServiceProviderProtocol
    
    
    // MARK: - Intializer
    
    init() {
        self.initialState = State()
    }
    
    
    // MARK: - Transform
    
    public func transform(action: Observable<Action>) -> Observable<Action> {
        let eventAction = provider.profileGlobalState.event
            .flatMap { event -> Observable<Action> in
                switch event {
                case .refreshFamilyMembers:
                    return Observable<Action>.just(.fetchPaginationFamilyMemebers(false))
                }
            }
        
        return Observable<Action>.merge(action, eventAction)
    }
    
    public func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let eventMutation = provider.managementService.event
            .withUnretained(self)
            .flatMap { owner, event -> Observable<Mutation> in
                switch event {
                case .didTapCopyUrlAction:
                    owner.navigator.showSuccessToast()
                    return Observable<Mutation>.empty()
                default:
                    return Observable<Mutation>.empty()
                }
            }
        
        return Observable<Mutation>.merge(mutation, eventMutation)
    }
    
    
    // MARK: - Mutate
    
    public func mutate(action: Action) -> Observable<Mutation> {
        let mangementService = provider.managementService
        
        switch action {
        case .didTapSharingContainer:
            // Mixpanel
            MPEvent.Family.shareLink.track(with: nil)
            
            mangementService.hiddenSharingProgressHud(hidden: false)
            return Observable.concat(
                
                fetchSharingUrlUseCase.execute()
                    .withUnretained(self)
                    .concatMap {
                        guard let sharingUrl = $0.1?.url else {
                            Haptic.notification(type: .error)
                            mangementService.hiddenSharingProgressHud(hidden: true)
                            $0.0.navigator.showErrorToast()
                            
                            return Observable<Mutation>.empty()
                        }
                        
                        mangementService.hiddenSharingProgressHud(hidden: true)
                        $0.0.navigator.presentSharingSheet(url: URL(string: sharingUrl))
                        return Observable<Mutation>.empty()
                    }
            )
            
        case .didTapSettingBarButton:
            if let memberId = fetchMyMemberIdIUseCase.execute() {
                navigator.toSetting(memberId: memberId)
            }
            return Observable<Mutation>.empty()
            
        case let .fetchPaginationFamilyMemebers(refresh):
            let query = FamilyPaginationQuery()
         
            return Observable.concat(
                fetchFamilyMemberUseCase.execute(query: query)
                    .withUnretained(self)
                    .concatMap {
                        guard let memberResponse = $0.1?.results else {
                            Haptic.notification(type: .error)
                            mangementService.hiddenTableProgressHud(hidden: true)
                            mangementService.hiddenMemberFetchFailureView(hidden: false)
                            $0.0.navigator.showErrorToast()
                            
                            return Observable<Mutation>.just(.setMemberDatasource([]))
                        }
                        
                        mangementService.hiddenTableProgressHud(hidden: true)
                        mangementService.hiddenMemberFetchFailureView(hidden: true)
                        mangementService.setTableHeaderInfo(familyName: "나의 가족", memberCount: memberResponse.count)
                        return Observable<Mutation>.just(
                            .setMemberDatasource(
                                memberResponse.map { [weak self] member in
                                    let isMe = self?.checkIsMeUseCase.execute(memberId: member.memberId) ?? false
                                    
                                    return FamilyMemberCellReactor(
                                        of: .management,
                                        member: member,
                                        isMe: isMe
                                    )
                                }
                            )
                        )
                    }
            )
            
        case let .didSelectTableCell(indexPath):
            if let dataSource = currentState.memberDatasource.first {
                let memberId = dataSource.items[indexPath.row].initialState.member.memberId
                navigator.toProfile(memberId: memberId)
            }
            
            return Observable<Mutation>.empty()
        }
    }
    
    
    // MARK: - Reduce
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
            
        case let .setMemberDatasource(members):
            guard
                var dataSource = currentState.memberDatasource.first
            else { break }
            dataSource.items = members.sorted { $0.currentState.isMe && !$1.currentState.isMe }
            newState.memberDatasource = [dataSource]
        }
        return newState
    }
}
