//
//  MainFamilyCellDIContainer.swift
//  App
//
//  Created by 마경미 on 21.04.24.
//

import Foundation

import Core
import Data
import Domain

final class MainFamilyCellDIContainer {
    func makeCell(data: ProfileData) -> FamilyCollectionViewCell {
        return FamilyCollectionViewCell(reacter: makeReactor(data: data))
    }
    
    private func makeReactor(data: ProfileData) -> MainFamilyCellReactor {
        return MainFamilyCellReactor(initialState: .init(profileData: data))
    }
}
