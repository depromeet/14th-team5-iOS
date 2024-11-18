//
//  BBAPIWorker.swift
//  BBNetwork
//
//  Created by 김건우 on 9/25/24.
//

import Foundation

import Alamofire
import Combine
import RxAlamofire
import RxSwift

// MARK: - Error

/// HTTP 통신 및 디코딩, 쓰래드 전환 등 부가 기능 수행 중 발생하는 에러입니다.
public enum APIWorkerError: Error {
    
    /// 받아온 데이터가 없음을 의미합니다.
    case noResponse
    
    /// 알 수 없는 에러가 발생했음을 의미합니다.
    case unknown(Error)
    
    /// 파싱에 실패했음을 의미합니다.
    case parsing(Error)

    /// 네트워크 통신 중 문제가 발생했음을 의미합니다.
    case networkFailure(reason: BBNetworkError)

}

extension APIWorkerError {
    
    /// 발생한 에러가 네트워크 오류인 경우 해당 오류 원인을 반환합니다.
    ///
    /// - Returns: `BBNetworkError` 타입의 네트워크 에러 또는 `nil`
    var underlyingError: BBNetworkError? {
        if case let .networkFailure(reason) = self {
            return reason
        }
        return nil
    }
    
}

extension APIWorkerError: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case .noResponse:
            return "서버로부터 받아온 데이터가 없습니다."
        case .unknown(let error):
            return "알 수 없는 오류가 발생했습니다 [이유: \(error.localizedDescription)]"
        case .parsing:
            return "데이터를 처리하는 중에 문제가 발생했습니다. 서버에서 반환된 데이터가 예상한 형식과 맞지 않습니다."
        case .networkFailure(let reason):
            return "네트워크 통신 중 오류가 발생했습니다. [이유: \(reason.localizedDescription)]"
        }
    }
}


// MARK: - Workable

public protocol Workable: AnyObject {
    @discardableResult
    func request<D>(
        _ spec: any ResponseRequestable,
        on queue: any SchedulerType
    ) -> Observable<D> where D: Decodable
    
    @discardableResult
    func request<D>(
        _ spec: any ResponseRequestable
    ) -> Observable<D> where D: Decodable
    
    @discardableResult
    func upload(
        _ presignedURL: String,
        with binaryData: Data,
        serializer: BBUploadResponseSerializer,
        on queue: any SchedulerType
    ) -> Observable<Bool>
}

// MARK: - Default API Worker


// MARK: - Combine API Worker


// MARK: - Rx API Worker

open class BBRxAPIWorker {
    
    private let service: any BBNetworkService
    private let errorMapper: any APIErrorMapper
    private let errorLogger: any BBErrorLogger
    
    /// APIWorker 인스턴스를 생성합니다.
    ///
    /// - Parameters:
    ///   - service: 이 인스턴스가 사용하기를 원하는 `NetworkService`입니다. 기본값은 `BBNetworkDefaultService()`입니다.
    ///   - errorResolver: 이 인스턴스가 사용하기를 원하는 `APIErrorMapper`입니다. 기본값은 `APIDefaultErrorMapper()`입니다.
    ///   - errorLogger: 이 인스턴스가 사용하기를 원하는 `BBErrorLogger`입니다. 기본값은 `APIWorkerErrorLogger()`입니다.
    public init(
        with service: any BBNetworkService = BBNetworkDefaultService(),
        errorMapper: any APIErrorMapper = APIDefaultErrorMapper(),
        errorLogger: any BBErrorLogger = APIWorkerErrorLogger()
    ) {
        self.service = service
        self.errorMapper = errorMapper
        self.errorLogger = errorLogger
    }
    
}

extension BBRxAPIWorker: Workable {
    
    /// 매개변수로 주어진 스펙(spec) 정보를 바탕으로 HTTP 통신을 수행합니다.
    ///
    /// HTTP 통신에 성공하면 디코딩된 값을 next 항목으로 방출하고, 실패한다면 `APIWorkerError` 타입의 에러가 담긴 error 항목을 방출합니다.
    /// HTTP 통신 결과를 방출 할 때 스트림은 `queue` 매개변수로 주어진 쓰레드로 바뀝니다.
    ///
    /// - Parameters:
    ///   - spec: `ResponseRequestable` 프로토콜을 준수하는 스펙(spec)입니다.
    ///   - queue: HTTP 통신이 끝나면 흐르게 하는 쓰레드를 지정합니다. 기본값은 `RxScheduler.main`입니다.
    /// - Returns: Observable\<D\>
    public func request<D>(
        _ spec: any ResponseRequestable,
        on queue: any SchedulerType = RxScheduler.main
    ) -> Observable<D> where D: Decodable {
        
        Observable<D>.create { [unowned self] observer in
            let dataRequest = self.service.request(with: spec) { result in
                switch result {
                case let .success(data):
                    do {
                        let decoded: D = try self.decode(data, using: spec.responseDecoder)
                        observer.onNext(decoded)
                        observer.onCompleted()
                    } catch {
                        let apiError = self.map(error: error)
                        self.errorLogger.log(localizedError: apiError)
                        observer.onError(error)
                    }
                    
                case let .failure(error):
                    let mappedError = self.errorMapper.map(networkError: error)
                    self.errorLogger.log(localizedError: mappedError)
                    observer.onError(mappedError)
                }
            }
            
            return Disposables.create {
                let _ = dataRequest?.cancel()
            }
        }
        .observe(on: queue)
        
    }
    
    /// presignedURL을 바탕으로 URLRequest로 Convert 하여 S3 Bucket으로 요청하는 메서드 입니다.
    ///
    /// HTTP 통신을에 성공을 하게 되면 `BBUploadResponseSerializer`을 통해 True 값을 반환하며, 실패한다면  `APIWorkerError`를 방출 합니다.
    /// - Parameters:
    ///   - presignedURL: 서버에서 발급 받은 `Presigned URL` 입니다.
    ///   - binaryData : 이미지를 `데이터` 타입으로 변환한 값 입니다.
    ///   - serializer : `DataResponseSerializerProtocol`을 채택한 응답 핸들러입니다. 
    /// - Returns: Observable<Bool>
    public func upload(
        _ presignedURL: String,
        with binaryData: Data,
        serializer: BBUploadResponseSerializer = BBUploadResponseSerializer(),
        on queue: any SchedulerType = RxScheduler.main
    ) -> Observable<Bool> {
        
        guard let remoteURL = URL(string: presignedURL) else {
            return .just(false)
        }
        
        var request = URLRequest(url: remoteURL)
        request.method = .put
        request.httpBody = binaryData
        request.headers = BBNetworkHeaders.default.asHTTPHeaders
        
        return Observable<Bool>.create { [unowned self] observer in
            let uploadRequest = self.service.upload(request, with: binaryData, serializer: serializer) { result in
                switch result {
                case let .success(isUpload):
                    observer.onNext(isUpload ?? false)
                    observer.onCompleted()
                case let .failure(error):
                    let mappedError = self.errorMapper.map(networkError: error)
                    self.errorLogger.log(localizedError: mappedError)
                    observer.onError(mappedError)
                }
            }
            
            return Disposables.create {
                let _ = uploadRequest?.cancel()
            }
        }
        .observe(on: queue)
    }
    
    /// 매개변수로 주어진 스펙(spec) 정보를 바탕으로 HTTP 통신을 수행합니다.
    ///
    /// HTTP 통신에 성공하면 디코딩된 값을 next 항목으로 방출하고, 실패한다면 `APIWorkerError` 타입의 에러가 담긴 error 항목을 방출합니다.
    /// HTTP 통신 결과를 방출 할 때 스트림은 메인 쓰레드로 바뀝니다.
    ///
    /// - Parameters:
    ///   - spec: `ResponseRequestable` 프로토콜을 준수하는 스펙(spec)입니다.
    /// - Returns: Observable\<D\>
    @discardableResult
    public func request<D>(
        _ spec: any ResponseRequestable
    ) -> Observable<D> where D: Decodable {
        
        request(spec, on: RxScheduler.main)
        
    }
    
}

extension BBRxAPIWorker {
    
    private func map(error: any Error) -> APIWorkerError {
        (error as? APIWorkerError) ?? APIWorkerError.unknown(error)
    }
    
    private func decode<T>(
        _ data: Data?,
        using decoder: any BBResponseDecoder
    ) throws -> T where T: Decodable {
        do {
            guard let data = data else { throw APIWorkerError.noResponse }
            let decodedData: T = try decoder.decode(from: data)
            return decodedData
        } catch {
            throw APIWorkerError.parsing(error)
        }
    }
    
}
