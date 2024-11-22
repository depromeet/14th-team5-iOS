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
    func updateMemberProfileImageItem(memberId: String) -> Observable<MembersProfileEntity?>
    /// CREATE
    func createMemberPickItem(memberId: String) -> Observable<CreateMemberPickEntity?>
    func creteMemberImagePresignedURL(memberId: String) -> Observable<CameraPreSignedEntity?>
    func deleteMemberProfileImageItem(memberId: String) -> Observable<MembersProfileEntity?>
    /// DELETE
    func deleteMemberItem(memberId: String, body: DeleteMemberRequest) -> Observable<DeleteMemberEntity?>
}


