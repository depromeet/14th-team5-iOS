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


extension NSMutableData {
    func appendString(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}

public final class BibbiRequestInterceptor: RequestInterceptor, BibbiRouterInterface {
    //TODO: SingleTone이 좋은지 피드백 부탁드립니다.
    private let accountAPIWorker: AccountAPIWorker = AccountAPIWorker()
    private let disposeBag: DisposeBag = DisposeBag()
    //TODO: Refresh Token 관련 Interceptor 추가 예정임
    
    public func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        print("url AbsoluteString: \(BibbiAPI.hostApi) check \(urlRequest.url?.absoluteString)")
        guard urlRequest.url?.absoluteString.hasPrefix(BibbiAPI.hostApi) == true else {
            completion(.success(urlRequest))
            return
        }
//        let hds = self.httpHeaders([BibbiAPI.Header.auth(App.Repository.token.accessToken.value ?? "")])
//        urlRequest.headers.add(name: "X-AUTH-TOKEN", value: App.Repository.token.accessToken.value ?? "")
//        print(" or check AccessToken \(App.Repository.token.accessToken.value)")
//        setValue(App.Repository.token.accessToken.value, forHTTPHeaderField: "X-AUTH-TOKEN")
        print("check Adapter : \(urlRequest.headers)")
        
        completion(.success(urlRequest))
    }
    
    public func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard let statusCode = request.response?.statusCode, statusCode == 401 else {
                completion(.doNotRetryWithError(error))
                return
            }
        let parameter = AccountRefreshParameter(refreshToken: App.Repository.token.accessToken.value?.refreshToken ?? "")
            
            accountAPIWorker.accountRefreshToken(parameter: parameter)
                .compactMap { $0?.toDomain() }
                .asObservable()
                .subscribe(onNext: { entity in
                    print("refresh Entity Check: \(entity)")
                    
                    let token = AccessToken(accessToken: entity.accessToken, refreshToken: entity.refreshToken, isTemporaryToken: entity.isTemporaryToken)
                    App.Repository.token.accessToken.accept(token)
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
        let hds = self.httpHeaders(headers)
        
        return AF.rx.request(spec.method, spec.url, parameters: params, encoding: encoding!, headers: hds, interceptor: BibbiRequestInterceptor())
            .responseData()
            .debug("API Worker has received data from \"\(spec.url)\"")
    }
    
    func request(spec: APISpec, headers: [APIHeader]? = nil, parameters: Encodable, encoding: ParameterEncoding? = URLEncoding.default) -> Observable<(HTTPURLResponse, Data)> {
        let params = parameters.asDictionary()
        let hds = self.httpHeaders(headers)
        
        return AF.rx.request(spec.method, spec.url, parameters: params, encoding: encoding!, headers: hds, interceptor: BibbiRequestInterceptor())
            .responseData()
            .debug("API Worker has received data from \"\(spec.url)\"")
    }
    
    private func request(spec: APISpec, headers: [APIHeader]? = nil, jsonData: Data) -> Observable<(HTTPURLResponse, Data)> {

        let hds = self.httpHeaders(headers)
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
            .responseData()
            .debug("API Worker has received data from \"\(spec.url)\"")
    }
    
    func request(spec: APISpec, headers: [APIHeader]? = nil, jsonEncodable: Encodable) -> Observable<(HTTPURLResponse, Data)> {
        guard let jsonData = jsonEncodable.encodeData() else {
            return Observable.error(AFError.explicitlyCancelled)
        }
        
        return self.request(spec: spec, headers: headers, jsonData: jsonData)
    }
    
    func upload(spec: APISpec, headers: [APIHeader]? = nil, image: Data) -> Single<Bool> {
        
        let hds = self.httpHeaders(headers)
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
