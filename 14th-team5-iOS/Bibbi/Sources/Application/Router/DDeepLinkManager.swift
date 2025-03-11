import Foundation
import Core
import UIKit

// MARK: - 딥링크 핸들러
final class DeepLinkHandler {
    var deepLink: DeepLinkProtocol?
    
    init(urlString: String) {
        guard let url = URL(string: urlString) else {
            deepLink = nil
            return
        }
        
        let pathComponents = url.pathComponents
            .filter { !$0.isEmpty && $0 != "/" }
        
        let queryParams = URLComponents(
            url: url,
            resolvingAgainstBaseURL: false
        )?.queryItems
        
        switch pathComponents.first?.lowercased() {
        case "main":
            if pathComponents.count > 1,
               pathComponents[1] == "profile" {
                deepLink = ProfileDeepLink(
                    pathComponents: pathComponents
                )
            } else {
                deepLink = MainDeepLink(
                    pathComponents: pathComponents,
                    queryParams: queryParams
                )
            }
        case "post":
            deepLink = PostDeepLink(
                pathComponents: pathComponents,
                queryParams: queryParams
            )
        case "store":
            deepLink = StoreDeepLink(
                pathComponents: pathComponents
            )
        default:
            deepLink = nil
        }
    }
    
    /// DeeplinkManager 인스턴스를 만들고 execute문을 실행하면 딥링크 처리 후 화면 이동합니다.
    func execute() {
        do {
            guard let deepLink else {
                throw DeepLinkError.notFound
            }
            
            try deepLink.doDeepLink()
        } catch let error as DeepLinkError {
            BBToast.text(error.message).show()
        } catch {
            BBToast.text("알 수 없는 오류가 발생했습니다.").show()
        }
    }
}

enum DeepLinkError: Error {
    case invalidLink
    case notFound
    case errorOccurred
    case invalidNavigation
    
    var message: String {
        switch self {
        case .invalidLink:
            return "잘못된 링크입니다."
        case .notFound:
            return "요청한 페이지를 찾을 수 없습니다."
        case .errorOccurred:
            return "요청 중 에러가 발생했습니다."
        case .invalidNavigation:
            return "현재 페이지를 찾을 수 없습니다."
        }
    }
}

protocol DeepLinkProtocol {
    func doDeepLink() throws
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
