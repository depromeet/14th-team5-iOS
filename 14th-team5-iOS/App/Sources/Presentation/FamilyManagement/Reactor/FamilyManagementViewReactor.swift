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

public final class FamilyManagementViewReactor: Reactor {
    // MARK: - Action
    public enum Action {
        case fetchPaginationFamilyMemebers
        case didTapShareContainer
        case didSelectTableCell(IndexPath)
    }
    
    // MARK: - Mutate
    public enum Mutation {
        case setSharePanel(String?)
        case setCopySuccessToastMessageView
        case setUrlFetchFailureToastMessageView
        case setFamilyFetchFailureToastMessageView
        case setHiddenPaperAirplaneLottieView(Bool)
        case pushProfileVC(String)
        case injectFamilyId(String?)
        case injectFamilyMembers([FamilyMemberProfileCellReactor])
        case generateErrorHapticNotification
    }
    
    // MARK: - State
    public struct State {
        var familyId: String?
        @Pulse var familyInvitationUrl: URL?
        @Pulse var shouldPushProfileVC: String
        @Pulse var shouldPresentCopySuccessToastMessageView: Bool
        @Pulse var shouldPresentUrlFetchFailureToastMessageView: Bool
        @Pulse var shouldPresentFamilyFetchFailureToastMessageView: Bool
        @Pulse var shouldGenerateErrorHapticNotification: Bool
        var shouldPresentPaperAirplaneLottieView: Bool
        @Pulse var displayFamilyMember: [FamilyMemberProfileSectionModel]
        var displayFamilyMemberCount: Int
    }
    
    // MARK: - Properties
    public let initialState: State
    
    public let memberUseCase: MemberUseCaseProtocol
    public let familyUseCase: FamilyViewUseCaseProtocol
    public let provider: GlobalStateProviderProtocol
    
    // MARK: - Intializer
    init(
        memberUseCase: MemberUseCaseProtocol,
        familyUseCase: FamilyViewUseCaseProtocol,
        provider: GlobalStateProviderProtocol
    ) {
        self.initialState = State(
            familyId: nil,
            familyInvitationUrl: nil,
            shouldPushProfileVC: .none,
            shouldPresentCopySuccessToastMessageView: false,
            shouldPresentUrlFetchFailureToastMessageView: false,
            shouldPresentFamilyFetchFailureToastMessageView: false,
            shouldGenerateErrorHapticNotification: false,
            shouldPresentPaperAirplaneLottieView: false,
            displayFamilyMember: [.init(model: (), items: [])],
            displayFamilyMemberCount: 0
        )
        
        self.memberUseCase = memberUseCase
        self.familyUseCase = familyUseCase
        self.provider = provider
    }
    
    // MARK: - Transform
    public func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let eventMutation = provider.activityGlobalState.event
            .flatMap { event -> Observable<Mutation> in
                switch event {
                case .didTapCopyInvitationUrlAction:
                    return Observable<Mutation>.just(.setCopySuccessToastMessageView)
                default:
                    return Observable<Mutation>.empty()
                }
            }
        
        return Observable<Mutation>.merge(mutation, eventMutation)
    }
    
    // MARK: - Mutate
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapShareContainer:
            MPEvent.Family.shareLink.track(with: nil)
            return Observable.concat(
                provider.activityGlobalState.hiddenInvitationUrlIndicatorView(true)
                    .flatMap({ _ in Observable<Mutation>.empty() }),
                
                familyUseCase.executeFetchInvitationUrl()
                    .withUnretained(self)
                    .concatMap({
                        guard let invitationLink = $0.1?.url else {
                            return Observable.concat(
                                Observable<Mutation>.just(.generateErrorHapticNotification),
                                Observable<Mutation>.just(.setUrlFetchFailureToastMessageView),
                                $0.0.provider.activityGlobalState.hiddenInvitationUrlIndicatorView(false)
                                    .flatMap({ _ in Observable<Mutation>.empty() })
                            )
                        }
                        return Observable.concat(
                            Observable<Mutation>.just(.setSharePanel(invitationLink)),
                            $0.0.provider.activityGlobalState.hiddenInvitationUrlIndicatorView(false)
                                .flatMap({ _ in Observable<Mutation>.empty() })
                        )
                    })
            )
            
        case .fetchPaginationFamilyMemebers:
            let query = FamilyPaginationQuery()
         
            return Observable.concat(
                Observable<Mutation>.just(.setHiddenPaperAirplaneLottieView(false)),
                
                familyUseCase.executeFetchPaginationFamilyMembers(query: query)
                    .withUnretained(self)
                    .concatMap {
                        guard let familyResponse = $0.1?.results else {
                            // TODO: - 불러오기 실패 예외 UI 구현하기
                            return Observable<Mutation>.concat(
                                Observable<Mutation>.just(.injectFamilyMembers([])),
                                Observable<Mutation>.just(.setFamilyFetchFailureToastMessageView),
                                Observable<Mutation>.just(.generateErrorHapticNotification),
                                Observable<Mutation>.just(.setHiddenPaperAirplaneLottieView(true))
                            )
                            
                        }
                        
                        return Observable.concat(
                            Observable<Mutation>.just(
                                .injectFamilyMembers(
                                    familyResponse.map {
                                        FamilyMemberProfileCellReactor(
                                            $0, isMe: self.memberUseCase.executeCheckIsMe(memberId: $0.memberId)
                                        )
                                    }
                                )
                            ),
                            Observable<Mutation>.just(.setHiddenPaperAirplaneLottieView(true))
                        )
                    }
            )
            
        case let .didSelectTableCell(indexPath):
            guard let dataSource = currentState.displayFamilyMember.first else {
                return Observable<Mutation>.empty()
            }
            let memberId = dataSource.items[indexPath.row].initialState.memberId
            
            return Observable<Mutation>.just(.pushProfileVC(memberId))
        }
    }
    
    // MARK: - Reduce
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setSharePanel(urlString):
            newState.familyInvitationUrl = URL(string: urlString ?? "")
            
        case .setCopySuccessToastMessageView:
            newState.shouldPresentCopySuccessToastMessageView = true
            
        case .setUrlFetchFailureToastMessageView:
            newState.shouldPresentUrlFetchFailureToastMessageView = true
            
        case .setFamilyFetchFailureToastMessageView:
            newState.shouldPresentFamilyFetchFailureToastMessageView = true
            
        case let .setHiddenPaperAirplaneLottieView(hidden):
            newState.shouldPresentPaperAirplaneLottieView = hidden
            
        case let .pushProfileVC(memberId):
            newState.shouldPushProfileVC = memberId
            
        case let .injectFamilyId(familyId):
            newState.familyId = familyId
            
        case let .injectFamilyMembers(familyMembers):
            guard var dataSource = currentState.displayFamilyMember.first else {
                break
            }
            dataSource.items.append(contentsOf: familyMembers)
            dataSource.items.sort {
                $0.currentState.isMe && !$1.currentState.isMe
            }
            
            newState.displayFamilyMember = [dataSource]
            newState.displayFamilyMemberCount = familyMembers.count
            
        case .generateErrorHapticNotification:
            newState.shouldGenerateErrorHapticNotification = true
        }
        return newState
    }
}

extension FamilyManagementViewController {
    private func shouldFetchNextPage(contentOffsetY: CGFloat, frameHehgit: CGFloat) -> Bool {
        return false
    }
}
