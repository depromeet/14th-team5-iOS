//
//  FamilyWidgetTimelineProvider.swift
//  WidgetExtension
//
//  Created by geonhui Yu on 12/6/23.
//

import WidgetKit
import UIKit

import Domain

final class FamilyWidgetTimelineProvider: TimelineProvider {
    typealias Entry = FamilyWidgetEntry
    
    let repository: WidgetRepositoryProtocol
    
    init(repository: WidgetRepositoryProtocol) {
        self.repository = repository
    }
    
    func placeholder(in context: Context) -> FamilyWidgetEntry {
        return FamilyWidgetEntry(date: Date(), family: nil)
    }
    func getSnapshot(in context: Context, completion: @escaping (FamilyWidgetEntry) -> Void) {
        completion(FamilyWidgetEntry(date: Date(), family: nil))
    }
    func getTimeline(in context: Context, completion: @escaping (Timeline<FamilyWidgetEntry>) -> Void) {
        let currentDate = Date()
        let refreshDate = Calendar.current.date(byAdding: .minute, value: 5, to: currentDate)!
        
        
        repository.fetchRecentFamilyPost { result in
            var entry: FamilyWidgetEntry
            switch result {
            case .success(let family):
                entry = FamilyWidgetEntry(date: currentDate, family: family)
            case .failure:
                entry = FamilyWidgetEntry(date: currentDate, family: nil)
            }
            
            let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
            completion(timeline)
        }
    }
}
