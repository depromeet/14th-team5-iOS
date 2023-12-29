//
//  CameraViewInterface.swift
//  Domain
//
//  Created by Kim dohyun on 12/26/23.
//

import Foundation

import RxCocoa
import RxSwift

public protocol CameraViewInterface: AnyObject {
    var disposeBag: DisposeBag { get }

    func toggleCameraPosition(_ isState: Bool) -> Observable<Bool>
    func toggleCameraFlash(_ isState: Bool) -> Observable<Bool>
    func fetchProfileImageURL(parameters: CameraDisplayImageParameters, type: UploadLocation) -> Observable<CameraDisplayImageResponse?>
    func uploadProfileImage(toURL url: String, imageData: Data) -> Observable<Bool>
    func editProfleImageToS3(memberId: String, parameter: ProfileImageEditParameter) -> Observable<ProfileMemberResponse?>
    
}
