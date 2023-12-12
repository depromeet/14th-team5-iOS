//
//  FamilyWidget.swift
//  WidgetExtension
//
//  Created by geonhui Yu on 12/6/23.
//

import WidgetKit
import SwiftUI

@main
struct FamilyWidget: Widget {
    let kind: String = "FamilyWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: FamilyWidgetTimelineProvider()) { entry in
            if #available(iOSApplicationExtension 17.0, *) {
                FamilyWidgetView(entry: entry)
                    .containerBackground(for: .widget) {}
            } else {
                FamilyWidgetView(entry: entry)
            }
        }
        .supportedFamilies([.systemSmall])
        .contentMarginsDisabled()
        .configurationDisplayName("Bibbi")
        .description("Bibbi description")
    }
}



