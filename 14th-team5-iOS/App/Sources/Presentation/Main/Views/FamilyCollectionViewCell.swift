//
//  FamilyCollectionViewCell.swift
//  App
//
//  Created by 마경미 on 05.12.23.
//

import UIKit
import Core

final class FamilyCollectionViewCell: BaseCollectionViewCell<MainViewReactor> {
    static let id: String = "familyCollectionViewCell"
    
    private let profileView = ProfileView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func bind(reactor: MainViewReactor) { }
    
    // 서브 뷰 추가를 위한 메서드
    override func setupUI() {
    }
    
    // 오토레이아웃 설정을 위한 메서드
    override func setupAutoLayout() {
        addSubview(profileView)
        
        profileView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // 뷰의 속성 설정을 위한 메서드
    override func setupAttributes() {
        
    }
}

extension FamilyCollectionViewCell {
    func setCell(data: ProfileData) {
        profileView.setProfile(profile: data)
    }
}
