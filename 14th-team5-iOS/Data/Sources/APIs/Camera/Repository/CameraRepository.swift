//
//  CameraRepository.swift
//  Data
//
//  Created by Kim dohyun on 6/7/24.
//

import Foundation

import Core
import Domain
import RxCocoa
import RxSwift


public final class CameraRepository {

    public var disposeBag: DisposeBag = DisposeBag()
    private let cameraAPIWorker: CameraAPIWorker = CameraAPIWorker()
    
    public init() { }
    
        
}

extension CameraRepository: CameraRepositoryProtocol {
    
    public func createFeedImage(query: CreateFeedQuery, body: CreateFeedRequest) -> Observable<CameraPostEntity?> {
        let body = CreateFeedRequestDTO(imageUrl: body.imageUrl, content: body.content, uploadTime: body.uploadTime)
        
        return cameraAPIWorker.createFeed(query: query, body: body)
            .map { $0?.toDomain() }
    }
    
    public func createEmojiImagePresignedURL(memberID: String, body: CreatePresignedURLRequest) -> Observable<CameraRealEmojiPreSignedEntity?> {
        let body = CreatePresignedURLReqeustDTO(imageName: body.imageName)
        return cameraAPIWorker.createRealEmojiPresignedURL(memberId: memberID, body: body)
            .map { $0?.toDomain() }
    }
    
    public func createProfileImagePresignedURL(body: CreatePresignedURLRequest) -> Observable<CameraPreSignedEntity?> {
        let body = CreatePresignedURLReqeustDTO(imageName: body.imageName)
        return cameraAPIWorker.createProfilePresignedURL(body: body)
            .map { $0?.toDomain() }
    }
    
    public func createEmojiImage(memberId: String, body: CreateEmojiImageRequest) -> Observable<CameraCreateRealEmojiEntity?> {
        let body = CreateEmojiImageReqeustDTO(type: body.type, imageUrl: body.imageUrl)
        return cameraAPIWorker.createRealEmoji(memberId: memberId, body: body)
            .map { $0.toDomain() }
    }
    
    public func fetchDailyMissonItem() -> Observable<CameraTodayMssionEntity?> {
        return cameraAPIWorker.fetchDailyMisson()
            .map { $0?.toDomain() }
    }
    
    public func fetchEmojiList(memberId: String) -> Observable<[CameraRealEmojiImageItemEntity?]> {
        return cameraAPIWorker.fetchRealEmoji(memberId: memberId)
            .map { $0?.toDomain() ?? [] }
    }
    
    public func updateUserProfileImage(memberId: String, body: UpdateProfileImageRequest) -> Observable<MembersProfileEntity?> {
        let body = UpdateProfileImageRequestDTO(profileImageUrl: body.profileImageUrl)
        return cameraAPIWorker.updateProfileImage(memberId: memberId, body: body)
            .map { $0?.toDomain() }
    }
    
    public func updateEmojiImage(memberId: String, realEmojiId: String, body: UpdateRealEmojiImageRequest) -> Observable<CameraUpdateRealEmojiEntity?> {
        let body = UpdateRealEmojiImageRequestDTO(imageUrl: body.imageUrl)
        return cameraAPIWorker.updateRealEmoji(memberId: memberId, realEmojiId: realEmojiId, body: body)
            .map { $0?.toDomain() }
    }
    
    public func uploadImageToS3Bucket(_ presignedURL: String, image: Data) -> Observable<Bool> {
        return cameraAPIWorker.uploadImageToPresignedURL(presignedURL, image: image)
    }
    
}
