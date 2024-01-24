//
//  Array+Ext.swift
//  Core
//
//  Created by 마경미 on 20.01.24.
//

import Foundation

extension Array {
    
    public subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
    
    public init(with element: Element) {
        self = [element]
    }
}
