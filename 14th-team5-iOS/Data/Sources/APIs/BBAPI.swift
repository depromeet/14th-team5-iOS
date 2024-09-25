//
//  BaseAPISpec.swift
//  BBNetwork
//
//  Created by 김건우 on 9/25/24.
//

import Alamofire
import Foundation

public protocol BBAPI {
    var spec: BBAPISpec { get }
}
