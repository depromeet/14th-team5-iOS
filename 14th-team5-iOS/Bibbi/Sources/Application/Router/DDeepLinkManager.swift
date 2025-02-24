import Foundation
import Core
import UIKit

// MARK: - 딥링크 핸들러
class DeepLinkHandler {
    func handle(url: URL) {
        let pathComponents = url.pathComponents.filter {
            $0 != "/"
        }
        let queryParams = URLComponents(
            url: url,
            resolvingAgainstBaseURL: false
        )?.queryItems
        
        switch pathComponents.first {
        case "main":
            let deepLink = MainDeepLink(
                pathComponents: pathComponents,
                queryParams: queryParams
            )
        case "post":
            let deepLink = PostDeepLink(
                pathComponents: pathComponents,
                queryParams: queryParams
            )
        case "Profile":
            let deepLink = ProfileDeepLink(
                pathComponents: pathComponents
            )
        case "Store":
            let deepLink = StoreDeepLink(
                pathComponents: pathComponents
            )
        case nil:
            BBToast.text("화면을 이동할 수 없어요").show()
            return
        case .some(_):
            BBToast.text("화면을 이동할 수 없어요").show()
            return
        }
    }
}

protocol DeepLinkProtocol {
    func doDeepLink()
    func popToViewController()
}

extension DeepLinkProtocol {
    func getNavigationController() -> UINavigationController? {
        return (UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }?
            .rootViewController as? UINavigationController)
    }
    
    func popToViewController<T: UIViewController>(ofType type: T.Type, animated: Bool = true) {
        guard let navigationController = getNavigationController() else {
            return
        }
        
        for controller in navigationController.viewControllers.reversed() {
            if controller is T {
                navigationController.popToViewController(controller, animated: animated)
                return
            }
        }
        
        navigationController.popToRootViewController(animated: animated)
    }
    
}
