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
    
    override func setupUI() {
        addSubview(profileView)
    }
    
    override func setupAutoLayout() {
        profileView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func setupAttributes() {
        
    }
}

extension FamilyCollectionViewCell {
    func setCell(data: ProfileData) {
        profileView.setProfile(profile: data)
    }
}
