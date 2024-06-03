//
//  APIConfig.swift
//  Data
//
//  Created by geonhui Yu on 12/17/23.
//

import Foundation

protocol BibbiAPIConfigType {
    var hostApi: String { get }
}

struct BibbiAPIConfig: BibbiAPIConfigType {
    #if PRD
    var hostApi: String = "https://api.no5ing.kr/v1"
    #else
    var hostApi: String = "https://dev.api.no5ing.kr/v1"
    #endif
}
