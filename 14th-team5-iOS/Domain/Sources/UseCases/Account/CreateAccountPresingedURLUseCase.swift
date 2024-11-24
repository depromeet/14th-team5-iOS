//
//  CreateAccountPresingedURLUseCase.swift
//  Domain
//
//  Created by 김도현 on 11/22/24.
//

import Foundation

import Core
import RxSwift


public protocol CreateAccountPresingedURLUseCaseProtocol {
    func execute(body: CreateMemberPresignedReqeust, imageData: Data) -> Observable<CreateMemberPresignedEntity?>
}


public final class CreateAccountPresingedURLUseCase: CreateAccountPresingedURLUseCaseProtocol {
    
    private let membersRepository: any MembersRepositoryProtocol
    
    
    public init(membersRepository: any MembersRepositoryProtocol) {
        self.membersRepository = membersRepository
    }
    
    public func execute(body: CreateMemberPresignedReqeust, imageData: Data) -> Observable<CreateMemberPresignedEntity?> {
        
        return .empty()
    }
}
