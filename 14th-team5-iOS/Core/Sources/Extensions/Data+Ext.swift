//
//  Decodable.swift
//  Core
//
//  Created by 김건우 on 10/6/24.
//

import Foundation

public extension Data {
    
    func decode<T>(
        using decoder: JSONDecoder = JSONDecoder()
    ) -> T? where T: Decodable {
        try? decoder.decode(T.self, from: self)
    }
    
    func decode<T>(
        using decoder: any BBResponseDecoder = BBDefaultResponderDecoder()
    ) -> T? where T: Decodable {
        try? decoder.decode(from: self)
    }
    
}
