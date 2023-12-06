//
//  FamilyWidgetTimelineProvider.swift
//  WidgetExtension
//
//  Created by geonhui Yu on 12/6/23.
//

import WidgetKit

struct FamilyWidgetTimelineProvider: TimelineProvider {
    typealias Entry = FamilyWidgetEntry
    
    func placeholder(in context: Context) -> FamilyWidgetEntry {
        FamilyWidgetEntry()
    }
    
    func getSnapshot(in context: Context, completion: @escaping (FamilyWidgetEntry) -> Void) {
        completion(FamilyWidgetEntry())
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<FamilyWidgetEntry>) -> Void) {
        let timeline = Timeline(entries: [FamilyWidgetEntry()], policy: .never)
        completion(timeline)
    }
}
