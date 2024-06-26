//
//  PostUserDefaults.swift
//  Data
//
//  Created by 마경미 on 30.03.24.
//

import Foundation

import Domain

import RxSwift

public final class PostUserDefaultsRepository {
    private let lastPostUploadDateId = "lastPostUploadDateId"
    
    public init() {
        
    }
    
    public func savePostUploadDate(createdAt: String) {
        let isoDateFormatter = ISO8601DateFormatter()
        isoDateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        if let date = isoDateFormatter.date(from: createdAt) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let extractedDate = dateFormatter.string(from: date)
            UserDefaults.standard.set(extractedDate, forKey: lastPostUploadDateId)
        } else {
            print("날짜 변환 실패")
        }
    }
    
    public func checkUploadDate(date: String) {
        if UserDefaults.standard.string(forKey: lastPostUploadDateId) == nil {
            UserDefaults.standard.set(date, forKey: lastPostUploadDateId)
        }
    }
    
    public func checkPostUploadedToday() -> RxSwift.Single<Bool> {
        guard let lastDate = UserDefaults.standard.string(forKey: lastPostUploadDateId) else {
            return .just(false)
        }
        
        return .just(lastDate == Date().toFormatString(with: "yyyy-MM-dd"))
    }
}
