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
        StaticConfiguration(kind: kind, provider: FamilyWidgetTimelineProvider()) { _ in
            if #available(iOSApplicationExtension 17.0, *) {
                FamilyWidgetView()
                    .containerBackground(for: .widget) {}
            } else {
                FamilyWidgetView()
            }
        }
        .supportedFamilies([.systemMedium])
    }
}
