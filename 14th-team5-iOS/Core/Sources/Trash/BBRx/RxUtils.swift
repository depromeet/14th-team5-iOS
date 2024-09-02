//
//  RxUtils.swift
//  Core
//
//  Created by geonhui Yu on 12/14/23.
//

import Foundation

import RxSwift

@available(*, deprecated, renamed: "RxInterval")
public enum RxConst {
    
    static public var milliseconds100Interval: RxTimeInterval {
        return .milliseconds(100)
    }
    
    static public var milliseconds300Interval: RxTimeInterval {
        return .milliseconds(300)
    }
    
}

@available(*, deprecated, renamed: "RxSchedulers")
public enum RxSchedulers {
    
    public static let main = {
        MainScheduler.instance
    }()
    
    public static let background = {
        ConcurrentDispatchQueueScheduler(queue: DispatchQueue(label: "background", qos: .background))
    }()
    
    public static let utility = {
        ConcurrentDispatchQueueScheduler(queue: DispatchQueue(label: "utility", qos: .utility))
    }()
    
    public static let io = {
        ConcurrentDispatchQueueScheduler(queue: DispatchQueue(label: "io", qos: .default))
    }()
    
    public static let `default` = {
        ConcurrentDispatchQueueScheduler(queue: DispatchQueue(label: "default", qos: .default))
    }()
    
    public static let computation = {
        ConcurrentDispatchQueueScheduler(queue: DispatchQueue(label: "computation", qos: .userInitiated))
    }()
    
    public static let userInitiated = {
        ConcurrentDispatchQueueScheduler(queue: DispatchQueue(label: "userInitiated", qos: .userInitiated))
    }()
    
    public static let immediate = {
        ConcurrentDispatchQueueScheduler(queue: DispatchQueue(label: "immediate", qos: .userInteractive))
    }()
    
    public static let userInteractive = {
        ConcurrentDispatchQueueScheduler(queue: DispatchQueue(label: "userInteractive", qos: .userInteractive))
    }()
    
}
