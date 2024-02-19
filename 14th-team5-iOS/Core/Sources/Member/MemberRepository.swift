//
//  MemberRepository.swift
//  Core
//
//  Created by geonhui Yu on 1/3/24.
//

import Foundation

import RxSwift
import RxCocoa

public class MemberRepository: RxObject {
    public let familyId = BehaviorRelay<String?>(value: nil)
    public let memberID = BehaviorRelay<String?>(value: nil)
    public let nickname = BehaviorRelay<String?>(value: nil)
    public let inviteCode = BehaviorRelay<String?>(value: nil)
    public let postId = BehaviorRelay<String?>(value: nil)
    public let openComment = BehaviorRelay<Bool?>(value: nil)
    
    override public func bind() {
        memberID
            .withUnretained(self)
            .bind(onNext: { $0.0.saveMemberId(with: $0.1) })
            .disposed(by: disposeBag)
        
        familyId
            .withUnretained(self)
            .bind(onNext: { $0.0.saveFamilyId(with: $0.1) })
            .disposed(by: disposeBag)
    
        nickname
            .withUnretained(self)
            .bind(onNext: { $0.0.saveNicknmae(with: $0.1) })
            .disposed(by: disposeBag)
        
        inviteCode
            .withUnretained(self)
            .bind(onNext: { $0.0.saveInviteCode(with: $0.1) })
            .disposed(by: disposeBag)
        
        postId
            .withUnretained(self)
            .bind(onNext: { $0.0.savePostId(with: $0.1) })
            .disposed(by: disposeBag)
    }
    
    private func saveMemberId(with id: String?) {
        guard let memberId = id else { return }
        UserDefaults.standard.memberId = memberId
    }
    
    private func saveFamilyId(with id: String?) {
        guard let familyId = id else { return }
        UserDefaults.standard.familyId = familyId
    }
    
    private func saveInviteCode(with code: String?) {
        guard let code = code else { return }
        UserDefaults.standard.inviteCode = code
    }
    
    private func saveNicknmae(with nickname: String?) {
        guard let nickname = nickname else { return }
        UserDefaults.standard.nickname = nickname
    }
    
    private func savePostId(with postId: String?) {
        guard let postId = postId else {
            UserDefaults.standard.postId = nil
            return
        }
        UserDefaults.standard.postId = postId
    }
    
    override public func unbind() {
        super.unbind()
    }
}
