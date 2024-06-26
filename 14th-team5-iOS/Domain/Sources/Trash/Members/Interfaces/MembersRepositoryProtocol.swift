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
    
    func fetchProfileMemberItems(memberId: String) -> Single<MembersProfileEntity?>
    func updataProfileImageToS3(memberId: String, parameter: ProfileImageEditParameter) -> Single<MembersProfileEntity?>
    func deleteProfileImageToS3(memberId: String) -> Single<MembersProfileEntity?>
}
