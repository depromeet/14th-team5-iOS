//
//  URLRequest.swift
//  Core
//
//  Created by 김건우 on 6/3/24.
//

import Foundation

import Alamofire


public extension URLRequest {
    
    mutating func setHeaders(_ headers: [HTTPHeader]) {
        headers.forEach { header in
            self.setValue(header.value, forHTTPHeaderField: header.name)
        }
    }
    
    mutating func setHeaders(_ headers: [BibbiHeader]) {
        let headers = headers.map { header in
            HTTPHeader(name: header.key, value: header.value)
        }
        setHeaders(headers)
    }
    
    mutating func setHeaders(_ headers: [String: String]) {
        let headers = headers.map { key, value in
            HTTPHeader(name: key, value: value)
        }
        setHeaders(headers)
    }
    
}
