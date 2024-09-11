//
//  YourFamilProfileCellReactor.swift
//  App
//
//  Created by 김건우 on 12/12/23.
//

import Core
import Domain
import Foundation

import ReactorKit
import RxDataSources
import RxSwift

final public class FamilyMemberCellReactor: Reactor {
    
    // MARK: - Action
    
    public enum Action { 
        case checkIsMe
        case checkIsMemberBirth
    }
    
    
    // MARK: - Mutate
    
    public enum Mutation {
        case setIsHiddenIsMeMark(Bool)
        case setIsHiddenBirthBadge(Bool)
    }
    
    
    // MARK: - State
    
    public struct State {
        let kind: FamilyMemberCellKind
        var member: FamilyMemberProfileEntity
        
        var isHiddenIsMeMark: Bool = true
        var isHiddenBirthBadge: Bool = true
    }
    
    
    // MARK: - Properties
    
    public var initialState: State
    
    @Injected var checkIsMeUseCase: CheckIsMeUseCaseProtocol
    
    
    // MARK: - Intializer
    
    public init(
        _ kind: FamilyMemberCellKind,
        member: FamilyMemberProfileEntity
    ) {
        self.initialState = State(
            kind: kind,
            member: member
        )
    }
    
    
    // MARK: - Mutate
    
    public func mutate(action: Action) -> Observable<Mutation> {
        let member = initialState.member
        
        switch action {
        case .checkIsMe:
            let checkIsMe = checkIsMeUseCase.execute(memberId: member.memberId)
            let isHidden = initialState.kind == .management ? !checkIsMe : true
            return Observable<Mutation>.just(.setIsHiddenIsMeMark(isHidden))
            
        case .checkIsMemberBirth:
            let checkBirth = member.dayOfBirth?.isEqual([.day, .month], with: Date.now) ?? false
            let isHidden = initialState.kind == .management ? !checkBirth : true
            return Observable<Mutation>.just(.setIsHiddenBirthBadge(isHidden))
        }
    }
    
    
    // MARK: - Reduce
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setIsHiddenIsMeMark(isHidden):
            newState.isHiddenIsMeMark = isHidden
    
        case let .setIsHiddenBirthBadge(isHidden):
            newState.isHiddenBirthBadge = isHidden
        }
        
        return newState
    }
    
}
