//
//  CameraDisplayViewReactor.swift
//  App
//
//  Created by Kim dohyun on 12/11/23.
//

import Foundation

import Data
import Domain
import Util
import DesignSystem
import ReactorKit
import Core

public final class CameraDisplayViewReactor: Reactor {
    
    public var initialState: State
    @Injected private var provider: ServiceProviderProtocol
    @Injected private var createPostUseCase: CreatePostUseCaseProtocol
    @Injected private var createPresignedURLUseCase: CreatePresignedURLUseCaseProtocol
    @Injected private var fetchUserCreatedAtUseCase: FetchUserCreatedAtInfoUseCaseProtocol
    @Injected private var createImageUploadUseCase: CreateImageUploadUseCaseProtocol
    @Injected private var updateExistingUserUseCase: any UpdateExistingUserUseCaseProtocol
    @Injected private var imageCompressionService: any ImageCompressionServiceProtocol
    @Navigator private var cameraDisplayNavigator: CameraDisplayNavigatorProtocol
    
    public enum Action {
        case viewDidLoad
        case didTapArchiveButton
        case fetchDisplayImage(String)
        case didTapConfirmButton
        case didTapLocationButton
        case didSelectLocation(latitude: Double, longitude: Double, address: String)
        case hideDisplayEditCell
        case showInputTextError
        case showInputBlankTextError(String)
    }

    public enum Mutation {
        case setLoading(Bool)
        case setError(Bool)
        case setDisplayEditSection([DisplayEditItemModel])
        case setRenderImage(Data)
        case saveDeviceimage(Data)
        case setDescription(String)
        case setTrimedText(String)
        case setDisplayEntity(CreatePostPresignedURLEntity?)
        case setDisplayOriginalEntity(Bool)
        case setLocation(latitude: Double, longitude: Double, address: String)
    }

    public struct State {
        @Pulse var isLoading: Bool
        var displayDescrption: String
        var cameraType: BibbiFeedType
        @Pulse var isError: Bool
        @Pulse var displayData: Data
        @Pulse var saveBinaryData: Data
        @Pulse var missionTitle: String
        @Pulse var displaySection: [DisplayEditSectionModel]
        @Pulse var displayEntity: CreatePostPresignedURLEntity?
        @Pulse var displayOringalEntity: Bool
        @Pulse var displayText: String
        var selectedLatitude: Double?
        var selectedLongitude: Double?
        var selectedAddress: String?
        @Pulse var locationButtonTitle: String
    }
    
    
    
    init(
        displayData: Data,
        missionTitle: String,
        cameraType: BibbiFeedType = .survival
    ) {
        self.initialState = State(
            isLoading: true,
            displayDescrption: "",
            cameraType: cameraType,
            isError: false,
            displayData: displayData,
            saveBinaryData: .empty,
            missionTitle: missionTitle,
            displaySection: [.displayKeyword([])],
            displayEntity: nil,
            displayOringalEntity: false,
            displayText: "",
            selectedLatitude: nil,
            selectedLongitude: nil,
            selectedAddress: nil,
            locationButtonTitle: "위치 추가"
        )
    }
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            let fileName = "\(UUID().uuidString).jpg"
            let body = CreatePostPresignedURLRequest(imageName: fileName)
            
            let maxSize = 5 * 1024 * 1024
            let compressedData = imageCompressionService.compress(
                currentState.displayData,
                maxSizeInBytes: maxSize
            )
            return .concat(
                .just(.setLoading(false)),
                createPresignedURLUseCase.execute(body: body)
                    .withUnretained(self)
                    .flatMap { owner, presingedURL -> Observable<Mutation> in
                        guard let remoteURL = presingedURL?.imageURL else {
                            return .just(.setLoading(false))
                        }
                        return owner.createImageUploadUseCase.execute(remoteURL, with: compressedData)
                            .flatMap { isSuccess -> Observable<Mutation> in
                                return .concat(
                                    .just(.setDisplayEntity(presingedURL)),
                                    .just(.setLoading(true))
                                )
                                
                            }.catchError(with: self) { owner, error in
                                if let urlError = error as? URLError {
                                    owner.cameraDisplayNavigator.showErrorAlert(
                                        message: error.localizedDescription,
                                        error: urlError
                                    )
                                } else {
                                    owner.cameraDisplayNavigator.showErrorAlert(
                                        message: "이미지 압축 중 에러가 발생했습니다.",
                                        error: error
                                    )
                                }
                                return .just(.setLoading(true))
                            }
                    }.catchError(with: self) { owner, error in
                        owner.cameraDisplayNavigator.showErrorAlert(
                            message: "이미지 PresignedURL업로드 중 에러가 발생했습니다.",
                            error: error
                        )
                        return .just(.setLoading(true))
                    }
            )
 
        case let .fetchDisplayImage(description):
            return .concat(
                Observable.of(Array(description))
                    .map { String($0) }
                    .flatMap { items -> Observable<Mutation> in
                        var sectionItem: [DisplayEditItemModel] = []
                        
                        items.forEach {
                            sectionItem.append(.fetchDisplayItem(DisplayEditCellReactor(title: String($0), radius: 8, font: .head1)))
                        }
                        
                        return .concat(
                            .just(.setDisplayEditSection(sectionItem)),
                            .just(.setDescription(description))
                        )
                    }
            )
        case .didTapArchiveButton:
            let config = BBToastConfiguration(direction: .bottom(yOffset: -20), animationTime: 1.0)
            let viewConfig = BBToastViewConfiguration(minWidth: 207)
            provider.bbToastService.show(
                image:DesignSystemAsset.camera.image.withTintColor(DesignSystemAsset.gray300.color),
                title: "사진이 저장되었습니다.",
                viewConfig: viewConfig,
                config: config
                )
            return .concat(
                .just(.setLoading(false)),
                .just(.saveDeviceimage(currentState.displayData)),
                .just(.setLoading(true))
            )
            
        case .didTapConfirmButton:
            
            guard let presingedURL = currentState.displayEntity?.imageURL else { return .just(.setError(true)) }
            let remoteURL = configureOriginalS3URL(url: presingedURL)
            let query = CreatePostQuery(type: currentState.cameraType.rawValue)
            let body = CreatePostRequest(
                imageUrl: remoteURL,
                content: currentState.displayDescrption,
                uploadTime: DateFormatter.yyyyMMddTHHmmssXXX.string(from: .now),
                latitude: currentState.selectedLatitude,
                longitude: currentState.selectedLongitude,
                address: currentState.selectedAddress
            )
            let refreshMainObservable = Observable<Mutation>.concat(
                .just(.setError(false)),
                provider.mainService.refreshMain()
                    .flatMap { _ in Observable<Mutation>.empty() }
            )
        
            return createPostUseCase.execute(query: query, body: body)
                .withUnretained(self)
                .flatMap { owner, entity -> Observable<Mutation> in
                    if entity == nil  {
                        return .just(.setError(true))
                    } else {
                        if owner.currentState.cameraType == .survival {
                            return owner.fetchUserCreatedAtUseCase.execute()
                                .flatMap { isRatingHidden -> Observable<Mutation> in
                                    owner.updateExistingUserUseCase.execute()
                                    owner.cameraDisplayNavigator.toHome(isRatingHidden)
                                    return refreshMainObservable
                                }
                        } else {
                            owner.cameraDisplayNavigator.toHome(false)
                            return refreshMainObservable
                        }
                    }
                }.catchError(with: self) { owner, error in
                    owner.cameraDisplayNavigator.showErrorAlert(
                        message: "게시물 생성 중 에러가 발생했습니다.",
                        error: error
                    )
                    return .empty()
                }
        case .hideDisplayEditCell:
            return .concat(
                .just(.setDescription("")),
                .just(.setDisplayEditSection([]))
            )
        case .showInputTextError:
            let config = BBToastConfiguration(direction: .bottom(yOffset: -360), animationTime: 1.0)
            let viewConfig = BBToastViewConfiguration(minWidth: 207)
            provider.bbToastService.show(
                image: DesignSystemAsset.warning.image,
                title: "8자까지 입력 가능해요",
                viewConfig: viewConfig,
                config: config
            )
            return .empty()
            
        case let .showInputBlankTextError(displayText):
            let config = BBToastConfiguration(direction: .bottom(yOffset: -360), animationTime: 1.0)
            let viewConfig = BBToastViewConfiguration(minWidth: 207)
            provider.bbToastService.show(
                image: DesignSystemAsset.warning.image,
                title: "띄어쓰기는 할 수 없어요",
                viewConfig: viewConfig,
                config: config
            )
            let generateText = displayText.trimmingCharacters(in: .whitespaces)
            return .just(.setTrimedText(generateText))
            
        case .didTapLocationButton:
            cameraDisplayNavigator.toLocationSearch { [weak self] lat, lng, address in
                self?.action.onNext(.didSelectLocation(latitude: lat, longitude: lng, address: address))
            }
            return .empty()

        case let .didSelectLocation(lat, lng, address):
            return .just(.setLocation(latitude: lat, longitude: lng, address: address))
        }
    }
    
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setLoading(isLoading):
            newState.isLoading = isLoading
        case let .setRenderImage(originalData):
            newState.displayData = originalData
        case let .saveDeviceimage(saveData):
            newState.saveBinaryData = saveData
        case let .setDisplayEditSection(section):
            let sectionIndex = getSection(.displayKeyword([]))
            newState.displaySection[sectionIndex] = .displayKeyword(section)
        case let .setDescription(descrption):
            newState.displayDescrption = descrption
        case let .setDisplayEntity(entity):
            newState.displayEntity = entity
        case let .setDisplayOriginalEntity(entity):
            newState.displayOringalEntity = entity
        case let .setError(isError):
            newState.isError = isError
        case let .setTrimedText(displayText):
            newState.displayText = displayText
        case let .setLocation(lat, lng, address):
            newState.selectedLatitude = lat
            newState.selectedLongitude = lng
            newState.selectedAddress = address
            newState.locationButtonTitle = address
        }
        return newState
    }
    
    
}

extension CameraDisplayViewReactor {
    
    func getSection(_ section: DisplayEditSectionModel) -> Int {
        var index: Int = 0
        
        for i in 0 ..< currentState.displaySection.count where currentState.displaySection[i].getSectionType() == section.getSectionType() {
            index = i
        }
        
        return index
    }
    
    func configureOriginalS3URL(url: String) -> String {
        guard let urlComponents = URLComponents(string: url) else {
            return url
        }
        
        var cleanComponents = urlComponents
        cleanComponents.query = nil
        guard let originURL = cleanComponents.url?.absoluteString else {
            return url
        }
        return originURL
    }
}

