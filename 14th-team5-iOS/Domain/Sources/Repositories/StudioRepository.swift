//
//  StudioRepository.swift
//  Domain
//
//  Created by 마경미 on 27.09.25.
//

import Foundation
import RxSwift

public protocol StudioRepositoryProtocol {
    func fetchStudioCount(aiPostType: String) -> Observable<StudioCountEntity?>
    func fetchStudioThemeList() -> Observable<[StudioThemeEntity]?>
}
