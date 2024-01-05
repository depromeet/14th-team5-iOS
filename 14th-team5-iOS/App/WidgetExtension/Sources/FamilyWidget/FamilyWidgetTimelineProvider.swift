//
//  FamilyWidgetTimelineProvider.swift
//  WidgetExtension
//
//  Created by geonhui Yu on 12/6/23.
//

import WidgetKit
import UIKit

struct FamilyWidgetTimelineProvider: TimelineProvider {
    typealias Entry = FamilyWidgetEntry
    
    func placeholder(in context: Context) -> FamilyWidgetEntry {
        return FamilyWidgetEntry(date: Date(), family: nil)
    }
    func getSnapshot(in context: Context, completion: @escaping (FamilyWidgetEntry) -> Void) {
        completion(FamilyWidgetEntry(date: Date(), family: nil))
    }
    func getTimeline(in context: Context, completion: @escaping (Timeline<FamilyWidgetEntry>) -> Void) {
        
        let currentDate = Date()
        let nextUpdateDate = Calendar.current.date(byAdding: .minute, value: 5, to: currentDate) ?? currentDate
        
        FamilyService().getPhoto { result in
            switch result {
            case .success(let family):
                let entry = FamilyWidgetEntry(date: currentDate, family: family)
                let timeline = Timeline(entries: [entry], policy: .after(nextUpdateDate))
                completion(timeline)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
//        Task {
//            do {
//                let family = try await FamilyService().getFamilyInfo()
//                let entry = FamilyWidgetEntry(date: Date(), family: family)
//                let currentDate = Date()
//                let nextRefresh = Calendar.current.date(byAdding: .minute, value: 1, to: currentDate)!
//                let timeline = Timeline(entries: [entry], policy: .after(nextRefresh))
//                completion(timeline)
//            } catch {
//                let entry = FamilyWidgetEntry(date: Date(), family: nil)
//                let nextUpdateDate = Calendar.current.date(byAdding: .minute, value: 1, to: Date()) ?? Date()
//                let time = Timeline(entries: [entry], policy: .after(nextUpdateDate))
//                completion(time)
//            }
//        }
    }
}
