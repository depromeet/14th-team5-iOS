//
//  CalendarDescriptionPopoverViewController.swift
//  App
//
//  Created by 김건우 on 12/7/23.
//

import UIKit

import Core
import FSCalendar
import ReactorKit
import RxCocoa
import RxSwift
import RxDataSources
import SnapKit
import Then

final class CalendarDescriptionPopoverViewController: UIViewController {
    // MARK: - Views
    let descrpitionLabel: UILabel = UILabel().then {
        $0.text = Strings.descriptionText
        $0.textColor = UIColor.white
        $0.textAlignment = .center
    }
    
    // MARK: - Constants
    private enum Strings {
        static let descriptionText: String = "모두 참여한 날에는 날짜 옆 동그라미가 추가돼요"
    }
    
    private enum AutoLayout {
        static let defaultOffsetValue: CGFloat = 4.0
        static let descriptionLabelBoottomOffsetValue: CGFloat = 16.0
    }
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupAutoLayout()
        setupAttributes()
    }
    
    private func setupUI() {
        view.addSubview(descrpitionLabel)
    }
    
    private func setupAutoLayout() {
        descrpitionLabel.snp.makeConstraints {
            $0.leading.equalTo(view.snp.leading).offset(AutoLayout.defaultOffsetValue)
            $0.top.equalTo(view.snp.top).offset(AutoLayout.defaultOffsetValue)
            $0.trailing.equalTo(view.snp.trailing).offset(-AutoLayout.defaultOffsetValue)
            $0.bottom.equalTo(view.snp.bottom).offset(-AutoLayout.descriptionLabelBoottomOffsetValue)
        }
    }
    
    private func setupAttributes() {
        view.backgroundColor = UIColor.darkGray
    }

}
