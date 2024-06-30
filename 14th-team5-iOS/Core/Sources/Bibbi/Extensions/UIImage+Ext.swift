//
//  UIImage+Ext.swift
//  App
//
//  Created by Kim dohyun on 12/7/23.
//

import UIKit
import UniformTypeIdentifiers

import DesignSystem

extension UIImage {
    
    public var asPhoto: Data? {
        
        //Image Source에 부여할 Options
        let imageSourceOptions = [
            kCGImageSourceShouldCache: false
        ] as CFDictionary
        
        
        //Image Source 생성 메서드 Data -> Image Source로 변환
        guard let photoData = self.jpegData(compressionQuality: 1.0),
              let imageSource = CGImageSourceCreateWithData(photoData as CFData, imageSourceOptions) else { return nil }
        
        
        
        let imageDownSampleOptions = [
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceCreateThumbnailWithTransform: true
        ] as CFDictionary
        
        // Image Soruce 를 통해 CGImage로 변환
        // Index의 의미는 CGImage를 변환하려는 것을 가져오기위한 것
        guard let cgImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, imageDownSampleOptions) else { return nil }
        
        let imageDataOptions = [
            kCGImageDestinationLossyCompressionQuality: 0.75
        ] as CFDictionary
        
        let originalData = NSMutableData()
        guard let imageDestinationData = CGImageDestinationCreateWithData(originalData as CFMutableData, UTType.jpeg.identifier as CFString, 1, nil) else { return nil }
        CGImageDestinationAddImage(imageDestinationData, cgImage, imageDataOptions)
        CGImageDestinationFinalize(imageDestinationData)
        return originalData as Data
    }
    
    
    public func combinedTextWithBackground(target text: String, size: CGSize, attributedString: [NSAttributedString.Key : Any]) -> UIImage {
        let renderImage: UIGraphicsImageRenderer = UIGraphicsImageRenderer(size: size)
        let targetText: NSString = (text as NSString)
        
        let targetTextSize: CGSize = targetText.size(withAttributes: attributedString)
        let centerX = (size.width - targetTextSize.width) / 2
        let centerY = (size.height - targetTextSize.height) / 2
        let targetRect: CGRect = CGRect(x: centerX, y: centerY, width: targetTextSize.width, height: targetTextSize.height)
        let originalImage: UIImage = renderImage.image { _ in
            draw(in: CGRect(origin: .zero, size: size))
            targetText.size(withAttributes: attributedString)
            targetText.draw(in: targetRect, withAttributes: attributedString)
        }
        return originalImage
    }
    
    public func combinedWithAlpha(with alpha: CGFloat, blendMode: CGBlendMode) -> UIImage {
        let renderImage: UIGraphicsImageRenderer = UIGraphicsImageRenderer(size: size)
        
        let originalImage: UIImage = renderImage.image { _ in
            draw(at: .zero, blendMode: blendMode, alpha: alpha)
        }
        
        return originalImage
    }
    
    public func resized(to size: CGSize) -> UIImage? {
        let renderImage: UIGraphicsImageRenderer = UIGraphicsImageRenderer(size: size)
        let originalImage: UIImage = renderImage.image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
        return originalImage
    }
}

extension UIImage {
    public static func pixel(of color: UIColor) -> UIImage {
        let pixel = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        
        UIGraphicsBeginImageContext(pixel.size)
        defer { UIGraphicsEndImageContext() }
        
        guard let context = UIGraphicsGetCurrentContext() else { return UIImage() }
        
        context.setFillColor(color.cgColor)
        context.fill(pixel)
        
        return UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
    }
}

extension UIImage {
    public typealias TopBarIconType = NavigationBar.IconType
    public typealias TopBarImageType = NavigationBar.ImageType
    
    public enum NavigationBar {
        public enum ImageType {
            case bibbi
            case newBibbi
        }
        
        public enum IconType {
            case addPerson
            case arrowLeft
            case heartCalendar
            case setting
            case xmark
        }
    }
}

extension UIImage.NavigationBar.IconType {
    public var barButtonImage: UIImage? {
        switch self {
        case .addPerson:
            return DesignSystemAsset.addPerson.image
        case .arrowLeft:
            return UIImage(systemName: "chevron.backward")
        case .heartCalendar:
            return DesignSystemAsset.heartCalendar.image
        case .setting:
            return DesignSystemAsset.setting.image
        case .xmark:
            return DesignSystemAsset.xmark.image
        }
    }
}

extension UIImage.NavigationBar.ImageType {
    public var barImage: UIImage? {
        switch self {
        case .bibbi:
            return DesignSystemAsset.bibbiLogo.image
        case .newBibbi:
            return DesignSystemAsset.bibbiLogo.image
        }
    }
}
