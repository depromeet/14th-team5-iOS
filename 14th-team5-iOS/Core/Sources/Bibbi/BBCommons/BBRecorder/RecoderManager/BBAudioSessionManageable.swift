//
//  BBAudioSessionManageable.swift
//  Core
//
//  Created by 김도현 on 4/27/26.
//

import Foundation

public protocol BBAudioSessionManageable {
    func setupSession() throws
    func activateSession() throws
    func deactivateSession() throws
}


