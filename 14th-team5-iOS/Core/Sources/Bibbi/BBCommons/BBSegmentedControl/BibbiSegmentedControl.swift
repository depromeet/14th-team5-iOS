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
    public let isUpdated: BehaviorRelay<Bool> = .init(value: false)

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
        applySelection(selected.value)
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

        let updateHandler: UIButton.ConfigurationUpdateHandler = { [weak self] btn in
            guard let self = self else { return }
            var c = btn.configuration

            if btn.isSelected {
                if btn != self.studioButton {               // ← 스튜디오는 배경색/전경색 안 건드림
                    btn.backgroundColor = .gray100
                    c?.baseForegroundColor = .bibbiBlack
                }
            } else {
                btn.backgroundColor = .clear
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
            $0.configurationUpdateHandler = { btn in
                var config = btn.configuration ?? .plain()

                // 상태별 배경 이미지
                var bg = UIBackgroundConfiguration.clear()
                bg.image = btn.isSelected
                    ? DesignSystemAsset.studioSelected.image
                    : DesignSystemAsset.studioUnselected.image
                bg.imageContentMode = .scaleAspectFill

                config.background = bg
                config.attributedTitle = nil
                config.baseForegroundColor = .clear
                config.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)

                btn.configuration = config
                btn.layer.cornerRadius = 20
                btn.clipsToBounds = true
            }
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
