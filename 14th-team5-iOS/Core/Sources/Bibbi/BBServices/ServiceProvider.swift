//
//  GlobalStateProvider.swift
//  Core
//
//  Created by 김건우 on 12/9/23.
//

import Foundation

public protocol ServiceProviderProtocol: AnyObject {
    var mainService: MainServiceType { get }
    var managementService: ManagementServiceType { get }
    
    var postGlobalState: PostGlobalStateType { get }
    var calendarGlabalState: CalendarGlobalStateType { get }
    var toastGlobalState: ToastMessageGlobalStateType { get }
    var profileGlobalState: ProfileGlobalStateType { get }
    var timerGlobalState: TimerGlobalStateType { get }
    var realEmojiGlobalState: RealEmojiGlobalStateType { get }
    var profilePageGlobalState: ProfileFeedGlobalStateType { get }
}

final public class ServiceProvider: ServiceProviderProtocol {
    
    public lazy var mainService: MainServiceType = MainService(provider: self)
    public lazy var managementService: any ManagementServiceType = ManagementService(provider: self)
    
    public lazy var postGlobalState: PostGlobalStateType = PostGlobalState(provider: self)
    public lazy var calendarGlabalState: CalendarGlobalStateType = CalendarGlobalState(provider: self)
    public lazy var toastGlobalState: ToastMessageGlobalStateType = ToastMessageGlobalState(provider: self)
    public lazy var profileGlobalState: ProfileGlobalStateType = ProfileGlobalState(provider: self)
    
    public lazy var timerGlobalState: TimerGlobalStateType = TimerGlobalState(provider: self)
    public lazy var realEmojiGlobalState: RealEmojiGlobalStateType = RealEmojiGlobalState(provider: self)
    public lazy var profilePageGlobalState: ProfileFeedGlobalStateType = ProfileFeedGlobalState(provider: self)
    
    
    public init() { }
}
