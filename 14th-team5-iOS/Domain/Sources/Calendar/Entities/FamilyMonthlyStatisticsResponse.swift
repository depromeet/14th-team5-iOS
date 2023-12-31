//
//  FamilyMonthlyStatisticsResponse.swift
//  Domain
//
//  Created by 김건우 on 1/5/24.
//

import Foundation

public struct FamilyMonthlyStatisticsResponse {
    var totalParticiateCnt: Int
    var totalImageCnt: Int
    var myImageCnt: Int
    
    public init(totalParticiateCnt: Int, totalImageCnt: Int, myImageCnt: Int) {
        self.totalParticiateCnt = totalParticiateCnt
        self.totalImageCnt = totalImageCnt
        self.myImageCnt = myImageCnt
    }
}
