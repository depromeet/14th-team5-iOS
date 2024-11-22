//
//  EditCameraProfileImageUseCase.swift
//  Domain
//
//  Created by Kim dohyun on 6/14/24.
//

import Foundation

import RxSwift
import RxCocoa

public protocol EditCameraProfileImageUseCaseProtocol {
    func execute(memberId: String, body: UpdateProfileImageRequest) -> Observable<MembersProfileEntity?>
}


public final class EditCameraProfileImageUseCase: EditCameraProfileImageUseCaseProtocol {
    
    private let cameraRepository: any CameraRepositoryProtocol
    
    public init(cameraRepository: any CameraRepositoryProtocol) {
        self.cameraRepository = cameraRepository
    }
    
    public func execute(memberId: String, body: UpdateProfileImageRequest) -> Observable<MembersProfileEntity?> {
        return cameraRepository.updateUserProfileImage(memberId: memberId, body: body)
    }
    
}



