//
//  APIConfig.swift
//  Data
//
//  Created by geonhui Yu on 12/17/23.
//

import Foundation

public protocol BibbiAPIConfigType {
    var hostApi: String { get }
}

@available(*, deprecated, renamed: "BBAPIConfiguration")
public struct BibbiAPIConfig: BibbiAPIConfigType {
    #if PRD
    public var hostApi: String = "https://api.no5ing.kr/v1"
    #else
    public var hostApi: String = "https://dev.api.no5ing.kr/v1"
    #endif
}
