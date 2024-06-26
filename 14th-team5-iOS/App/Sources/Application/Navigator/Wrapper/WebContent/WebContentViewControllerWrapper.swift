//
//  WebContentViewControllerWrapper.swift
//  App
//
//  Created by 김건우 on 6/26/24.
//

import Core
import Foundation

final class WebContentViewControllerWrapper: BaseWrapper {
    
    // MARK: - Typealias
    
    typealias R = WebContentReactor
    typealias V = WebContentViewController
    
    // MARK: - Properties
    
    let url: URL?
    
    var reactor: WebContentReactor {
        makeReactor()
    }
    
    var viewController: WebContentViewController {
        makeViewController()
    }
    
    // MARK: - Intializer
    
    init(url: URL?) {
        self.url = url
    }
    
    // MARK: - Make
    
    func makeReactor() -> WebContentReactor {
        WebContentReactor(contentURL: url)
    }
    
    func makeViewController() -> WebContentViewController {
        WebContentViewController(reactor: makeReactor())
    }
    
}
