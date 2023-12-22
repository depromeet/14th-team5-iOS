//
//  FamilyWidgetView.swift
//  WidgetExtension
//
//  Created by geonhui Yu on 12/6/23.
//

import SwiftUI
import DesignSystem
import WidgetKit

struct FamilyWidgetView: View {
    @Environment(\.widgetFamily) var family: WidgetFamily
    
    let entry: FamilyWidgetEntry
    private let defaultContent: String = "👏사진올릴시간👏"
    
    var body: some View {
        content
    }
    
    @ViewBuilder private var content: some View {
        if let info = entry.family {
            getPhotoView(info: info)
        } else {
            timeToPhotoView
        }
    }
    
    private var timeToPhotoView: some View {
        ZStack {
            Color(DesignSystemAsset.black.color)
            VStack {
                Text("📣")
                    .font(.system(size: family == .systemSmall ? 55 : 138))
                    .padding(.top, family == .systemSmall ? 26 : 46)
                Spacer()
                getContentView(for: defaultContent, family: family)
                    .padding(.bottom, family == .systemSmall ? 16 : 22)
            }
        }
    }
    
    private func getPhotoView(info: Family) -> some View {
        ZStack {
            NetworkImageView(url: URL(string: info.postImageUrl))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            VStack {
                HStack {
                    NetworkImageView(url: URL(string: info.profileImageUrl))
                        .frame(height: family == .systemSmall ? 34 : 52)
                        .frame(width: family == .systemSmall ? 34 : 52)
                        .clipShape(Circle())
                        .background(Circle().stroke(Color.white, lineWidth: 4))
                        .padding(.leading, 14)
                        .padding(.top, 14)
                    Spacer()
                }
                Spacer()
                getContentView(for: info.postConent, family: family)
                    .padding(.bottom, family == .systemSmall ? 16 : 22)
            }
        }
    }
    
    @ViewBuilder private func getContentView(for content: String, family: WidgetFamily) -> some View {
        let spacing: CGFloat = (family == .systemSmall) ? 1.5 : 2
        let fontSize: CGFloat = (family == .systemSmall) ? 12 : 18
        let fixedWidth: CGFloat = (family == .systemSmall) ? 15 : 28
        let fixedHeight: CGFloat = (family == .systemSmall) ? 25 : 41
        let radius: CGFloat = (family == .systemSmall) ? 5 : 10
        
        HStack(spacing: spacing) {
            ForEach(content.map { $0 }, id: \.self) { content in
                Text(String(content))
                    .foregroundColor(.white)
                    .font(DesignSystemFontFamily.Pretendard.semiBold.swiftUIFont(size: fontSize))
                    .frame(width: fixedWidth, height: fixedHeight)
                    .background(Color.black)
                    .cornerRadius(radius)
            }
        }
    }
}

private struct NetworkImageView: View {
    let url: URL?
    
    var body: some View {
        if let url = url, let imageData = try? Data(contentsOf: url),
           let uiImage = UIImage(data: imageData) {
            Image(uiImage: uiImage)
                .resizable()
        }
        else {
            Image("placeholder-image")
        }
    }
}
