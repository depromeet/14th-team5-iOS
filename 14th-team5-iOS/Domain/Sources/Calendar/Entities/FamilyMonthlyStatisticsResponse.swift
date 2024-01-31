//
//  FamilyMonthlyStatisticsResponse.swift
//  Domain
//
//  Created by 김건우 on 1/5/24.
//

import Foundation

public struct FamilyMonthlyStatisticsResponse {
    public var totalImageCnt: Int
    
    public init(totalImageCnt: Int) {
        self.totalImageCnt = totalImageCnt
    }
}
