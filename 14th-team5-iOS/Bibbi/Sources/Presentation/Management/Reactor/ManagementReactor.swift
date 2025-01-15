//
//  LinkShareViewReactor.swift
//  App
//
//  Created by 김건우 on 12/11/23.
//

import Core
import DesignSystem
import Domain
import Util
import UIKit

import ReactorKit

public final class ManagementReactor: Reactor {
    
    // MARK: - Action
    
    public enum Action {
        case fetchFamilyGroupInfo
        case fetchPaginationFamilyMemeber(refresh: Bool)
        case didTapSharingContainer
        case didTapSettingBarButton
        case didTapFamilyNameEditButton
        case didSelectTableCell(IndexPath)
    }
    
    
    // MARK: - Mutate
    
    public enum Mutation {
        case setMemberDatasource([FamilyMemberCellReactor])
        
        case setHiddenSharingProgressHud(Bool)
        case setHiddenTableProgressHud(Bool)
        case setHiddenMemberFetchFailureView(Bool)
        case setEndRefreshing(Bool)
        
        case setFamilyName(String)
        case setMemberCount(Int)
    }
    
    
    // MARK: - State
    
    public struct State {
        @Pulse var memberDatasource: [FamilyMemberSectionModel] = [.init(model: (), items: [])]
        
        var hiddenSharingProgressHud: Bool = true
        var hiddenTableProgressHud: Bool = false
        var hiddenMemberFetchFailureView: Bool = true
        @Pulse var isRefreshing: Bool = false
        
        var familyName: String? = nil
        var memberCount: Int? = nil
    }
    
    
    // MARK: - Properties
    
    public let initialState: State
    
    @Navigator var navigator: ManagementNavigatorProtocol
    
    @Injected var fetchMyMemberIdIUseCase: FetchMyMemberIdUseCaseProtocol
    @Injected var fetchFamilyGroupInfoUseCase: FetchFamilyGroupInfoUseCaseProtocol
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
        let eventAction = provider.managementService.event
            .withUnretained(self)
            .flatMap {
                switch $0.1 {
                case .didUpdateFamilyInfo:
                    return Observable<Action>.merge(
                        Observable<Action>.just(.fetchFamilyGroupInfo),
                        Observable<Action>.just(.fetchPaginationFamilyMemeber(refresh: true))
                    )
                    
                @unknown default:
                    return Observable<Action>.empty()
                }
            }
        
        return Observable<Action>.merge(action, eventAction)
    }
    
    
    // MARK: - Mutate
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapSharingContainer:
            // Mixpanel
            MPEvent.Family.shareLink.track(with: nil)
            
            return Observable.concat(
                Observable<Mutation>.just(.setHiddenSharingProgressHud(false)),
                
                fetchSharingUrlUseCase.execute()
                    .withUnretained(self)
                    .concatMap {
                        guard let url = $0.1?.url else {
                            Haptic.notification(type: .error)
                            $0.0.provider.bbToastService.show(.error)
                            return Observable<Mutation>.just(.setHiddenSharingProgressHud(true))
                        }
                        
                        $0.0.navigator.presentSharingSheet(url: URL(string: url))
                        return Observable<Mutation>.just(.setHiddenSharingProgressHud(true))
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
            
        case .fetchFamilyGroupInfo:
            return fetchFamilyGroupInfoUseCase.execute()
                .flatMap {
                    guard let familyName = $0?.familyName else {
                        return Observable<Mutation>.just(.setFamilyName("나의 가족"))
                    }
                    return Observable<Mutation>.just(.setFamilyName(familyName))
                }
            
        case let .fetchPaginationFamilyMemeber(refresh):
            let query = FamilyPaginationQuery()
         
            return Observable.concat(
                Observable<Mutation>.just(.setHiddenTableProgressHud(refresh)),
                Observable<Mutation>.just(.setHiddenMemberFetchFailureView(true)),
                
                fetchFamilyMemberUseCase.execute(query: query)
                    .withUnretained(self)
                    .concatMap {
                        guard let results = $0.1?.results else {
                            Haptic.notification(type: .error)
                            $0.0.provider.bbToastService.show(.error)
                            return Observable.concat(
                                Observable<Mutation>.just(.setMemberDatasource([])),
                                Observable<Mutation>.just(.setHiddenTableProgressHud(true)),
                                Observable<Mutation>.just(.setHiddenMemberFetchFailureView(false)),
                                Observable<Mutation>.just(.setEndRefreshing(true))
                            )
                        }
                        
                        let items = results.sorted { [unowned self] in
                            self.checkIsMeUseCase.execute(memberId: $0.memberId) &&
                            !self.checkIsMeUseCase.execute(memberId: $1.memberId)
                        }.map { FamilyMemberCellReactor(.management, member: $0) }
                        
                        let memberCount = results.count
                        
                        return Observable.concat(
                            Observable<Mutation>.just(.setMemberDatasource(items)),
                            Observable<Mutation>.just(.setHiddenTableProgressHud(true)),
                            Observable<Mutation>.just(.setHiddenMemberFetchFailureView(true)),
                            Observable<Mutation>.just(.setEndRefreshing(true)),
                            Observable<Mutation>.just(.setMemberCount(memberCount))
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
        case let .setMemberDatasource(items):
            let dataSource = FamilyMemberSectionModel(model: (), items: items)
            newState.memberDatasource = [dataSource]
            
        case let .setHiddenSharingProgressHud(hidden):
            newState.hiddenSharingProgressHud = hidden
            
        case let .setHiddenTableProgressHud(hidden):
            newState.hiddenTableProgressHud = hidden
            
        case let .setHiddenMemberFetchFailureView(hidden):
            newState.hiddenMemberFetchFailureView = hidden
            
        case let .setEndRefreshing(isRefreshing):
            newState.isRefreshing = isRefreshing
            
        case let .setFamilyName(name):
            newState.familyName = name
            
        case let .setMemberCount(count):
            newState.memberCount = count
        }
        
        return newState
    }
    
}
