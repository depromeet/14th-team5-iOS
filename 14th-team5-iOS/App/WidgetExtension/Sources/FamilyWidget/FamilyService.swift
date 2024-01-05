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
    func getFamilyInfo() async throws -> Family? {
        let token = "eyJ0eXBlIjoiYWNjZXNzIiwiYWxnIjoiSFMyNTYiLCJ0eXAiOiJKV1QiLCJyZWdEYXRlIjoxNzA0MzY3NjYzODA2fQ.eyJ1c2VySWQiOiIwMUhKQk5YQVYwVFlRMUtFU1dFUjQ1QTJRUCIsImV4cCI6MTcwNDQ1NDA2M30.XSJCrFz68TobU0Ry35r6Mu9y9f57knsqhSWDipTjKDw"
        let url = URL(string: "https://dev.api.no5ing.kr/v1/widgets/single-recent-family-post")!
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "accept")
        request.addValue(token, forHTTPHeaderField: "X-AUTH-TOKEN")
        request.httpMethod = "GET"
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let familyInfo = try JSONDecoder().decode(Family.self, from: data)
            return familyInfo
        } catch {
            return nil
        }
    }
    
    func getPhoto(completion: @escaping (Result<Family, Error>) -> Void) {
        let urlString = "https://dev.api.no5ing.kr/v1/widgets/single-recent-family-post"
        guard let url = URL(string: urlString) else {
            fatalError("Invalid URL")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "accept")
        request.addValue("eyJ0eXBlIjoiYWNjZXNzIiwiYWxnIjoiSFMyNTYiLCJ0eXAiOiJKV1QiLCJyZWdEYXRlIjoxNzA0MzY3NjYzODA2fQ.eyJ1c2VySWQiOiIwMUhKQk5YQVYwVFlRMUtFU1dFUjQ1QTJRUCIsImV4cCI6MTcwNDQ1NDA2M30.XSJCrFz68TobU0Ry35r6Mu9y9f57knsqhSWDipTjKDw", forHTTPHeaderField: "X-AUTH-TOKEN")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            } else if let response = response as? HTTPURLResponse {
                let statusCode = response.statusCode
                
                guard (200..<300).contains(statusCode) else {
                    let error = NSError(domain: "HTTPError", code: statusCode, userInfo: nil)
                    completion(.failure(error))
                    return
                }
                
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let family = try decoder.decode(Family.self, from: data)
                        completion(.success(family))
                    } catch {
                        completion(.failure(error))
                    }
                }
            }
        }
        
        task.resume()
    }
}


