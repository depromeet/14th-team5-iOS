//
//  MembersRepositoryProtocol.swift
//  Domain
//
//  Created by Kim dohyun on 6/5/24.
//

import Foundation

import RxCocoa
import RxSwift


public protocol MembersRepositoryProtocol {
    var disposeBag: DisposeBag { get }
    
    func fetchProfileMemberItems(memberId: String) -> Observable<MembersProfileResponse?>
    func fetchProfileAlbumImageURL(parameter: CameraDisplayImageParameters) -> Observable<CameraDisplayImageResponse?>
    func uploadProfileImageToPresingedURL(to url: String, imageData: Data) -> Observable<Bool>
    func updataProfileImageToS3(memberId: String, parameter: ProfileImageEditParameter) -> Observable<MembersProfileResponse?>
    func deleteProfileImageToS3(memberId: String) -> Observable<MembersProfileResponse?>
}
