//
//  MembersAPIWorker.swift
//  Data
//
//  Created by Kim dohyun on 6/5/24.
//

import Core
import Foundation

import RxSwift


typealias MembersAPIWorker = MembersAPIs.Worker

extension MembersAPIWorker {
    
    /// 회원 프로필 정보를 조회하기 위한 Method 입니다.
    /// HTTP Method : GET
    /// - Parameters : memberId (조회할 회원 ID)
    /// - Returns : MembersProfileResponseDTO
    func fetchMember(memberId: String) -> Observable<MembersProfileResponseDTO?> {
        let spec = MembersAPIs.fetchMember(memberId: memberId).spec
        
        return request(spec)
    }
    
    /// 회원 탈퇴 API 요청 Method 입니다.
    /// HTTP Method : DELETE
    /// - Parameters:
    ///     - memberId (탈퇴할 회원 ID)
    ///     - DeleteMemberRequestDTO (탈퇴 사유)
    /// - Returns : AccountResignResponseDTO
    func deleteMember(memberId: String, body: DeleteMemberRequestDTO) -> Observable<DeleteMemberResponseDTO?> {
        let spec = MembersAPIs.deleteMember(memberId: memberId, body: body).spec
        
        return request(spec)
    }
    
    /// 사용자를 콕 찌리기 위한 API 요청 Method 입니다.
    /// HTTP Method : POST
    /// - Parameters : memberId (콕 찌를 회원 ID)
    /// - Returns :PickResponseDTO
    func createMemberPick(memberId: String) -> Observable<CreateMemberPickResponseDTO?> {
        let spec = MembersAPIs.createMemberPick(memberId: memberId).spec
        
        return request(spec)
    }
    
    /// 회읜 프로필 이미지 업로드를 하기 위한 Presigned-URL API 요청 Method
    /// HTTP Method : POST
    /// - Returns : CameraDisplayImageResponseDTO
    func createMemberPresignedURL() -> Observable<CameraDisplayImageResponseDTO?> {
        let spec = MembersAPIs.createMemberPresignedURL.spec
        
        return .empty()
    }
    
    /// 회원 프로필 이름을 수정하기 위한 Method
    /// HTTP Method : PUT
    /// - Parameters :
    ///     - memberId (수정할 회원 ID)
    ///     - UpdateMemberNameRequestDTO (변경할 이름)
    func updateMemberName(memberId: String, body: UpdateMemberNameRequestDTO) -> Observable<UpdateMemberNameResponseDTO?> {
        let spec = MembersAPIs.updateMemberName(memberId: memberId, body: body).spec
        
        return request(spec)
    }
    
    /// 사용자 프로필 이미지를 변경 하기 위한 Method 입니다.
    /// HTTP Method : PUT
    /// - Parameters :
    ///     - memberId (수정할 회원 ID)
    ///     -
    ///- Returns : MembersProfileResponseDTO
    func updateMemberProfileImage(memberId: String) -> Observable<MembersProfileResponseDTO?> {
        let spec = MembersAPIs.updateMemberProfileImage(memberId: memberId).spec
        
        return request(spec)
    }
    
    /// 사용자 프로필 이미지를 삭제 하기 위한 Method 입니다.
    /// HTTP Method : DELETE
    /// - Parameters : memberId (프로필 이미지를 삭제할 회원 ID)
    /// - Returns : MembersProfileResponseDTO
    func deleteMemberProfileImage(memberId: String) -> Observable<MembersProfileResponseDTO?> {
        let spec = MembersAPIs.deleteMemberProfileImage(memberId: memberId).spec
        
        return request(spec)
    }
}
