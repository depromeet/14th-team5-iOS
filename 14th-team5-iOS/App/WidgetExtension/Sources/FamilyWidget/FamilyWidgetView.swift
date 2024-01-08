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
    private let defaultContent: String = "가족에게\n생존신고 할 시간"
    
    var body: some View {
        if let info = entry.family {
            getPhotoView(info: info)
        } else {
            timeToPhotoView
        }
    }
    
    // MARK: 기본상태의 위젯
    private var timeToPhotoView: some View {
        ZStack {
            Color(DesignSystemAsset.black.color)
            VStack {
                Text(defaultContent)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, family == .systemSmall ? 16 : 22)
                    .padding(.top, family == .systemSmall ? 16 : 22)
                    .font(DesignSystemFontFamily.Pretendard.semiBold.swiftUIFont(size: family == .systemSmall ? 18 : 32))
                    .lineSpacing(1.3)
                    .foregroundColor(.white)
                Spacer()
                HStack {
                    Image(uiImage: DesignSystemAsset.tree.image)
                        .resizable()
                        .frame(maxWidth: family == .systemSmall ? 55 : 137)
                        .frame(maxHeight: family == .systemSmall ? 72 : 180)
                    VStack {
                        Spacer()
                        Image(uiImage: DesignSystemAsset.wave.image)
                            .resizable()
                            .frame(maxWidth: family == .systemSmall ? 57 : 123)
                            .frame(maxHeight: family == .systemSmall ? 40 : 85)
                            .padding(.bottom, family == .systemSmall ? 20 : 37)
                    }
                }
            }
        }
    }
    
    // MARK: 가족중 일부가 사진을 올렸을 때 뷰
    private func getPhotoView(info: Family) -> some View {
        ZStack {
            NetworkImageView(url: URL(string: info.postImageUrl ?? ""))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            VStack {
                HStack {
                    NetworkImageView(url: URL(string: info.profileImageUrl ?? ""))
                        .frame(height: family == .systemSmall ? 34 : 52)
                        .frame(width: family == .systemSmall ? 34 : 52)
                        .clipShape(Circle())
                        .background(Circle().stroke(Color.white, lineWidth: 4))
                        .padding(.leading, 14)
                        .padding(.top, 14)
                    Spacer()
                }
                Spacer()
                getContentView(for: info.postContent ?? "할 말이 없네", family: family)
                    .padding(.bottom, family == .systemSmall ? 16 : 22)
            }
        }
    }
    
    // MARK: 8글자 문자 생성하는 뷰
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
        if let url = url, let imageData = try? Data(contentsOf: url), let uiImage = UIImage(data: imageData) {
            Image(uiImage: uiImage)
                .resizable()
        } else {
            Color.white // 추후 변경해야할 사항
        }
    }
}
