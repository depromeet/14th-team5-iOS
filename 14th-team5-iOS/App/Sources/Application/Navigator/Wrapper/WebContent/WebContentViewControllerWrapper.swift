//
//  WebContentViewControllerWrapper.swift
//  App
//
//  Created by 김건우 on 6/26/24.
//

import Core
import Foundation
import MacrosInterface

@Wrapper<WebContentReactor, WebContentViewController>
final class WebContentViewControllerWrapper {
  
    // MARK: - Properties
    
    let url: URL?
    
    // MARK: - Intializer
    
    init(url: URL?) {
        self.url = url
    }
    
    // MARK: - Make
    
    func makeReactor() -> WebContentReactor {
        WebContentReactor(contentURL: url)
    }
   
}
