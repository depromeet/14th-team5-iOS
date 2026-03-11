//
//  ImageCompressionService.swift
//  Core
//
//  Created by Kim dohyun on 2/20/26.
//

import Foundation
import UIKit

public final class ImageCompressionService: ImageCompressionServiceProtocol {
    
    //MARK: Properties
    private let initialQuality: CGFloat
    private let minimumQuality: CGFloat
    private let qualityStep: CGFloat
    
    public init(
        initialQuality: CGFloat = 0.8,
        minimumQuality: CGFloat = 0.1,
        qualityStep: CGFloat = 0.1
    ) {
        self.initialQuality = initialQuality
        self.minimumQuality = minimumQuality
        self.qualityStep = qualityStep
    }
    
    public func compress(_ imageData: Data, maxSizeInBytes: Int) -> Data {
        guard needsCompression(imageData, maxSizeInBytes: maxSizeInBytes) else {
            return imageData
        }
        guard let image = UIImage(data: imageData) else {
            return imageData
        }
        
        return compressImage(image, maxSizeInBytes: maxSizeInBytes, originalData: imageData)
    }
    
    public func needsCompression(_ imageData: Data, maxSizeInBytes: Int) -> Bool {
        return imageData.count > maxSizeInBytes
    }
    
    public func formatSize(_ imageData: Data) -> String {
        let bytes = Double(imageData.count)
        let mb = bytes / 1024.0 / 1024.0
        
        if mb < 1.0 {
            let kb = bytes / 1024.0
            return String(format: "%.2f KB (%d 바이트)", kb, imageData.count)
        } else {
            return String(format: "%.2f MB (%d 바이트)", mb, imageData.count)
        }
    }
    
    private func compressImage(_ image: UIImage, maxSizeInBytes: Int, originalData: Data) -> Data {
        var compressionQuality = initialQuality
        var compressedData = originalData
        var attemptCount = 0
        let maxAttempts = Int((initialQuality - minimumQuality) / qualityStep) + 1
        
        while compressedData.count > maxSizeInBytes && 
              compressionQuality >= minimumQuality &&
              attemptCount < maxAttempts {
            
            if let compressed = image.jpegData(compressionQuality: compressionQuality) {
                compressedData = compressed
            }
            
            compressionQuality -= qualityStep
            attemptCount += 1
        }
        return compressedData
    }
}


public extension ImageCompressionService {
    
    /// 5MB 제한으로 압축하는 편의 메서드
    func compressForUpload(_ imageData: Data) -> Data {
        compress(imageData, maxSizeInBytes: 5 * 1024 * 1024)
    }
    
    /// 10MB 제한으로 압축하는 편의 메서드
    func compressForLargeUpload(_ imageData: Data) -> Data {
        compress(imageData, maxSizeInBytes: 10 * 1024 * 1024)
    }
}
