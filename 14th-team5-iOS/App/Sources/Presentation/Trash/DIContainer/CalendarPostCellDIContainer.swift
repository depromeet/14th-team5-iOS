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

@available(*, deprecated)
public final class CalendarPostCellDIContainer {
    // MARK: - Properties
    let post: DailyCalendarEntity
    
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
    
    public func makeReactor() -> MemoriesCalendarPostCellReactor {
        return MemoriesCalendarPostCellReactor(
            postEntity: post
        )
    }
}
