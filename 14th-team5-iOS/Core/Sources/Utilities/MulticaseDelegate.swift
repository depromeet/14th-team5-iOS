//
//  MulticaseDelegate.swift
//  BBToast
//
//  Created by 김건우 on 7/8/24.
//

import Foundation

final class MulticaseDelegate<T> {
    
    private let delegates: NSHashTable<AnyObject> = NSHashTable()
    
    func add(_ delegate: T) {
        delegates.add(delegates as AnyObject)
    }
    
    func remove(_ delegateToRemove: T) {
        for delegate in delegates.allObjects.reversed() {
            if delegate === delegateToRemove as AnyObject {
                delegates.remove(delegate)
            }
        }
    }
    
    func invoke(_ invocation: (T) -> Void) {
        for delegate in delegates.allObjects.reversed() {
            invocation(delegate as! T)
        }
    }
}
