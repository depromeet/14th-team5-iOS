//
//  FamilyWidget.swift
//  WidgetExtension
//
//  Created by geonhui Yu on 12/6/23.
//

import WidgetKit
import SwiftUI
import DesignSystem

@main
struct FamilyWidget: Widget {
    let kind: String = "FamilyWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: FamilyWidgetDIContainer().makeProvider()) { entry in
            if #available(iOSApplicationExtension 17.0, *) {
                FamilyWidgetView(entry: entry)
                    .containerBackground(for: .widget) {}
            } else {
                FamilyWidgetView(entry: entry)
            }
        }
        .supportedFamilies([.systemSmall, .systemLarge])
        .contentMarginsDisabled()
        .configurationDisplayName("삐삐")
        .description("가족들이 생존신고 한 사진을 빠르게\n확인할 수 있어요.")
    }
}



