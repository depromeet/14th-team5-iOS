//
//  URLHandler.swift
//  Core
//
//  Created by 마경미 on 25.03.25.
//

import Foundation

final public class URLHandler {
    let urlString: String
    
    public init(urlString: String) {
        self.urlString = urlString
    }
}

extension URLHandler {
    public func getURL() -> URL? {
        return URL(string: urlString)
    }
    
    public func getPathComponents() -> [String]? {
        guard let url = getURL() else {
            return nil
        }
        
        let pathComponents = url.pathComponents.filter {
                !$0.isEmpty && $0 != "/"
            }
        
        return pathComponents
    }
    
    public func getQueryItems() -> [URLQueryItem]? {
        guard let url = getURL() else {
            return nil
        }
        
       let queryItems = URLComponents(
            url: url,
            resolvingAgainstBaseURL: false
        )?.queryItems
        
        return queryItems
    }
}
