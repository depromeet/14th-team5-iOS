//
//  BannerView.swift
//  App
//
//  Created by 김건우 on 1/26/24.
//

import DesignSystem
import SwiftUI

struct BannerView: View {
    
    // MARK: - Mertic
    
    private enum Metric { // `isPhoneSE` 프로퍼티 개선하기
        static var topPadding: CGFloat = UIScreen.isPhoneSE ? 12 : 18
        static var vSpacing: CGFloat = UIScreen.isPhoneSE ? 1 : 6
        static var scaleWidth: CGFloat = UIScreen.isPhoneSE ? 0.5 : 1
        static var scaleHeight: CGFloat = UIScreen.isPhoneSE ? 0.5 : 1
        static var yOffset: CGFloat = UIScreen.isPhoneSE ? 9 : 0
    }
    
    // MARK: - Properties
    
    @ObservedObject var viewModel: BannerViewModel
    
    private let bold = DesignSystemFontFamily.Pretendard.bold
    private let regular = DesignSystemFontFamily.Pretendard.regular
    
    
    // MARK: - Intializer
    
    init(viewModel: BannerViewModel) {
        self.viewModel = viewModel
    }
    
    
    // MARK: - Body
    
    var body: some View {
        banner
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background { bannerImage }
            .background(
                Color(
                    uiColor: viewModel.state.bannerColor ?? UIColor.gray500),
                in: RoundedRectangle(
                    cornerRadius: 24,
                    style: .circular
                )
            )
            .shimmering(active: viewModel.shimmeringActive)
            .animation(.default, value: viewModel.shimmeringActive)
            .clipped()
    }
}


// MARK: - Extensions

extension BannerView {
    var banner: some View {
        VStack {
            bannerMainStrings
                .padding(.top, Metric.topPadding)
                .padding(.horizontal, 24)
            
            Spacer()
        }
    }
    
    var bannerMainStrings: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: Metric.vSpacing) {
                familyTopPercentageText
                allFamilyMembersUploadedDaysText
            }
            
            Spacer()
            
            intimacyDescText
                .offset(y: 6)
        }
        .foregroundStyle(Color(uiColor: UIColor.bibbiBlack))
    }
    
    var familyTopPercentageText: some View {
        HStack(alignment: .firstTextBaseline, spacing: 3) {
            Text("상위")
                .font(regular.swiftUIFont(size: 14))
            Text("\(viewModel.state.familyTopPercentage)")
                .font(bold.swiftUIFont(size: 24))
            Text("%")
                .font(bold.swiftUIFont(size: 18))
        }
    }
    
    var allFamilyMembersUploadedDaysText: some View {
        Text("모두 참여한 날 \(viewModel.state.allFamilyMemberUploadedDays)일")
            .font(regular.swiftUIFont(size: 12))
    }
    
    var intimacyDescText: some View {
        Text("\(viewModel.state.bannerString ?? "")")
            .font(regular.swiftUIFont(size: 14))
    }
    
    var bannerImage: some View {
       VStack {
            Spacer()
            Image(uiImage: viewModel.state.bannerImage ?? UIImage())
                .scaleEffect(
                    CGSizeMake(Metric.scaleWidth, Metric.scaleHeight),
                    anchor: .center
                )
                .scaledToFit()
                .offset(y: Metric.yOffset)
        }
    }
}


// MARK: - Preview

struct BannerView_Previews: PreviewProvider {
    static let viewModel = BannerViewModel(state:
        .init(
            familyTopPercentage: 10,
            allFamilyMemberUploadedDays: 20,
            bannerImage: DesignSystemAsset.aloneWalking.image,
            bannerString: "조금 서먹한 사이",
            bannerColor: UIColor.graphicBlue
        )
    )
    
    static var previews: some View {
        return BannerView(viewModel: viewModel)
    }
}
