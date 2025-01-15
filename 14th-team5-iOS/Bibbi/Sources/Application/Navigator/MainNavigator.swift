//
//  MainNavigator.swift
//  App
//
//  Created by 마경미 on 02.09.24.
//

import UIKit

import Core
import Domain


protocol MainNavigatorProtocol: BaseNavigator {
    // alert
    func showSurvivalAlert()
    func pickAlert(_ name: String)
    func showWidgetAlert()
    func missionUnlockedAlert()
    
    
    // toast
    func showToast(_ image: UIImage?, _ message: String)
    
    // viewcontroller
    func toCamera(_ type: UploadLocation)
    func toDailyCalendar(_ date: String)
    func toFamilyManagement()
    func toMonthlyCalendar()
}

final class MainNavigator: MainNavigatorProtocol {
    // MARK: - Properties
    
    var navigationController: UINavigationController
    
    // MARK: - Intializer
    
    init(
        navigationController: UINavigationController
    ) {
        self.navigationController = navigationController
    }
    
    // MARK: - To
    func showSurvivalAlert() {
        BBAlert.style(.takePhoto).show()
    }
    
    func pickAlert(_ name: String) {
        BBAlert.style(.picking(name: name)).show()
    }
    
    func missionUnlockedAlert() {
        let handler: BBAlertActionHandler = { [weak self] alert in
            self?.toCamera(.survival)
        }
        BBAlert.style(.takePhoto, primaryAction: handler).show()
    }
    
    func showWidgetAlert() {
        BBAlert.style(.widget).show()
    }
    
    func showToast(_ image: UIImage?, _ message: String) {
        BBToast.default(image: image ?? UIImage(), title: message).show()
    }
    
    func toCamera(_ type: UploadLocation) {
        let vc = CameraViewControllerWrapper(cameraType: type).viewController
        navigationController.pushViewController(vc, animated: true)
    }
    
    func toDailyCalendar(_ date: String) {
        let vc = DailyCalendarViewControllerWrapper(selection: date.toDate()).viewController
        navigationController.pushViewController(vc, animated: true)
    }
    
    func toFamilyManagement() {
        let vc = ManagementViewControllerWrapper().viewController
        navigationController.pushViewController(vc, animated: true)
    }
    
    func toMonthlyCalendar() {
        let vc = MonthlyCalendarViewControllerWrapper().viewController
        navigationController.pushViewController(vc, animated: true)
    }
    
}
