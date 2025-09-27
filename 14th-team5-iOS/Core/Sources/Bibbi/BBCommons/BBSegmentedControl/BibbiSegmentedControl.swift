//
//  BibbiSegmentedControl.swift
//  Core
//
//  Created by Kim dohyun on 4/15/24.
//

import UIKit

import DesignSystem
import RxCocoa
import RxSwift
import SnapKit
import Then

public enum SelectedSegment {
    case survival
    case mission
    case studio
}

public final class BibbiSegmentedControl: UIView {

    public let selected: BehaviorRelay<SelectedSegment> = .init(value: .survival)
    public let isUpdated: BehaviorRelay<Bool> = .init(value: true)

    internal var survivalButton = UIButton()
    internal var missionButton  = UIButton()
    internal var studioButton   = UIButton()

    private let disposeBag = DisposeBag()

    // MARK: - Init
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupAttributes()
        setupLayout()
        bind()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup
private extension BibbiSegmentedControl {
    func setupUI() {
        addSubviews(
            survivalButton,
            missionButton,
            studioButton
        )
    }

    func setupAttributes() {
        backgroundColor = .gray800
        layer.cornerRadius = 20

        survivalButton.do {
            $0.configuration = .plain()
            $0.configuration?.attributedTitle = AttributedString(
                NSAttributedString(string: "생존",
                                   attributes: [.font: UIFont.style(.body2Bold)])
            )
            $0.layer.cornerRadius = 20
            $0.configuration?.baseBackgroundColor = .clear
        }

        missionButton.do {
            $0.configuration = .plain()
            $0.configuration?.attributedTitle = AttributedString(
                NSAttributedString(string: "미션",
                                   attributes: [.font: UIFont.style(.body2Bold)])
            )
            $0.configuration?.imagePlacement = .trailing
            $0.configuration?.imagePadding = 4
            $0.layer.cornerRadius = 20
            $0.configuration?.baseBackgroundColor = .clear
        }
        
        studioButton.do {
            $0.configuration = .plain()
            $0.configuration?.attributedTitle = AttributedString(
                NSAttributedString(string: "사진관",
                                   attributes: [.font: UIFont.style(.body2Bold)])
            )
            $0.configuration?.imagePlacement = .trailing
            $0.configuration?.imagePadding = 4
            $0.layer.cornerRadius = 20
            $0.configuration?.baseBackgroundColor = .clear
        }
    }

    func setupLayout() {
        survivalButton.snp.makeConstraints {
            $0.top.bottom.left.equalToSuperview()
            $0.width.equalTo(70)
        }

        missionButton.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalTo(survivalButton.snp.trailing)
            $0.width.equalTo(70)
        }
        
        studioButton.snp.makeConstraints {
            $0.top.bottom.trailing.equalToSuperview()
            $0.leading.equalTo(missionButton.snp.trailing)
            $0.width.equalTo(70)
        }
    }

    func bind() {
        let taps = Observable.merge(
            survivalButton.rx.tap.map { SelectedSegment.survival },
            missionButton.rx.tap.map { SelectedSegment.mission },
            studioButton.rx.tap.map { SelectedSegment.studio }
        )

        taps
            .bind(to: selected)
            .disposed(by: disposeBag)

        selected
            .asDriver()
            .drive(rx.segmentStyle)
            .disposed(by: disposeBag)

        isUpdated
            .asDriver()
            .drive(rx.missionBadgeVisible)
            .disposed(by: disposeBag)
    }
}

public extension Reactive where Base: BibbiSegmentedControl {
        var selectedFeedType: ControlProperty<BibbiFeedType> {
            let values = base.selected
                .map { (seg: SelectedSegment) -> BibbiFeedType in
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


//
//    var selectedType: Driver<BibbiFeedType> {
//        base.selected
//            .map { seg -> BibbiFeedType in
//                switch seg {
//                case .survival: return .survival
//                case .mission:  return .mission
//                }
//            }
//            .asDriver(onErrorDriveWith: .empty())
//    }
    
    var setSelectedType: Binder<BibbiFeedType> {
        Binder(base) { control, type in
            switch type {
            case .survival: control.selected.accept(.survival)
            case .mission:  control.selected.accept(.mission)
            case .studio: control.selected.accept(.studio)
            }
        }
    }

    var isUpdated: Binder<Bool> {
        Binder(base) { control, flag in
            control.isUpdated.accept(flag)
        }
    }

    fileprivate var segmentStyle: Binder<SelectedSegment> {
        Binder(base) { control, segment in
            func apply(_ button: UIButton, isOn: Bool) {
                button.backgroundColor = isOn ? .gray100 : .clear
                button.configuration?.baseForegroundColor = isOn ? .bibbiBlack : .gray500
            }

            let isSurvival = (segment == .survival)
            let isMission  = (segment == .mission)
            let isStudio   = (segment == .studio)

            apply(control.survivalButton, isOn: isSurvival)
            apply(control.missionButton,  isOn: isMission)
            apply(control.studioButton,   isOn: isStudio)
        }
    }

    fileprivate var missionBadgeVisible: Binder<Bool> {
        Binder(base) { control, visible in
            control.missionButton.configuration?.image = visible ? DesignSystemAsset.mission.image : nil
        }
    }
}
