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
    
    override public func bind() {
        memberID
            .withUnretained(self)
            .bind(onNext: { $0.0.saveMemberId(with: $0.1) })
            .disposed(by: disposeBag)
        
        familyId
            .withUnretained(self)
            .bind(onNext: { $0.0.saveMemberId(with: $0.1) })
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
    
    override public func unbind() {
        super.unbind()
    }
}
