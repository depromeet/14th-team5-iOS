//
//  MulticaseDelegate.swift
//  BBToast
//
//  Created by 김건우 on 7/8/24.
//

import Foundation

final public class MulticastDelegate<T> {
    
    private let delegates: NSHashTable<AnyObject> = NSHashTable()
    
    func add(_ delegate: T) {
        delegates.add(delegate as AnyObject)
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
            if let delegate = delegate as? T {
                invocation(delegate)
            }
        }
    }
}
