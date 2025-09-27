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

    // MARK: - Exposed State
    public let selected: BehaviorRelay<SelectedSegment> = .init(value: .survival)
    public let isUpdated: BehaviorRelay<Bool> = .init(value: true)

    // MARK: - Views
    internal let survivalButton = UIButton(type: .system)
    internal let missionButton  = UIButton(type: .system)
    internal let studioButton   = UIButton(type: .system)

    // MARK: - Private
    private let disposeBag = DisposeBag()

    // MARK: - Init
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupAttributes()
        setupLayout()
        bind()
        applySelection(selected.value) // 초기선택 반영
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupAttributes()
        setupLayout()
        bind()
        applySelection(selected.value)
    }
}

// MARK: - Setup
private extension BibbiSegmentedControl {
    func setupUI() {
        addSubviews(survivalButton, missionButton, studioButton)
    }

    func setupAttributes() {
        backgroundColor = .gray800
        layer.cornerRadius = 20

        func makeConfig(title: String? = nil, image: UIImage? = nil) -> UIButton.Configuration {
            var cfg = UIButton.Configuration.plain()
            cfg.baseBackgroundColor = .clear
            if let title {
                cfg.attributedTitle = AttributedString(
                    NSAttributedString(string: title,
                                       attributes: [.font: UIFont.style(.body2Bold)])
                )
            }
            cfg.image = image
            cfg.imagePlacement = .trailing
            cfg.imagePadding = 4
            cfg.contentInsets = .init(top: 6, leading: 12, bottom: 6, trailing: 12)
            return cfg
        }

        // 공통 업데이트 핸들러
        let updateHandler: UIButton.ConfigurationUpdateHandler = { btn in
            var c = btn.configuration
            if btn.isSelected {
                c?.baseBackgroundColor = .gray100
                c?.baseForegroundColor = .bibbiBlack
            } else {
                c?.baseBackgroundColor = .clear
                c?.baseForegroundColor = .gray500
            }
            btn.configuration = c
            btn.layer.cornerRadius = 20
            btn.layer.masksToBounds = true
        }

        survivalButton.do {
            $0.configuration = makeConfig(title: "생존")
            $0.configurationUpdateHandler = updateHandler
        }

        missionButton.do {
            $0.configuration = makeConfig(title: "미션")
            $0.configurationUpdateHandler = updateHandler
        }

        studioButton.do {
            $0.configuration = .plain()
            $0.configuration?.attributedTitle = AttributedString(
                NSAttributedString(
                    string: "사진관",
                    attributes: [.font: UIFont.style(.body2Bold)])
            )
            $0.configuration?.imagePlacement = .trailing
            $0.configuration?.imagePadding = 4
            $0.layer.cornerRadius = 20
            $0.configuration?.baseBackgroundColor = .clear
            $0.setImage(DesignSystemAsset.studioButton.image, for: .normal)
            $0.configurationUpdateHandler = updateHandler
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
            $0.width.equalTo(94)
        }
    }

    func bind() {
        let taps = Observable.merge(
            survivalButton.rx.tap.map { SelectedSegment.survival },
            missionButton.rx.tap.map { SelectedSegment.mission },
            studioButton.rx.tap.map { SelectedSegment.studio }
        )

        // 탭 → 상태 갱신
        taps
            .bind(to: selected)
            .disposed(by: disposeBag)

        // 상태 변경 → 라디오 선택 반영
        selected
            .asDriver()
            .drive(with: self) { owner, seg in
                owner.applySelection(seg)
            }
            .disposed(by: disposeBag)

        // 미션 뱃지 표시 (그대로 유지)
        isUpdated
            .asDriver()
            .drive(rx.missionBadgeVisible)
            .disposed(by: disposeBag)
    }

    /// 세 버튼을 라디오처럼 하나만 선택되게 반영
    func applySelection(_ segment: SelectedSegment) {
        survivalButton.isSelected = (segment == .survival)
        missionButton.isSelected  = (segment == .mission)
        studioButton.isSelected   = (segment == .studio)
    }
}

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
    fileprivate var missionBadgeVisible: Binder<Bool> {
        Binder(base) { control, visible in
            control.missionButton.configuration?.image = visible ? DesignSystemAsset.mission.image : nil
        }
    }
}
