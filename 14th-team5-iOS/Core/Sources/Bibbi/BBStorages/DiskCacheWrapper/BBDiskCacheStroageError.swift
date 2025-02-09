//
//  BBDiskCacheStroageError.swift
//  Core
//
//  Created by 김도현 on 1/28/25.
//

import Foundation

enum BBDiskCacheStroageError: Error {
    case cannotLoadDataFromDisk
    case cannotCreateDirectory
    case cannotConvertToData
    case cannotCreateCacheFile
    case diskStorageIsNotReady
}

extension BBDiskCacheStroageError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .cannotLoadDataFromDisk:
            return "디스크에서 데이터를 로드할 수 없습니다."
        case .cannotCreateDirectory:
            return "디렉토리를 생성할 수 없습니다."
        case .cannotConvertToData:
            return "데이터로 변환할 수 없습니다."
        case .cannotCreateCacheFile:
            return "캐시파일을 생성할 수 없습니다."
        case .diskStorageIsNotReady:
            return "디스크 저장소가 준비되지 않았습니다."
        }
    }
}
