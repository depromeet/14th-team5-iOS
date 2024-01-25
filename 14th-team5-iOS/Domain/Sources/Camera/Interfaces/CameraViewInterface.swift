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
    
    var accessToken: String { get }

    func toggleCameraPosition(_ isState: Bool) -> Observable<Bool>
    func toggleCameraFlash(_ isState: Bool) -> Observable<Bool>
    func fetchProfileImageURL(parameters: CameraDisplayImageParameters, type: UploadLocation) -> Observable<CameraDisplayImageResponse?>
    func uploadImageToS3(toURL url: String, imageData: Data) -> Observable<Bool>
    func editProfleImageToS3(memberId: String, parameter: ProfileImageEditParameter) -> Observable<ProfileMemberResponse?>
    func fetchRealEmojiImageURL(memberId: String, parameters: CameraRealEmojiParameters) -> Observable<CameraRealEmojiPreSignedResponse?>
    func uploadRealEmojiImageToS3(memberId: String, parameters: CameraCreateRealEmojiParameters) -> Observable<CameraCreateRealEmojiResponse?>
    func fetchRealEmojiItems(memberId: String) -> Observable<CameraRealEmojiImageItemResponse?>
    func updateRealEmojiImage(memberId: String, realEmojiId: String, parameters: CameraUpdateRealEmojiParameters) -> Observable<CameraUpdateRealEmojiResponse?>
}
