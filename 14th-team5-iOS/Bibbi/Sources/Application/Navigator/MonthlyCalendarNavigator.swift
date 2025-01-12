//
//  MonthlyCalendarNavigator.swift
//  App
//
//  Created by 김건우 on 6/26/24.
//

import Core
import UIKit

protocol MonthlyCalendarNavigatorProtocol: BaseNavigator {
    func backToHome()
    func toDailyCalendar(selection date: Date)
}

final class MonthlyCalendarNavigator: MonthlyCalendarNavigatorProtocol {

    // MARK: - Properties
    
    var navigationController: UINavigationController
 
    // MARK: - Intializer
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Back
    
    func backToHome() {
        navigationController.popViewController(animated: true)
    }
    
    // MARK: - To
    
    func toDailyCalendar(selection date: Date) {
        let vc = DailyCalendarViewControllerWrapper(selection: date).viewController
        navigationController.pushViewController(vc, animated: true)
    }
    
}
