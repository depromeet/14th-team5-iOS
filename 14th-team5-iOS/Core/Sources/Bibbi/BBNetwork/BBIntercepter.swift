//
//  BBIntercepter.swift
//  BBNetwork
//
//  Created by 김건우 on 9/25/24.
//

import Alamofire
import Foundation

public final class BBIntercepter: Interceptor {
    
    public override func retry(
        _ request: Request,
        for session: Session,
        dueTo error: any Error,
        completion: @escaping (RetryResult) -> Void
    ) {
        
    }
    
    public override func adapt(
        _ urlRequest: URLRequest,
        for session: Session,
        completion: @escaping (Result<URLRequest, any Error>) -> Void
    ) {
        
    }
    
}
