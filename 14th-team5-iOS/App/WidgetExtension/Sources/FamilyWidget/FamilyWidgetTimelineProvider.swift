//
//  FamilyWidgetTimelineProvider.swift
//  WidgetExtension
//
//  Created by geonhui Yu on 12/6/23.
//

import WidgetKit

struct FamilyWidgetTimelineProvider: TimelineProvider {
    typealias Entry = FamilyWidgetEntry
    
    let placeholderFamily = Family(profileImageUrl: "", postImageUrl: "", postConent: "")
    func placeholder(in context: Context) -> FamilyWidgetEntry {
        return FamilyWidgetEntry(date: Date(), family: placeholderFamily)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (FamilyWidgetEntry) -> Void) {
        completion(FamilyWidgetEntry(date: Date(), family: placeholderFamily))
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<FamilyWidgetEntry>) -> Void) {
        let entry = FamilyWidgetEntry(date: Date(), family: Family(profileImageUrl: "", postImageUrl: "", postConent: ""))
        let time = Timeline(entries: [entry], policy: .atEnd)
        completion(time)
//        Task {
//            do {
//                let family = try await FamilyService().getFamilyInfo()
//                let entry = FamilyWidgetEntry(date: Date(), family: family)
//                let timeline = Timeline(entries: [entry], policy: .after(Calendar.current.date(bySetting: .minute, value: 1, of: Date())!))
//                completion(timeline)
//            } catch {
//                print("Error: \(error)")
//            }
//        }
    }
}
