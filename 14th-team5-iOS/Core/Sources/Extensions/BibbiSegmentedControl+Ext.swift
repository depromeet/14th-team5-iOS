//
//  BibbiSegmentedControl+Ext.swift
//  Core
//
//  Created by 김도현 on 11/27/25.
//

import RxSwift
import RxCocoa

import DesignSystem

// MARK: - Reactive Extensions
public extension Reactive where Base: BibbiSegmentedControl {

    /// SelectedSegment ↔︎ BibbiFeedType 양방향 바인딩
    var selectedFeedType: ControlProperty<BibbiFeedType> {
        let values = base.selected
            .map { seg -> BibbiFeedType in
                switch seg {
                case .survival: return .survival
                case .mission:  return .mission
                case .studio:   return .studio
                }
            }

        let setter = Binder<BibbiFeedType>(base) { control, feed in
            switch feed {
            case .survival: control.selected.accept(.survival)
            case .mission:  control.selected.accept(.mission)
            case .studio:   control.selected.accept(.studio)
            }
        }

        return ControlProperty(values: values, valueSink: setter.asObserver())
    }

    /// 외부에서 programmatic 선택
    var setSelectedType: Binder<BibbiFeedType> {
        Binder(base) { control, type in
            switch type {
            case .survival: control.selected.accept(.survival)
            case .mission:  control.selected.accept(.mission)
            case .studio:   control.selected.accept(.studio)
            }
        }
    }

    /// 미션 탭 뱃지 토글
    var missionBadgeVisible: Binder<Bool> {
        Binder(base) { control, visible in
            control.missionButton.configuration?.image = visible ? DesignSystemAsset.mission.image : nil
        }
    }
}
