//
//  WebContentDIContainer.swift
//  App
//
//  Created by Kim dohyun on 1/1/24.
//

import Foundation

@available(*, deprecated, renamed: "WebContentViewControllerWrapper")
public final class WebContentDIContainer {
    // UseCase or Repository 사용할지
    // Reactor 만 사용할지 논의 필요
    public typealias ViewController = WebContentViewController
    public typealias Reactor = WebContentReactor
    
    public let webURL: URL?
    
    public init(webURL: URL?) {
        self.webURL = webURL
    }
    
    
    
    public func makeViewController() -> ViewController {
        return WebContentViewController(reactor: makeReactor())
    }
    
    public func makeReactor() -> Reactor {
        return WebContentReactor(contentURL: webURL)
    }
    
    
}
