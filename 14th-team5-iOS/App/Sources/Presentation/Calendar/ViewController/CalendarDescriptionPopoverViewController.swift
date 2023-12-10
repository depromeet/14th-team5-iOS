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
    let descrpitionLabel: UILabel = UILabel()
    
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
            $0.leading.equalTo(view.snp.leading).offset(CalendarVC.AutoLayout.defaultOffsetValue)
            $0.top.equalTo(view.snp.top).offset(CalendarVC.AutoLayout.defaultOffsetValue)
            $0.trailing.equalTo(view.snp.trailing).offset(-CalendarVC.AutoLayout.defaultOffsetValue)
            $0.bottom.equalTo(view.snp.bottom).offset(-CalendarVC.AutoLayout.descriptionLabelBoottomOffsetValue)
        }
    }
    
    private func setupAttributes() {
        descrpitionLabel.do {
            $0.text = CalendarVC.Strings.descriptionText
            $0.textColor = UIColor.white
            $0.textAlignment = .center
        }
        view.backgroundColor = UIColor.darkGray
    }

}
