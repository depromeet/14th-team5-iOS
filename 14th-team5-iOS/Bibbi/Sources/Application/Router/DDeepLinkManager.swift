import Foundation
import Core
import UIKit

// MARK: - 딥링크 핸들러
final class DeepLinkHandler {
    var deepLink: DeepLinkProtocol?
    
    init(urlString: String) {
        let urlHandler = URLHandler(urlString: urlString)
        
        guard let pathComponents = urlHandler.getPathComponents(),
            let queryParams = urlHandler.getQueryItems() else {
            deepLink = nil
            return
        }
        
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
}

extension DeepLinkHandler {
    /// DeeplinkManager 인스턴스를 만들고 execute문을 실행하면 딥링크 처리 후 화면 이동합니다.
    public func execute() {
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