//
//  DisplayEditCollectionViewCell.swift
//  App
//
//  Created by Kim dohyun on 12/13/23.
//

import UIKit

import Core


public final class DisplayEditCollectionViewCell: BaseCollectionViewCell<DisplayEditCellReactor> {
    
    private let containerView: UIView = UIView()
    private let descrptionLabel: UILabel = UILabel()
    
    
    public override func setupUI() {
        super.setupUI()
        self.contentView.backgroundColor = .black
    }
    
    public override func setupAttributes() {
        
    }
    
    public override func setupAutoLayout() {
        
    }
    
    
}
