//
//  APIWorker.swift
//  Data
//
//  Created by 김건우 on 6/3/24.
//

import Core
import Foundation

import Alamofire
import RxAlamofire
import RxCocoa
import RxSwift


// MARK: - Base API Worker

@available(*, deprecated, renamed: "BBAPIWorker")
public class APIWorker: NSObject {
    
    // MARK: - Identifier
    
    var id: String = "APIWorker"
    private static let session: Session = {
        let networkMonitor: BBNetworkEventMonitor = BBNetworkDefaultLogger()
        let networkConfiguration: URLSessionConfiguration = AF.session.configuration
        let networkInterceptor: RequestInterceptor = NetworkInterceptor()
        let networkSession: Session = Session(
            configuration: networkConfiguration,
            interceptor: networkInterceptor,
            eventMonitors: [networkMonitor]
        )
        return networkSession
    }()
    
    // MARK: - Request
    
    func request(
        spec: APISpec,
        headers: [APIHeader]? = nil,
        parameters: [APIParameter]? = nil,
        encoding: ParameterEncoding? = URLEncoding.default
    ) -> Observable<(HTTPURLResponse, Data)> {
        
        let headers = self.httpHeaders(headers)
        let parameters = self.parameters(parameters)
    
        return APIWorker.session.rx.request(
            spec.method,
            spec.url,
            parameters: parameters,
            encoding: encoding!,
            headers: headers,
            interceptor: NetworkInterceptor()
        )
        .validate(statusCode: 200..<300)
        .responseData()
    }
    
    func request(
        spec: APISpec,
        headers: [APIHeader]? = nil,
        parameters: Encodable,
        encoding: ParameterEncoding? = URLEncoding.default
    ) -> Observable<(HTTPURLResponse, Data)> {
        
        let headers = self.httpHeaders(headers)
        let parameters = parameters.asDictionary()
        
        return APIWorker.session.rx.request(
            spec.method,
            spec.url,
            parameters: parameters,
            encoding: encoding!,
            headers: headers,
            interceptor: NetworkInterceptor()
        )
        .validate(statusCode: 200..<300)
        .responseData()
    }
    
    private func refreshRequest(
        spec: APISpec,
        headers: [APIHeader]? = nil,
        jsonData: Data
    ) -> Observable<(HTTPURLResponse, Data)> {
        
        let headers = self.httpHeaders(headers)
        guard let url = URL(string: spec.url) else {
            return Observable.error(AFError.explicitlyCancelled)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = spec.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.headers = headers
        request.httpBody = jsonData
        
        return AF.rx.request(urlRequest: request)
            .retry(5)
            .validate(statusCode: 200..<300)
            .responseData()
    }
    
    private func request(
        spec: APISpec,
        headers: [APIHeader]? = nil,
        jsonData: Data
    ) -> Observable<(HTTPURLResponse, Data)> {
        
        let headers = self.httpHeaders(headers)
        guard let url = URL(string: spec.url) else {
            return Observable.error(AFError.explicitlyCancelled)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = spec.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.headers = headers
        request.httpBody = jsonData
        
        return APIWorker.session.rx.request(
            urlRequest: request,
            interceptor: NetworkInterceptor()
        )
        .validate(statusCode: 200..<300)
        .responseData()
    }
    
    func request(
        spec: APISpec,
        headers: [APIHeader]? = nil,
        jsonEncodable: Encodable
    ) -> Observable<(HTTPURLResponse, Data)> {
        guard let jsonData = try? jsonEncodable.toData() else {
            return Observable.error(AFError.explicitlyCancelled)
        }
        
        return self.refreshRequest(spec: spec, headers: headers, jsonData: jsonData)
    }
    
    
    // MARK: - Upload
    
    func upload(
        spec: APISpec,
        headers: [APIHeader]? = nil,
        image: Data
    ) -> Single<Bool> {
        
        let headers = self.httpHeaders(headers)
        guard let url = URL(string: spec.url) else {
            return Single.error(AFError.explicitlyCancelled)
        }
        
        var request = URLRequest(url: url)
        request.headers = headers
        
        return Single.create { single -> Disposable in
            APIWorker.session.upload(
                image,
                to: url,
                method: spec.method,
                headers: headers,
                interceptor: NetworkInterceptor()
            )
            .validate(statusCode: [200, 204, 205])
            .responseData(emptyResponseCodes: [200, 204, 205]) { response in
                switch response.result {
                case .success(_):
                    single(.success(true))
                case let .failure(failure):
                    single(.failure(failure))
                }
            }
            return Disposables.create()
        }
        
    }
}


// MARK: - Extensions

extension APIWorker {
    
    private func parameters(_ parameters: [APIParameter]?) -> Parameters? {
        guard let kvs = parameters else { return nil }
        var result: [String: Any] = [:]
        
        for kv in kvs {
            result[kv.key] = kv.value
        }
        
        return result.isEmpty ? nil: result
    }
    
    private func httpHeaders(_ headers: [APIHeader]?) -> HTTPHeaders {
        var result: [String: String] = [:]
        guard let headers = headers, !headers.isEmpty else { return HTTPHeaders() }
        
        for header in headers {
            result[header.key] = header.value
        }
        
        return HTTPHeaders(result)
    }
    

    
    
    @available(*, deprecated)
    private func appendCommonHeaders(to headers: [APIHeader]?) -> [APIHeader] {
        var result: [APIHeader] = BibbiAPI.Header.baseHeaders
        guard let headers = headers else { return result }
        
        result.append(contentsOf: headers)
        
        return result
    }
    
    @available(*, deprecated, message: "Intercepter에서 필요한 헤더가 자동으로 추가됩니다.")
    var _headers: Observable<[APIHeader]?> {
        return App.Repository.token.accessToken
            .map {
                guard let token = $0, let accessToken = token.accessToken, !accessToken.isEmpty else { return [] }
                return [BibbiAPI.Header.xAppKey, BibbiAPI.Header.xAuthToken(accessToken)]
            }
    }
    
}

