//
//  FamilyWidgetView.swift
//  WidgetExtension
//
//  Created by geonhui Yu on 12/6/23.
//

import SwiftUI
import DesignSystem
import WidgetKit
import Core
import Domain

struct FamilyWidgetView: View {
    @Environment(\.widgetFamily) var family: WidgetFamily
    let entry: FamilyWidgetEntry
    
    var body: some View {
        if let info = entry.family {
            getPhotoView(info: info)
                .widgetURL(URL(string: "post/view/\(info.postId ?? "")"))
        } else {
            if isCurrentTimeBetween18And24() {
                greenDefaultView
            } else {
                yellowDefaultView
            }
        }
    }
    
    // MARK: 기본상태의 위젯
    private var greenDefaultView: some View {
        ZStack {
            Color(DesignSystemAsset.mainGreen.color)
            HStack {
                Spacer()
                VStack {
                    Spacer()
                    Image(uiImage: DesignSystemAsset.bibbiLogo.image)
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(DesignSystemAsset.black.swiftUIColor)
                        .frame(width: family == .systemSmall ? 47 : 52)
                        .frame(height: family == .systemSmall ? 16 : 18)
                        .padding(.trailing, family == .systemSmall ? 15 : 19)
                        .padding(.bottom, family == .systemSmall ? 16 : 28)
                }
            }
            
            VStack {
                HStack {
                    Text("가족들이\n기다리고 있어요")
                        .foregroundColor(DesignSystemAsset.black.swiftUIColor)
                        .font(DesignSystemFontFamily.Pretendard.semiBold.swiftUIFont(size: family == .systemSmall ? 16 : 26))
                        .lineSpacing(1.3)
                        .padding(.leading, family == .systemSmall ? 3: 12)
                    
                    Spacer()
                    
                    HStack(alignment: .bottom) {
                        if family == .systemLarge {
                            Image(uiImage: DesignSystemAsset.sun.image)
                                .resizable()
                                .frame(width: 58, height: 60)
                        }
                    }
                }
                
                Spacer()
                
                HStack {
                    
                    if family == .systemSmall {
                        Image(uiImage: DesignSystemAsset.greenCharacterS.image)
                    } else {
                        Image(uiImage: DesignSystemAsset.greenCharacterL.image)
                            .frame(height: 235)
                    }
                    
                    Spacer()
                }
            }
            .padding(.leading, family == .systemSmall ? 13 : 10)
            .padding(.top, family == .systemSmall ? 16 : 21)
            .padding(.bottom, family == .systemSmall ? 12 : 20)
            .padding(.trailing, family == .systemSmall ? 16 : 19)
        }
    }
    
    private var yellowDefaultView: some View {
        ZStack {
            Color(DesignSystemAsset.mainYellow.color)
            HStack {
                Spacer()
                if family == .systemSmall {
                    VStack {
                        Spacer()
                        Image(uiImage: DesignSystemAsset.bibbiLogo.image)
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(DesignSystemAsset.black.swiftUIColor)
                            .frame(width: family == .systemSmall ? 47 : 52)
                            .frame(height: family == .systemSmall ? 16 : 18)
                            .padding(.trailing, family == .systemSmall ? 15 : 19)
                            .padding(.bottom, family == .systemSmall ? 16 : 28)
                    }
                }
            }
            
            VStack {
                HStack {
                    Text("가족에게\n생존신고 할 시간!")
                        .foregroundColor(DesignSystemAsset.black.swiftUIColor)
                        .font(DesignSystemFontFamily.Pretendard.semiBold.swiftUIFont(size: family == .systemSmall ? 16 : 26))
                        .lineSpacing(1.3)
                        .padding(.leading, family == .systemSmall ? 3: 12)
                    
                    Spacer()
                    
                    HStack(alignment: .bottom) {
                        if family == .systemLarge {
                            Image(uiImage: DesignSystemAsset.bibbiLogo.image)
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(DesignSystemAsset.black.swiftUIColor)
                                .frame(width: 52, height: 18)
                        }
                    }
                }
                
                Spacer()
                
                HStack {
                    
                    if family == .systemSmall {
                        Image(uiImage: DesignSystemAsset.yellowCharacterS.image)
                    } else {
                        HStack {
                            Spacer()
                            Image(uiImage: DesignSystemAsset.yellowCharacterL.image)
                            Spacer()
                        }
                    }
                    
                    Spacer()
                }
            }
            .padding(.leading, family == .systemSmall ? 16 : 10)
            .padding(.top, family == .systemSmall ? 16 : 20)
            .padding(.bottom, 20)
            .padding(.trailing, family == .systemSmall ? 16 : 22)
        }
    }
    
    // MARK: 가족중 일부가 사진을 올렸을 때 뷰
    private func getPhotoView(info: WidgetPostEntity) -> some View {
        ZStack {
            if let postImageUrl = info.postImageUrl {
                
                NetworkImageView(url: URL(string: postImageUrl))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                VStack {
                    
                    HStack {
                        
                        if let profileImageUrl = info.authorProfileImageUrl {
                            NetworkImageView(url: URL(string: profileImageUrl))
                                .frame(height: family == .systemSmall ? 34 : 52)
                                .frame(width: family == .systemSmall ? 34 : 52)
                                .clipShape(Circle())
                                .background(Circle().stroke(Color.white, lineWidth: 4))
                                .padding(.leading, family == .systemSmall ? 14 : 20)
                                .padding(.top, family == .systemSmall ? 14 : 20)
                            
                        } else {
                            
                            if let firstName = info.authorName.first {
                                Text(String(firstName))
                                    .font(family == .systemSmall
                                          ? DesignSystemFontFamily.Pretendard.semiBold.swiftUIFont(size: 16)
                                          : DesignSystemFontFamily.Pretendard.semiBold.swiftUIFont(size: 18))
                                    .frame(height: family == .systemSmall ? 34 : 52)
                                    .frame(width: family == .systemSmall ? 34 : 52)
                                    .foregroundColor(.white)
                                    .background(Circle().stroke(Color.white, lineWidth: 4))
                                    .background(DesignSystemAsset.gray700.swiftUIColor)
                                    .clipShape(Circle())
                                    .padding(.leading, family == .systemSmall ? 14 : 20)
                                    .padding(.top, family == .systemSmall ? 14 : 20)
                            }
                        }
                        Spacer()
                    }
                    
                    Spacer()
                    
                    getContentView(for: info.postContent ?? "", family: family)
                        .padding(.bottom, family == .systemSmall ? 16 : 22)
                }
            } else {
                
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
    
    private func isCurrentTimeBetween18And24() -> Bool {
        let calendar = Calendar.current
        let currentDate = Date()
        
        let components = calendar.dateComponents([.hour], from: currentDate)
        if let currentHour = components.hour {
            return currentHour >= 18 && currentHour < 24
        }
        
        return false
    }
}

private struct NetworkImageView: View {
    let url: URL?
    
    var body: some View {
        if let url = url, let imageData = try? Data(contentsOf: url), let uiImage = UIImage(data: imageData) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
        } else {
            Color.white // 추후 변경해야할 사항
        }
    }
}
