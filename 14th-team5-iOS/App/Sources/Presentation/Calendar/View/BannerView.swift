//
//  BannerView.swift
//  App
//
//  Created by 김건우 on 1/26/24.
//


import UIKit
import DesignSystem
import SwiftUI

struct BannerView: View {
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
                Color(uiColor: viewModel.state.bannerColor ?? UIColor.skyBlue),
                in: RoundedRectangle(
                    cornerRadius: 24,
                    style: .circular
                )
            )
    }
}

// MARK: - Extensions
extension BannerView {
    var banner: some View {
        VStack {
            bannerMainStrings
                .padding(.top, 18)
                .padding(.horizontal, 24)
            
            Spacer()
        }
    }
    
    var bannerMainStrings: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 6) {
                familyTopPercentageText
                allFamilyMembersUploadedDaysText
            }
            
            Spacer()
            
            intimacyDescText
                .offset(y: 6)
        }
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
                .scaledToFit()
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
            bannerColor: UIColor.skyBlue
        )
    )
    
    static var previews: some View {
        return BannerView(viewModel: viewModel)
    }
}
