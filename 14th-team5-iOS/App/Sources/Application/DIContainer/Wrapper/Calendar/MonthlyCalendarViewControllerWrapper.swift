//
//  MonthlyCalendarViewControllerWrapper.swift
//  App
//
//  Created by 김건우 on 6/4/24.
//

import Foundation


// MARK: - Wrapper

final class MonthlyCalendarViewControllerWrapper {
    
    // NOTE: - 기존 DIContainer의 역할은 Wrapper가 대신하게 됩니다.
    // - 파일 위치는 의논해봐야 합니다만, 한 부류의 화면으로만 이동하는 게 아니니 전역에 위치하는 게 좋아보입니다.
    // - @Wrapper 매크로가 도입되면 코드가 많이 단축됩니다.
    
    func makeReactor() -> R {
        return MonthlyCalendarViewReactor()
    }
    
    
    // Begin expansion of "@Wrapper"
    
    typealias R = MonthlyCalendarViewReactor
    typealias V = MonthlyCalendarViewController
    
    func makeViewController() -> V {
        return MonthlyCalendarViewController(reactor: makeReactor())
    }
    
    var viewController: V {
        makeViewController()
    }
    
    var reactor: R {
        makeReactor()
    }
    
    // End expansion of "@Wrapper"
    
}

// Begin expansion of "@Wrapper"
extension MonthlyCalendarViewControllerWrapper: BaseWrapper { }
// End expansion of "@Wrapper"
