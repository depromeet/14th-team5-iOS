//
//  ImageCompressionServiceProtocol.swift
//  Core
//
//  Created by Kim dohyun on 2/20/26.
//

import Foundation

public protocol ImageCompressionServiceProtocol {
    
    /// 이미지 데이터를 압축합니다
    /// - Parameters:
    ///   - imageData: 원본 이미지 데이터
    ///   - maxSizeInBytes: 최대 허용 크기 (바이트)
    /// - Returns: 압축된 이미지 데이터
    func compress(_ imageData: Data, maxSizeInBytes: Int) -> Data
    
    /// 이미지 데이터의 크기를 확인합니다
    /// - Parameters:
    ///   - imageData: 확인할 이미지 데이터
    ///   - maxSizeInBytes: 최대 허용 크기
    /// - Returns: 압축이 필요한지 여부
    func needsCompression(_ imageData: Data, maxSizeInBytes: Int) -> Bool
    
    /// 이미지 데이터의 크기를 포맷된 문자열로 반환합니다
    /// - Parameter imageData: 이미지 데이터
    func formatSize(_ imageData: Data) -> String
}
