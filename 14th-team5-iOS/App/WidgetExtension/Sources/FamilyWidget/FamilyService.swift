//
//  FamilyService.swift
//  WidgetExtension
//
//  Created by geonhui Yu on 12/11/23.
//

import Foundation
import UIKit
import Core

struct FamilyService {
    func fetchInfo(completion: @escaping (Result<Family?, Error>) -> Void) {
//        let token = "eyJyZWdEYXRlIjoxNzA0Njc1NDEwODk4LCJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiIsInR5cGUiOiJhY2Nlc3MifQ.eyJ1c2VySWQiOiIwMUhKQk5XWkdOUDFLSk5NS1dWWkowMzlIWSIsImV4cCI6MTcwNDc2MTgxMH0.cSf1uH8G-kVZS1dpf4eJwutoAlj2-oK-z05rIaSdtbk"
        
        let token = App.Repository.token.accessToken.value?.accessToken
        let appKey = "9c61cc7b-0fe9-40eb-976e-6a74c8cb9092"
        let urlString = "https://dev.api.no5ing.kr/v1/widgets/single-recent-family-post"
        
        var request = URLRequest(url: URL(string: urlString)!)
        request.addValue("application/json", forHTTPHeaderField: "accept")
        request.addValue(token ?? "", forHTTPHeaderField: "X-AUTH-TOKEN")
        request.addValue(appKey, forHTTPHeaderField: "X-APP-KEY")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let noDataError = NSError(domain: "NoDataError", code: 0, userInfo: nil)
                completion(.failure(noDataError))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let family = try decoder.decode(Family.self, from: data)
                completion(.success(family))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}


