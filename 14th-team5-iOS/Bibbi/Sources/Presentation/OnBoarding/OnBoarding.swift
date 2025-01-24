//
//  OnBoarding.swift
//  App
//
//  Created by geonhui Yu on 12/10/23.
//

import UIKit

import DesignSystem

typealias OnBoardingInfo = OnBoarding.Info
enum OnBoarding {
    struct Info {
        let title: String
        let image: UIImage
    }
    
    static var info: [Self.Info] = [
        Info(title: OnBoardingStrings.push, image: DesignSystemAsset.onBoarding01.image),
        Info(title: OnBoardingStrings.widget, image: DesignSystemAsset.onBoarding02.image),
        Info(title: OnBoardingStrings.mission, image: DesignSystemAsset.onBoarding03.image),
        Info(title: OnBoardingStrings.permission, image: DesignSystemAsset.onBoarding04.image)
    ]
}
