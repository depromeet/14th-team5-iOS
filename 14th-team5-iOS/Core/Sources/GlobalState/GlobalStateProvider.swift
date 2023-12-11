//
//  GlobalStateProvider.swift
//  Core
//
//  Created by 김건우 on 12/9/23.
//

import Foundation

public protocol GlobalStateProviderType: AnyObject {
    var calendarGlabalState: CalendarGlobalStateType { get }
}

final public class GlobalStateProvider: GlobalStateProviderType {
    lazy public var calendarGlabalState: CalendarGlobalStateType = CalendarGlobalState(provider: self)
    
    public init() { }
}
