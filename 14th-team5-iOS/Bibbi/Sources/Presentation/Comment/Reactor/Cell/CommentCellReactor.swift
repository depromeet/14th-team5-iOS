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
        case didTapPlayButton(String)
        case prepareForReuse
    }
    
    
    // MARK: - Mutation
    
    public enum Mutation {
        case setMemberName(String)
        case setProfileImageUrl(URL?)
        case setEqualizerState(BBEqualizerState)
        case setPlayAudioId(String)
    }
    
    
    // MARK: - State
    
    public struct State {
        @Pulse var audioId: String = ""
        @Pulse var equalizerState : BBEqualizerState = .inital
        @Pulse var comment: PostCommentEntity
        var memberName: String?
        var profileImageUrl: URL?
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
        self.initialState = State(audioId: comment.commentId, comment: comment)
    }
    
    
    public func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let didTappedPlayButtonMutation = provider.commentService.event
            .flatMap(with: self) {
                switch $1 {
                case let .didTappedPlaybutton(commentId):
                    let toggleState: BBEqualizerState = commentId == $0.currentState.comment.commentId ? .play : .inital
                    return .concat(
                        Observable<Mutation>.just(.setEqualizerState(toggleState))
                    )
                default:
                    return .empty()
                }
            }
        return Observable<Mutation>.merge(mutation, didTappedPlayButtonMutation)
    }
    
    
    // MARK: - Mutate
    
    public func mutate(action: Action) -> Observable<Mutation> {
        let memberId = initialState.comment.memberId
        
        switch action {
        case .prepareForReuse:
            return .just(.setEqualizerState(.inital))
            
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
            let audioId = currentState.comment.commentId
            
            provider.commentService.didTappedPlayButton(with: audioId)
            
            return .empty()
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
            
        case let .setPlayAudioId(audioId):
            newState.audioId = audioId
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
