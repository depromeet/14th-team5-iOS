//
//  UserDefaultsRepository.swift
//  Data
//
//  Created by 마경미 on 23.02.24.
//

import Foundation

import Domain

import RxSwift

public final class UserDefaultsRepository: UserDefaultsRepositoryProtocol {
    public static let shared = UserDefaultsRepository()
    
    private init() { }
    
    public func removeUserDefaultsWhenSignOut() {
        let excludedKeys: [UserDefaults.Key] = [.isFirstLaunch, .chekcPermission, .finishTutorial]

        for key in UserDefaults.Key.allCases {
            if !excludedKeys.contains(key) {
                UserDefaults.standard.removeObject(forKey: key.rawValue)
            }
        }
    }
}
