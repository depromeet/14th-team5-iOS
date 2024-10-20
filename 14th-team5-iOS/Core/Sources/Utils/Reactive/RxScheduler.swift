//
//  RxSchedulers.swift
//  Core
//
//  Created by 김건우 on 6/28/24.
//

import Foundation

import RxSwift

public enum RxScheduler {
    
    // MARK: - Main
    
    public static var main: MainScheduler {
        MainScheduler.instance
    }
    
    public static var asyncMain: SerialDispatchQueueScheduler {
        MainScheduler.asyncInstance
    }
    
    
    // MARK: - Concurrent
    
    public enum Concurrent {
        
        public static var background: ConcurrentDispatchQueueScheduler {
            ConcurrentDispatchQueueScheduler(
                queue: DispatchQueue(
                    label: "background",
                    qos: .background
                )
            )
        }
        
        public static var utility: ConcurrentDispatchQueueScheduler {
            ConcurrentDispatchQueueScheduler(
                queue: DispatchQueue(
                    label: "utility",
                    qos: .utility
                )
            )
        }
        
        public static var `default`: ConcurrentDispatchQueueScheduler {
            ConcurrentDispatchQueueScheduler(
                queue: DispatchQueue(
                    label: "default",
                    qos: .default
                )
            )
        }
        
        public static var userIntiated: ConcurrentDispatchQueueScheduler {
            ConcurrentDispatchQueueScheduler(
                queue: DispatchQueue(
                    label: "UserIntiated",
                    qos: .userInitiated
                )
            )
        }
        
        public static var userInteractive: ConcurrentDispatchQueueScheduler {
            ConcurrentDispatchQueueScheduler(
                queue: DispatchQueue(
                    label: "UserInteractive",
                    qos: .userInteractive
                )
            )
        }
        
        public static func custom(_ label: String, qos: DispatchQoS) -> ConcurrentDispatchQueueScheduler {
            ConcurrentDispatchQueueScheduler(
                queue: DispatchQueue(
                    label: label,
                    qos: qos
                )
            )
        }
        
    }
    
    
    // MARK: - Serial
    
    public enum Serial {
        
        public static var background: SerialDispatchQueueScheduler {
            SerialDispatchQueueScheduler(
                qos: .background,
                internalSerialQueueName: "background"
            )
        }
        
        public static var utility: SerialDispatchQueueScheduler {
            SerialDispatchQueueScheduler(
                qos: .utility,
                internalSerialQueueName: "utility"
            )
        }
        
        public static var `default`: SerialDispatchQueueScheduler {
            SerialDispatchQueueScheduler(
                qos: .default,
                internalSerialQueueName: "default"
            )
        }
        
        public static var userIntiated: SerialDispatchQueueScheduler {
            SerialDispatchQueueScheduler(
                qos: .userInitiated,
                internalSerialQueueName: "userIntiated"
            )
        }
        
        public static var userInteractive: SerialDispatchQueueScheduler {
            SerialDispatchQueueScheduler(
                qos: .userInteractive,
                internalSerialQueueName: "userInteractive"
            )
        }
        
        public static func custom(_ label: String, qos: DispatchQoS) -> SerialDispatchQueueScheduler {
            SerialDispatchQueueScheduler(
                qos: qos,
                internalSerialQueueName: label
            )
        }
        
    }
    
    
}
