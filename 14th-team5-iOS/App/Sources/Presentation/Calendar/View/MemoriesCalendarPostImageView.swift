//
//  MemoriesCalendarPostImageView.swift
//  App
//
//  Created by 김건우 on 10/17/24.
//

import Core
import UIKit

import Then
import SnapKit

final class MemoriesCalendarPostImageView: BaseView<MemoriesCalendarPostImageReactor> {
    
    // MARK: - Views
    
    private let imageView: UIImageView = UIImageView()
    private let missionText: MissionTextView = MissionTextView()
    
    // MARK: - Helpers
    
    public override func setupUI() {
        super.setupUI()
        
        addSubviews(imageView, missionText)
    }
    
    public override func setupAutoLayout() {
        super.setupAutoLayout()
        
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        missionText.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.horizontalEdges.equalToSuperview().inset(32)
            $0.height.equalTo(41)
        }
    }
    
    public override func setupAttributes() {
        super.setupAttributes()
        
        imageView.do {
            $0.clipsToBounds = true
            $0.backgroundColor = UIColor.gray100
            $0.contentMode = .scaleAspectFill
            $0.layer.cornerRadius = 48
        }
        
        missionText.do {
            $0.isHidden = true
        }
    }
    
}


// MARK: - Extensions

extension MemoriesCalendarPostImageView {
    
    func prepareForReuse() {
        imageView.image = nil
        missionText.setHidden(hidden: true)
    }
    
    func setPostImage(imageUrl url: String) {
        imageView.kf.setImage(with: URL(string: url)!)
    }
    
    func setMissionText(text: String?) {
        missionText.setHidden(hidden: false)
        missionText.setMissionText(text: text)
    }
    
}
