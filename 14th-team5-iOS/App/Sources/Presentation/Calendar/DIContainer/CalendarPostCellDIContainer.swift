//
//  CalendarPostCellDIContainer.swift
//  App
//
//  Created by 김건우 on 5/7/24.
//

import Core
import Data
import Domain
import UIKit

public final class CalendarPostCellDIContainer {
    // MARK: - Properties
    let post: DailyCalendarEntity
    
    private var globalState: GlobalStateProviderProtocol {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return GlobalStateProvider()
        }
        return appDelegate.globalStateProvider
    }
    
    init(post: DailyCalendarEntity) {
        self.post = post
    }
    
    // MARK: - Make
    public func makeMeUseCase() -> MemberUseCaseProtocol {
        return MemberUseCase(memberRepository: makeMeRepository())
    }
    
    public func makeMeRepository() -> MemberRepositoryProtocol {
        return MemberRepository()
    }
    
    public func makeReactor() -> CalendarPostCellReactor {
        return CalendarPostCellReactor(
            post: post,
            meUseCase: makeMeUseCase(),
            provider: globalState
        )
    }
}
