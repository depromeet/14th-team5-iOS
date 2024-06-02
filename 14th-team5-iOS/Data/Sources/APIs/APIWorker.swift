//
//  BBAPIWorker.swift
//  Data
//
//  Created by 김건우 on 6/2/24.
//

import Core
import Foundation

import Alamofire
import RxAlamofire
import RxCocoa
import RxSwift


// MARK:  - API Worker

public class APIWorker: NSObject {

    // MARK: - Intercepter
    
    private let intercepter = NetworkIntercepter()
    
    
    // MARK: - Identifier
    
    var id: String = "APIWorker"
    
    
    
    // MARK: - Request
    
    func request(
        spec: APISpec,
        headers: [APIHeader]? = nil,
        parameters: [APIParameter]? = nil,
        encoding: ParameterEncoding? = URLEncoding.default
    ) -> Observable<(HTTPURLResponse, Data)> {
        let params = self.parameters(parameters)
        let hds = self.httpHeaders(self.appendCommonHeaders(to: headers))
        return AF.rx.request(
            spec.method, spec.url,
            parameters: params,
            encoding: encoding!,
            headers: hds,
            interceptor: NetworkIntercepter()
        )
        .validate(statusCode: 200..<300)
        .responseData()
        .debug("API Worker has received data from \"\(spec.url)\"")
    }
    
    func request(
        spec: APISpec,
        headers: [APIHeader]? = nil,
        parameters: Encodable,
        encoding: ParameterEncoding? = URLEncoding.default
    ) -> Observable<(HTTPURLResponse, Data)> {
        let params = parameters.asDictionary()
        let hds = self.httpHeaders(self.appendCommonHeaders(to: headers))
        
        return AF.rx.request(
            spec.method,
            spec.url,
            parameters: params,
            encoding: encoding!,
            headers: hds,
            interceptor: NetworkIntercepter()
        )
        .validate(statusCode: 200..<300)
        .responseData()
        .debug("API Worker has received data from \"\(spec.url)\"")
    }
    
    private func refreshRequest(
        spec: APISpec,
        headers: [APIHeader]? = nil,
        jsonData: Data
    ) -> Observable<(HTTPURLResponse, Data)> {
        let hds = self.httpHeaders(self.appendCommonHeaders(to: headers))
        guard let url = URL(string: spec.url) else {
            return Observable.error(AFError.explicitlyCancelled)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = spec.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        request.headers = hds
        print("interCepter call with name \(url)")
        
        return AF.rx.request(urlRequest: request)
            .retry(5)
            .validate(statusCode: 200..<300)
            .responseData()
            .debug("API Worker has received data from \"\(spec.url)\"")
    }
    
    private func request(
        spec: APISpec,
        headers: [APIHeader]? = nil,
        jsonData: Data
    ) -> Observable<(HTTPURLResponse, Data)> {
        let hds = self.httpHeaders(self.appendCommonHeaders(to: headers))
        guard let url = URL(string: spec.url) else {
            return Observable.error(AFError.explicitlyCancelled)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = spec.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        request.headers = hds
        print("interCepter call with name \(url)")
        return AF.rx.request(
            urlRequest: request,
            interceptor: intercepter
        )
        .validate(statusCode: 200..<300)
        .responseData()
        .debug("API Worker has received data from \"\(spec.url)\"")
    }
    
    func request(
        spec: APISpec,
        headers: [APIHeader]? = nil,
        jsonEncodable: Encodable
    ) -> Observable<(HTTPURLResponse, Data)> {
        guard let jsonData = jsonEncodable.encodeData() else {
            return Observable.error(AFError.explicitlyCancelled)
        }
        
        return self.refreshRequest(
            spec: spec,
            headers: headers,
            jsonData: jsonData
        )
    }
    
    func upload(
        spec: APISpec,
        headers: [APIHeader]? = nil,
        image: Data
    ) -> Single<Bool> {
        
        let hds = self.httpHeaders(self.appendCommonHeaders(to: headers))
        guard let url = URL(string: spec.url) else {
            return Single.error(AFError.explicitlyCancelled)
        }
        
        var request = URLRequest(url: url)
        request.headers = hds
        
        return Single.create { [weak self] single -> Disposable in
            AF.upload(
                image,
                to: url,
                method: spec.method,
                headers: hds,
                interceptor: self?.intercepter
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
    
    
    // MARK: - Headers
    
    var _headers: Observable<[APIHeader]?> {
        return App.Repository.token.accessToken
            .map {
                guard let token = $0, let accessToken = token.accessToken, !accessToken.isEmpty else { return [] }
                return [BibbiAPI.Header.xAppKey, BibbiAPI.Header.xAuthToken(accessToken)]
            }
    }
    
    
    public func httpHeaders(_ headers: [APIHeader]?) -> HTTPHeaders {
        var result: [String: String] = [:]
        guard let headers = headers, !headers.isEmpty else { return HTTPHeaders() }
        
        for header in headers {
            result[header.key] = header.value
        }
        
        return HTTPHeaders(result)
    }
    
    
    private func appendCommonHeaders(to headers: [APIHeader]?) -> [APIHeader] {
        var result: [APIHeader] = BibbiAPI.Header.baseHeaders
        guard let headers = headers else { return result }
        
        result.append(contentsOf: headers)
        
        return result
    }
    
    private func parameters(_ parameters: [APIParameter]?) -> Parameters? {
        guard let kvs = parameters else { return nil }
        var result: [String: Any] = [:]
        
        for kv in kvs {
            result[kv.key] = kv.value
        }
        
        return result.isEmpty ? nil: result
    }
    
    
}
