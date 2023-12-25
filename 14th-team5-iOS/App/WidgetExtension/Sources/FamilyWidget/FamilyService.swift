//
//  FamilyService.swift
//  WidgetExtension
//
//  Created by geonhui Yu on 12/11/23.
//

import Foundation
import Data
import Domain

struct FamilyService {
    func getFamilyInfo() async throws -> Family {
        let url = URL(string: "https://dev.api.no5ing.kr/v1/widgets/single-recent-family-post")!
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let quote = try JSONDecoder().decode(Family.self, from: data)
            return quote
        } catch {
            throw error
        }
    }
}
