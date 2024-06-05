//
//  FamilyService.swift
//  WidgetExtension
//
//  Created by geonhui Yu on 12/11/23.
//
//
//import Foundation
//import UIKit
//import Core
//
//struct FamilyService {
//    func fetchInfo(completion: @escaping (Result<Family?, Error>) -> Void) {
//        
//        let token = App.Repository.token.keychain.string(forKey: "accessToken")
//        let appKey = "7c5aaa36-570e-491f-b18a-26a1a0b72959"
//#if PRD
//        var hostApi: String = "https://api.no5ing.kr/v1"
//#else
//        var hostApi: String = "https://dev.api.no5ing.kr/v1"
//#endif
//        let urlString = "\(hostApi)/widgets/single-recent-family-post"
//        
//        var request = URLRequest(url: URL(string: urlString)!)
//        request.addValue("application/json", forHTTPHeaderField: "accept")
//        request.addValue(token ?? "", forHTTPHeaderField: "X-AUTH-TOKEN")
//        request.addValue(appKey, forHTTPHeaderField: "X-APP-KEY")
//        request.httpMethod = "GET"
//        
//        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//            
//            guard let data = data else {
//                let noDataError = NSError(domain: "NoDataError", code: 0, userInfo: nil)
//                completion(.failure(noDataError))
//                return
//            }
//            
//            do {
//                let decoder = JSONDecoder()
//                let family = try decoder.decode(Family.self, from: data)
//                completion(.success(family))
//            } catch {
//                completion(.failure(error))
//            }
//        }
//        task.resume()
//    }
//}
//
//
