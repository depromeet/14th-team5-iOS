//
//  ImageGenerateViewReactor.swift
//  Bibbi
//
//  Created by 김도현 on 9/20/25.
//

import Core
import Domain
import Foundation

import ReactorKit
import RxSwift
import RxCocoa



public final class ImageGenerateViewReactor: Reactor {
    
    @Injected private var createAiImageGenerateUseCase: CreateAiImageGenerateUseCaseProtocol
    @Injected private var uploadAiImagePostUseCase: CreatePostUseCaseProtocol
    @Navigator var imageGenerateNavigator: ImageGenerateNavigatorProtocol
    
    
    public var initialState: State
    
    public struct State {
        @Pulse var binaryData: Data
        @Pulse var errorDescription: String = ""
        @Pulse var isLoading: Bool = false
        var archiveData: Data = .empty
        var aiImageEntity: AiImageEntity? = nil
        var postType: BibbiFeedType = .studio
    }
    
    public enum Action {
        case viewDidLoad
        case didTappedUploadButton
        case didTappedArchiveButton
        case didTappedBackButton
    }
    
    public enum Mutation {
        case setLoading(Bool)
        case setError(String)
        case setArchiveData(Data)
        case setSuccess(AiImageEntity?)
    }
    
    init(binaryData: Data) {
        self.initialState = State(binaryData: binaryData)
    }
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return .concat(
                .just(.setLoading(true)),
                run { [weak self] send in
                    do {
                        let response = try await self?.createAiImageGenerateUseCase.execute(binaryData: self?.currentState.binaryData ?? .empty)
                        send(.setSuccess(response))
                    } catch {
                        if let apiError = error as? APIWorkerError,
                           case .networkFailure(let error) = apiError {
                            switch error {
                            case .timeout:
                                send(.setError("시간 초과로 인해 이미지 생성에 실패했어요. 다시 한 번 시도해주세요."))
                            default:
                                send(.setError(error.localizedDescription))
                            }
                        }
                    }
                },
                .just(.setLoading(false))
            )
            
        case .didTappedUploadButton:
            guard let entity = currentState.aiImageEntity else {
                return .just(.setError("이미지 생성에 실패했습니다. 다시 한 번 시도해주세요."))
            }
            
            let query = CreatePostQuery(type: currentState.postType.rawValue)
            let body = CreatePostRequest(imageUrl: entity.imageUrl, content: "", uploadTime: DateFormatter.yyyyMMddTHHmmssXXX.string(from: .now))
            return uploadAiImagePostUseCase.execute(query: query, body: body)
                .withUnretained(self)
                .flatMap { owner, entity -> Observable<Mutation> in
                    if entity == nil {
                        return .just(.setError("업로드 중 오류가 발생했습니다. 다시 한 번 시도해주세요."))
                    }
                    owner.imageGenerateNavigator.toHome()
                    return .empty()
                }
        case .didTappedArchiveButton:
            guard !currentState.binaryData.isEmpty else {
                return .empty()
            }
            self.imageGenerateNavigator.showToast()
            return .just(.setArchiveData(currentState.binaryData))
        case .didTappedBackButton:
            guard !currentState.isLoading else {
                imageGenerateNavigator.showWarningAlert()
                return .empty()
            }
            self.imageGenerateNavigator.toCamera()
            return .empty()
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setLoading(isLoading):
            newState.isLoading = isLoading
        case let .setError(errorDescription):
            newState.errorDescription = errorDescription
            imageGenerateNavigator.showErrorAlert(errorDescription)
        case let .setSuccess(aiImageEntity):
            newState.aiImageEntity = aiImageEntity
        case let .setArchiveData(archiveData):
            newState.archiveData = archiveData
        }
        return newState
    }
    
}
