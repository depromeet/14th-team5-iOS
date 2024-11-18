//
//  File.swift
//  BBNetwork
//
//  Created by 김건우 on 9/25/24.
//

import Foundation

import Alamofire

// MARK: - Session Manager

public protocol BBNetworkSessionManager {
    typealias CompletionHandler = (AFDataResponse<Data?>) -> Void
    typealias UploadHandler = (AFDataResponse<Bool>) -> Void
    
    func request(
        with request: URLRequest,
        completion: @escaping CompletionHandler
    ) -> BBNetworkCancellable
    
    func upload(
        with request: URLRequest,
        data: Data,
        serializer: BBUploadResponseSerializer,
        completion: @escaping UploadHandler
    ) -> BBNetworkCancellable
}


// MARK: - Network Session

public class BBNetworkSession {
    
    /// 가장 기본적인 네트워크 세션입니다.
    public static let `default`: BBNetworkSession = BBNetworkSession()
    
    /// 토큰 리프레시용 네트워크 세션입니다.
    public static let refresh: BBNetworkSession = BBNetworkSession(interceptor: nil)
    
    /// 세션은 생명 주기 동안 Alamofire의 `Request` 타입을 생성하고 관리합니다.
    /// 또한, 세션은 큐잉(queuing), 인터셉터, 신뢰 관리, 리다이렉트와 캐시 응답 처리를 포함한 모든 요청에 대한 보편적인 기능을 제공합니다.
    private var session: Session = .default
    
    
    /// 네트워크 세션을 만듭니다.
    ///
    /// - Parameters:
    ///   - configuration: 내부 `URLSession`을 생성할 때 사용할 `URLSessionConfiguration`입니다. 이니셜라이저를 거친 다음 해당 값에 대한 변경사항은 반영되지 않습니다. 기본값은 `URLSessionConfiguration.af.default`입니다.
    ///
    ///   - delegate: `session`의 델리게이트 콜백과 `request` 상호작용을 처리할 `SessionDelegate`입니다.  기본값은 `SessionDelegate()`입니다.
    ///
    ///   - rootQueue: 모든 내부 콜백과 상태 업데이트를 처리하는 기본 `DispatchQueue`입니다. **반드시** 직렬 큐여야 합니다. 기본값은 `DispatchQueue(label: "bibbi.com.rootQueue")`입니다.
    ///
    ///   - startRequestsImmediately: 모든 `Request`를 자동으로 시작할 지 결정합니다. 기본값은 `true`입니다. 만약 `false`로 설정한다면, 모든 `Request`는 `resume()` 메서드를 호출해 시작해야 합니다.
    ///
    ///   - requestQueue: `URLRequest` 생성을 수행하는 `DispatchQueue`입니다. 기본적으로 rootQueue를 타겟으로 사용합니다. 요청 생성이 병목을 유발하는 경우 신중한 테스트과 프로파일링 후 별도 큐를 사용할 수 있습니다. 기본값은 `nil`입니다.
    ///
    ///   - serializationQueue:ㅡ모든 응답 직렬화를 수행할 `DispatchQueue`입니다. 기본적으로 rootQueue를 타겟으로 사용합니다. 요청 직렬이 병복을 유발하는 경우 신중한 테스트와 프로파일링 후 별도 큐를 사용할 수 있습니다. 기본값은 `nil`입니다.
    ///
    ///   - interceptor: 이 인스턴스에 의해 생성된 `Request`가 사용할 `RequestInterceptor`입니다. 기본값은 `nil`입니다.
    ///
    ///   - serverTrustManager: 이 인스턴스에서 신뢰 평가에 사용될 `ServerTrustManager`입니다. 기본값은 `nil`입니다.
    ///
    ///   - redirectHandler: 이 인스턴스에 의해 생성된 `Request`가 사용할 `RedirectHandler`입니다. 기본값은 `nil`입니다.
    ///
    ///   - cachedResponseHandler: 이 인스턴스에 의해 생성된 `Request`가 사용할 `CachedResponseHandler`입니다. 기본값은 `nil`입니다.
    ///
    ///   - eventMonitors: 이 인스턴스에 의해 사용될 추가적인 `EventMonitor`입니다. Alamofire는 항상 기본값으로 `AlamofireNotification`과 `EventMonitor`를 추가합니다. 기본값은 `[]`입니다.
    ///
    /// - seealso: `Alamofire.Session`
    public init(
        configuration: URLSessionConfiguration = URLSessionConfiguration.af.default,
        delegate: SessionDelegate = SessionDelegate(),
        rootQueue: DispatchQueue = DispatchQueue(label: "bibbi.com.rootQueue"),
        startRequestsImmediately: Bool = true,
        requestQueue: DispatchQueue? = nil,
        serializtionQueue: DispatchQueue? = nil,
        interceptor: (any RequestInterceptor)? = BBNetworkDefaultInterceptor(),
        serverTrustManger: ServerTrustManager? = nil,
        redirectHandler: (any RedirectHandler)? = nil,
        cachedResponseHandler: (any CachedResponseHandler)? = nil,
        eventMonitors: [any BBNetworkEventMonitor] =  [BBNetworkDefaultLogger()]
    ) {
        self.session = Session(
            configuration: configuration,
            delegate: delegate,
            rootQueue: rootQueue,
            startRequestsImmediately: startRequestsImmediately,
            requestQueue: requestQueue,
            serializationQueue: serializtionQueue,
            interceptor: interceptor,
            serverTrustManager: serverTrustManger,
            redirectHandler: redirectHandler,
            cachedResponseHandler: cachedResponseHandler,
            eventMonitors: eventMonitors
        )
    }
    
}

extension BBNetworkSession: BBNetworkSessionManager {
    
    /// 전달된 URLRequest를 바탕으로 HTTP 통신을 수행합니다.
    /// - Parameters:
    ///   - request: 통신에 사용할 `URLRequset`입니다.
    ///   - completion: 통신이 완료되면 처리할 핸들러입니다.
    /// - Returns: `any BBNetworkCancellable`
    public func request(
        with request: URLRequest,
        completion: @escaping CompletionHandler
    ) -> any BBNetworkCancellable {
        let dataRequest = session.request(request).response(completionHandler: completion)
        dataRequest.resume()
        return dataRequest
    }
    
    public func upload(
        with request: URLRequest,
        data: Data,
        serializer: BBUploadResponseSerializer,
        completion: @escaping UploadHandler
    ) -> any BBNetworkCancellable {
        let uploadRequest = session.upload(data, with: request)

        uploadRequest.response(responseSerializer: serializer) { response in
            completion(response)
        }
        return uploadRequest
    }
}
