//
//  RxInterval.swift
//  Core
//
//  Created by 김건우 on 6/28/24.
//

import Foundation

import RxSwift

public enum RxInterval {
    
    public static var _100milliseconds: RxTimeInterval {
        RxTimeInterval.milliseconds(100)
    }
    
    public static var _200milliseconds: RxTimeInterval {
        RxTimeInterval.milliseconds(200)
    }
    
    public static var _300milliseconds: RxTimeInterval {
        RxTimeInterval.milliseconds(300)
    }
    
    public static var _400milliseconds: RxTimeInterval {
        RxTimeInterval.milliseconds(400)
    }
    
    public static var _500milliseconds: RxTimeInterval {
        RxTimeInterval.milliseconds(500)
    }
    
    public static var _600milliseconds: RxTimeInterval {
        RxTimeInterval.milliseconds(600)
    }
    
    public static var _700milliseconds: RxTimeInterval {
        RxTimeInterval.milliseconds(700)
    }
    
    public static var _800milliseconds: RxTimeInterval {
        RxTimeInterval.milliseconds(800)
    }
    
    public static var _900milliseconds: RxTimeInterval {
        RxTimeInterval.milliseconds(900)
    }
    
    public static func cusomtMilliseconds(_ custom: Int) -> RxTimeInterval {
        RxTimeInterval.milliseconds(custom)
    }
    
}
