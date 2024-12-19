//
//  MembersRepository.swift
//  Domain
//
//  Created by Kim dohyun on 9/11/24.
//

import Foundation

import RxCocoa
import RxSwift


public protocol MembersRepositoryProtocol {
    var disposeBag: DisposeBag { get }
    /// FETCH
    func fetchProfileMemberItem(memberId: String) -> Observable<MembersProfileEntity?>
    /// UPDATE
    func updateMemberNameItem(memberId: String, body: UpdateMemberNameRequest) -> Observable<UpdateMemberNameEntity?>
    func updateMemberProfileImageItem(memberId: String, body: UpdateMemberImageRequest) -> Observable<MembersProfileEntity?>
    /// CREATE
    func creteMemberImagePresignedURL(body: CreateMemberPresignedReqeust) -> Observable<CreateMemberPresignedEntity?>
    func deleteMemberProfileImageItem(memberId: String) -> Observable<MembersProfileEntity?>
    /// UPLOAD
    func uploadMemberImageToS3Bucket(_ presignedURL: String, image: Data) -> Observable<Bool>
}


