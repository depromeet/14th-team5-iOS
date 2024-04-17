//
//  BibbiSegmentedControl.swift
//  Core
//
//  Created by Kim dohyun on 4/15/24.
//

import UIKit

import DesignSystem
import SnapKit
import Then

/// MARK:  API 호출 Paramers 사용 용도
public enum BibbiSegmentedType: String {
  case survival = "SURVIVAL"
  case mission = "MISSION"
}

// MARK: BibbiSegmentedControl
public final class BibbiSegmentedControl: UIView {
  
  
  //MARK: Property
  public let survivalButton: UIButton = UIButton()
  public let missionButton: UIButton = UIButton()
  public var isSelected: BibbiSegmentedType = .survival {
    didSet {
      updateSegmentedLayout(type: isSelected)
    }
  }
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
    setupAttributes()
    setupAutoLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    addSubviews(survivalButton, missionButton)
  }
  
  private func setupAttributes() {
    
    survivalButton.do {
      $0.configuration = .plain()
      $0.configuration?.baseForegroundColor = .bibbiBlack
      $0.configuration?.attributedTitle = AttributedString(NSAttributedString(string: "생존", attributes: [
        .font: UIFont.pretendard(.body2Bold),
      ]))
      $0.backgroundColor = .gray100
      $0.layer.cornerRadius = 20
      $0.configuration?.baseBackgroundColor = .clear
    }
    
    
    missionButton.do {
      $0.configuration = .plain()
      $0.configuration?.baseForegroundColor = .bibbiBlack
      $0.configuration?.attributedTitle = AttributedString(NSAttributedString(string: "미션", attributes: [
        .font: UIFont.pretendard(.body2Bold),
      ]))
      $0.configuration?.imagePlacement = .trailing
      $0.configuration?.imagePadding = 4
      $0.configuration?.image = DesignSystemAsset.mission.image
      $0.layer.cornerRadius = 20
      $0.configuration?.baseBackgroundColor = .clear
    }
    
  }
  
  private func setupAutoLayout() {
    survivalButton.snp.makeConstraints {
      $0.top.left.equalToSuperview()
      $0.width.equalTo(70)
      $0.height.equalTo(40)
    }
    
    missionButton.snp.makeConstraints {
      $0.top.right.equalToSuperview()
      $0.width.equalTo(70)
      $0.height.equalTo(40)
    }
  }
  
  private func updateSegmentedLayout(type: BibbiSegmentedType) {
    survivalButton.backgroundColor = type == .survival ? .gray100 : .clear
    missionButton.backgroundColor = type == .mission ? .gray100 : .clear
    survivalButton.configuration?.baseForegroundColor = type == .survival ? .bibbiBlack : .gray500
    missionButton.configuration?.baseForegroundColor = type == .mission ? .bibbiBlack : .gray500
  }
}


