//
//  BaseAPIWorker.swift
//  Data
//
//  Created by geonhui Yu on 12/17/23.
//

import Foundation

import Alamofire
import RxSwift
import RxCocoa
import Core
import Domain

protocol BibbiRouterInterface {
    func httpHeaders(_ headers: [APIHeader]?) -> HTTPHeaders
}

extension BibbiRouterInterface {
    public func httpHeaders(_ headers: [APIHeader]?) -> HTTPHeaders {
        var result: [String: String] = [:]
        guard let headers = headers, !headers.isEmpty else { return HTTPHeaders() }
        
        for header in headers {
            result[header.key] = header.value
        }
        
        return HTTPHeaders(result)
    }
}

public final class BibbiRequestInterceptor: RequestInterceptor, BibbiRouterInterface {
    
    //TODO: Test용 KeychainWrapper 코드 다 제거하기
    private let accountAPIWorker: AccountAPIWorker = AccountAPIWorker()
    private let disposeBag: DisposeBag = DisposeBag()
    
    public func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        
        guard urlRequest.url?.absoluteString.hasPrefix(BibbiAPI.hostApi) == true else {
            completion(.success(urlRequest))
            return
        }
        guard let accessToken = App.Repository.token.accessToken.value?.accessToken else {
            completion(.success(urlRequest))
            return
        }
        
        urlRequest.setValue(accessToken, forHTTPHeaderField: "X-AUTH-TOKEN")
        completion(.success(urlRequest))
    }
    
    public func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 else {
            completion(.doNotRetryWithError(error))
            return
        }
      
        let parameter = AccountRefreshParameter(refreshToken: App.Repository.token.accessToken.value?.refreshToken ?? "")
        
        accountAPIWorker.accountRefreshToken(parameter: parameter)
            .compactMap { $0?.toDomain() }
            .asObservable()
            .subscribe(onNext: { entity in
                let refreshToken = AccessToken(accessToken: entity.accessToken, refreshToken: entity.refreshToken, isTemporaryToken: entity.isTemporaryToken)
                App.Repository.token.accessToken.accept(refreshToken)
                completion(.retry)
            }, onError: { error in
                completion(.doNotRetryWithError(error))
            })
            .disposed(by: disposeBag)
    }
}

// MARK: API Worker
public class APIWorker: NSObject, BibbiRouterInterface {
    
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
    
    // MARK: Identifier
    var id: String = "APIWorker"
    
    // MARK: Request
    func request(spec: APISpec, headers: [APIHeader]? = nil, parameters: [APIParameter]? = nil, encoding: ParameterEncoding? = URLEncoding.default) -> Observable<(HTTPURLResponse, Data)> {
        let params = self.parameters(parameters)
        let hds = self.httpHeaders(self.appendCommonHeaders(to: headers))
        return AF.rx.request(spec.method, spec.url, parameters: params, encoding: encoding!, headers: hds, interceptor: BibbiRequestInterceptor())
            .validate(statusCode: 200..<300)
            .responseData()
            .debug("API Worker has received data from \"\(spec.url)\"")
    }
    
    func request(spec: APISpec, headers: [APIHeader]? = nil, parameters: Encodable, encoding: ParameterEncoding? = URLEncoding.default) -> Observable<(HTTPURLResponse, Data)> {
        let params = parameters.asDictionary()
        let hds = self.httpHeaders(self.appendCommonHeaders(to: headers))
        
        return AF.rx.request(spec.method, spec.url, parameters: params, encoding: encoding!, headers: hds, interceptor: BibbiRequestInterceptor())
            .validate(statusCode: 200..<300)
            .responseData()
            .debug("API Worker has received data from \"\(spec.url)\"")
    }
    
    private func refreshRequest(spec: APISpec, headers: [APIHeader]? = nil, jsonData: Data) -> Observable<(HTTPURLResponse, Data)> {
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
            .validate(statusCode: 200..<300)
            .responseData()
            .debug("API Worker has received data from \"\(spec.url)\"")
    }
    
    private func request(spec: APISpec, headers: [APIHeader]? = nil, jsonData: Data) -> Observable<(HTTPURLResponse, Data)> {
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
        return AF.rx.request(urlRequest: request, interceptor: BibbiRequestInterceptor())
            .validate(statusCode: 200..<300)
            .responseData()
            .debug("API Worker has received data from \"\(spec.url)\"")
    }
    
    func request(spec: APISpec, headers: [APIHeader]? = nil, jsonEncodable: Encodable) -> Observable<(HTTPURLResponse, Data)> {
        guard let jsonData = jsonEncodable.encodeData() else {
            return Observable.error(AFError.explicitlyCancelled)
        }
        
        return self.refreshRequest(spec: spec, headers: headers, jsonData: jsonData)
    }
    
    func upload(spec: APISpec, headers: [APIHeader]? = nil, image: Data) -> Single<Bool> {
        
        let hds = self.httpHeaders(self.appendCommonHeaders(to: headers))
        guard let url = URL(string: spec.url) else {
            return Single.error(AFError.explicitlyCancelled)
        }
        
        var request = URLRequest(url: url)
        request.headers = hds
        
        return Single.create { single -> Disposable in
            AF.upload(image, to: url, method: spec.method, headers: hds, interceptor: BibbiRequestInterceptor())
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
