//
//  ImageGenerateViewControllerWrapper.swift
//  Bibbi
//
//  Created by 김도현 on 9/22/25.
//

import Foundation
import MacrosInterface

@Wrapper<ImageGenerateViewReactor, ImageGenerateViewController>
final class ImageGenerateViewControllerWrapper {
    
    private let binaryData: Data
    
    public init(binaryData: Data) {
        self.binaryData = binaryData
    }
    
    func makeReactor() -> ImageGenerateViewReactor {
        return ImageGenerateViewReactor(binaryData: binaryData)
        
    }
}
