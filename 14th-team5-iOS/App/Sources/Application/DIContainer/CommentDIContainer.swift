//
//  CommentDIContainer.swift
//  App
//
//  Created by 김건우 on 6/20/24.
//

import Core
import Data
import Domain

final class CommentDIContainer: BaseContainer {
    
    // MARK: - Make UseCase
    
    func makeCreateCommentUseCase() -> CreateCommentUseCaseProtocol {
        CreateCommentUseCase(
            commentRepository: makeCommentRepository()
        )
    }
    
    func makeDeleteCommentUseCase() -> DeleteCommentUseCaseProtocol {
        DeleteCommentUseCase(
            commentRepository: makeCommentRepository()
        )
    }
    
    func makeFetchCommentUseCase() -> FetchCommentUseCaseProtocol {
        FetchCommentUseCase(
            commentRepository: makeCommentRepository()
        )
    }
    
    func makeUpdateCommentUseCase() -> UpdateCommentUseCaseProtocol {
        UpdateCommentUseCase(
            commentRepository: makeCommentRepository()
        )
    }
    
    // Deprecated
    func makeCommentUseCase() -> PostCommentUseCaseProtocol {
        PostCommentUseCase(
            commentRepository: makeCommentRepository()
        )
    }
    
    
    // MARK: - Make Repository
    
    func makeCommentRepository() -> CommentRepositoryProtocol {
        return CommentRepository()
    }
    
    
    // MARK: - Register
    
    func registerDependencies() {
        container.register(type: CreateCommentUseCaseProtocol.self) { _ in
            self.makeCreateCommentUseCase()
        }
        
        container.register(type: DeleteCommentUseCaseProtocol.self) { _ in
            self.makeDeleteCommentUseCase()
        }
        
        container.register(type: FetchCommentUseCaseProtocol.self) { _ in
            self.makeFetchCommentUseCase()
        }
        
        container.register(type: UpdateCommentUseCaseProtocol.self) { _ in
            self.makeUpdateCommentUseCase()
        }
        
        // Deprecated
        container.register(type: PostCommentUseCaseProtocol.self) { _ in
            self.makeCommentUseCase()
        }
    }
    
    
}
