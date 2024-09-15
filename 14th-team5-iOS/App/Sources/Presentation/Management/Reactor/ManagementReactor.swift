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
        
        case setTableHeaderInfo((String, Int)?)
    }
    
    
    // MARK: - State
    
    public struct State {
        @Pulse var memberDatasource: [FamilyMemberSectionModel] = [.init(model: (), items: [])]
        
        var hiddenSharingProgressHud: Bool = true
        var hiddenTableProgressHud: Bool = false
        var hiddenMemberFetchFailureView: Bool = true
        @Pulse var isRefreshing: Bool = false
        
        var tableHeaderInfo: (String, Int)? = nil
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
            
            return Observable.concat(
                Observable<Mutation>.just(.setHiddenSharingProgressHud(false)),
                
                fetchSharingUrlUseCase.execute()
                    .withUnretained(self)
                    .concatMap {
                        guard let url = $0.1?.url else {
                            Haptic.notification(type: .error)
                            $0.0.navigator.showErrorToast()
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
                            $0.0.navigator.showErrorToast()
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
                        
                        return Observable.concat(
                            Observable<Mutation>.just(.setMemberDatasource(items)),
                            Observable<Mutation>.just(.setHiddenTableProgressHud(true)),
                            Observable<Mutation>.just(.setHiddenMemberFetchFailureView(true)),
                            Observable<Mutation>.just(.setEndRefreshing(true)),
                            Observable<Mutation>.just(.setTableHeaderInfo(("나의 가족", results.count)))
                        )
                        // TODO: - 가족 정보 반영 로직 구현하기
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
            
        case let .setTableHeaderInfo(headerInfo):
            newState.tableHeaderInfo = headerInfo
        }
        
        return newState
    }
    
}
