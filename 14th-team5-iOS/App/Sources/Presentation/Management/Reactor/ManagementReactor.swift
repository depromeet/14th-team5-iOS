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
        case fetchPaginationFamilyMemebers
        case didTapSharingContainer
        case didTapSettingBarButton
        case didTapFamilyNameEditButton
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
        let managementService = provider.managementService
        
        switch action {
        case .didTapSharingContainer:
            // Mixpanel
            MPEvent.Family.shareLink.track(with: nil)
            
            managementService.hiddenSharingProgressHud(hidden: false)
            return Observable.concat(
                
                fetchSharingUrlUseCase.execute()
                    .withUnretained(self)
                    .concatMap {
                        guard let sharingUrl = $0.1?.url else {
                            Haptic.notification(type: .error)
                            managementService.hiddenSharingProgressHud(hidden: true)
                            $0.0.navigator.showErrorToast()
                            
                            return Observable<Mutation>.empty()
                        }
                        
                        managementService.hiddenSharingProgressHud(hidden: true)
                        $0.0.navigator.presentSharingSheet(url: URL(string: sharingUrl))
                        return Observable<Mutation>.empty()
                    }
            )
            
        case .didTapSettingBarButton:
            if let memberId = fetchMyMemberIdIUseCase.execute() {
                navigator.toSetting(memberId: memberId)
            }
            return Observable<Mutation>.empty()
            
        case .didTapFamilyNameEditButton:
            navigator.toFamilyNameSetting()
            return Observable<Mutation>.empty()
            
        case .fetchPaginationFamilyMemebers:
            let query = FamilyPaginationQuery()
         
            return Observable.concat(
                fetchFamilyMemberUseCase.execute(query: query)
                    .withUnretained(self)
                    .concatMap {
                        guard let results = $0.1?.results else {
                            Haptic.notification(type: .error)
                            managementService.hiddenTableProgressHud(hidden: true)
                            managementService.hiddenMemberFetchFailureView(hidden: false)
                            $0.0.navigator.showErrorToast()
                            managementService.endTableRefreshing()
                            
                            return Observable<Mutation>.just(.setMemberDatasource([]))
                        }
                        
                        managementService.hiddenTableProgressHud(hidden: true)
                        managementService.hiddenMemberFetchFailureView(hidden: true)
                        // TODO: - 새로운 가족 이름 반영하기
                        managementService.setTableHeaderInfo(familyName: "나의 가족", memberCount: results.count)
                        managementService.endTableRefreshing()
                        return Observable<Mutation>.just(
                            .setMemberDatasource(
                                results.map { [weak self] member in
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
