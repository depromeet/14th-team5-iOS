//
//  GlobalStateProvider.swift
//  Core
//
//  Created by 김건우 on 12/9/23.
//

import Foundation

public protocol GlobalStateProviderProtocol: AnyObject {
    var postGlobalState: PostGlobalStateType { get }
    var activityGlobalState: ActivityGlobalStateType { get }
    var calendarGlabalState: CalendarGlobalStateType { get }
    var toastGlobalState: ToastMessageGlobalStateType { get }
    var profileGlobalState: ProfileGlobalStateType { get }
    var timerGlobalState: TimerGlobalStateType { get }
    var realEmojiGlobalState: RealEmojiGlobalStateType { get }
    var homeService: HomeServiceType { get }
}

final public class GlobalStateProvider: GlobalStateProviderProtocol {
    public lazy var postGlobalState: PostGlobalStateType = PostGlobalState(provider: self)
    public lazy var activityGlobalState: ActivityGlobalStateType = ActivityGlobalState(provider: self)
    public lazy var calendarGlabalState: CalendarGlobalStateType = CalendarGlobalState(provider: self)
    public lazy var toastGlobalState: ToastMessageGlobalStateType = ToastMessageGlobalState(provider: self)
    public lazy var profileGlobalState: ProfileGlobalStateType = ProfileGlobalState(provider: self)
    
    public lazy var timerGlobalState: TimerGlobalStateType = TimerGlobalState(provider: self)
    public lazy var realEmojiGlobalState: RealEmojiGlobalStateType = RealEmojiGlobalState(provider: self)
    
    public lazy var homeService: HomeServiceType = HomeService(provider: self)
    
    public init() { }
}
