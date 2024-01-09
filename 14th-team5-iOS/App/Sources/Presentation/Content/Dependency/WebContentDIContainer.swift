//
//  WebContentDIContainer.swift
//  App
//
//  Created by Kim dohyun on 1/1/24.
//

import Foundation


public final class WebContentDIContainer {
    // UseCase or Repository 사용할지
    // Reactor 만 사용할지 논의 필요
    public typealias ViewController = WebContentViewController
    public typealias Reactor = WebContentViewReactor
    
    public let webURL: URL? = URL(string: "https://no5ing.kr/app/privacy")
    
    
    
    public func makeViewController() -> ViewController {
        return WebContentViewController(reactor: makeReactor())
    }
    
    public func makeReactor() -> Reactor {
        return WebContentViewReactor(contentURL: webURL)
    }
    
    
}
