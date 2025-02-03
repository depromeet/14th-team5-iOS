//
//  CommentCellReactor.swift
//  App
//
//  Created by 김건우 on 1/18/24.
//

import Core
import Domain
import Foundation

import Differentiator
import ReactorKit
import RxSwift

final public class CommentCellReactor: Reactor {
    
    // MARK: - Action
    
    public enum Action {
        case fetchUserName
        case fetchProfileImage
        case didTapProfileButton
        case didTapPlayButton
    }
    
    
    // MARK: - Mutation
    
    public enum Mutation {
        case setMemberName(String)
        case setProfileImageUrl(URL?)
        case setEqualizerState(BBEqualizerState)
    }
    
    
    // MARK: - State
    
    public struct State {
        let comment: PostCommentEntity
        var memberName: String?
        var profileImageUrl: URL?
        var equalizerState : BBEqualizerState = .stop
    }
    
    
    // MARK: - Properties
    
    public var initialState: State
    
    @Injected var fetchUserNameUseCase: FetchUserNameUseCaseProtocol
    @Injected var fetchProfileImageUrlUseCase: FetchProfileImageUrlUseCaseProtocol
    @Injected var checkIsVaildMemberUseCase: CheckIsVaildMemberUseCaseProtocol
    
    @Injected var provider: ServiceProviderProtocol
    
    @Navigator var navigator: CommentNavigatorProtocol
    
    
    // MARK: - Intializer
    
    public init(_ comment: PostCommentEntity) {
        self.initialState = State(comment: comment)
    }
    
    
    // MARK: - Mutate
    
    public func mutate(action: Action) -> Observable<Mutation> {
        let memberId = initialState.comment.memberId
        
        switch action {
        case .fetchUserName:
            let memberName = fetchUserNameUseCase.execute(memberId: memberId)
            return Observable<Mutation>.just(.setMemberName(memberName))
            
        case .fetchProfileImage:
            let url = fetchProfileImageUrlUseCase.execute(memberId: memberId)
            return Observable<Mutation>.just(.setProfileImageUrl(url))
            
        case .didTapProfileButton:
            let isValid = checkIsVaildMemberUseCase.execute(memberId: memberId)
            if isValid {
                navigator.dismiss { [weak self] in
                    self?.navigator.toProfile(memberId: memberId)
                }
            }
            
            return Observable<Mutation>.empty()
        case .didTapPlayButton:
            let toggleState = currentState.equalizerState == .stop ? BBEqualizerState.play : .stop
            
            return .just(.setEqualizerState(toggleState))
        }
    }
    
    
    // MARK: - Reduce
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setMemberName(memberName):
            newState.memberName = memberName
            
        case let .setProfileImageUrl(url):
            newState.profileImageUrl = url
            
        case let .setEqualizerState(equalizerState):
            newState.equalizerState = equalizerState
        }
        
        return newState
    }
    
}


// MARK: - Extensions

extension CommentCellReactor: IdentifiableType, Equatable {
    
    // MARK: - IdentifiableType
    
    public typealias Identity = String
    public var identity: Identity {
        return initialState.comment.commentId
    }
    
    
    // MARK: - Equatable
    
    public static func == (lhs: CommentCellReactor, rhs: CommentCellReactor) -> Bool {
        return lhs.initialState.comment.commentId == rhs.initialState.comment.commentId
    }
}
