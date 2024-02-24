//
//  HomeCGFloat.swift
//  App
//
//  Created by 마경미 on 29.12.23.
//

import Foundation

enum HomeAutoLayout {
    enum FamilyCollectionView {
        static let topInset = 24
        static let height = 90
        static let cellWidth = 64
        static let cellHeight = 90
        static let edgeInsetTop: CGFloat = 0
        static let edgeInsetLeft: CGFloat = 20
        static let edgeInsetBottom: CGFloat = 0
        static let edgeInsetRight: CGFloat = 20
        static let minimumLineSpacing: CGFloat = 12
    }
    
    enum DividerView {
        static let topInset = 170
        static let height = 1
    }
    
    enum TimerLabel {
        static let topOffset = 24
        static let height = 24
        static let horizontalInset = 20
    }
    
    enum DescriptionLabel {
        static let topOffset = 8
        static let horizontalInset = 20
        static let height = 20
    }
    
    enum FeedCollectionView {
        static let topOffset = 24
        static let minimumLineSpacing: CGFloat = 16
        static let minimumInteritemSpacing: CGFloat = 0
        
        enum StackView {
            static let horizontalInset = 20
            static let height = 36
            static let spacing: CGFloat = 0
        }
        
        enum ImageView {
            static let cornerRadius: CGFloat = 24
        }
    }
    
    enum CamerButton {
        static let size = 80
    }
    
    enum InviteFamilyView {
        static let topInset = 24
        static let horizontalInset = 20
        static let height = 90
        static let cornerRadius: CGFloat = 16
        
        enum InviteImageView {
            static let size = 50
            static let leadingInset = 16
        }
        
        enum SubLabel {
            static let topInset = 21
            static let leadingOffset = 13
        }
        
        enum TitleLabel {
            static let topOffset = 2
        }
        
        enum NextIconImageView {
            static let trailingInset = 16
            static let size = 24
        }
    }
    
    enum NoPostTodayView {
        static let topOffset = 24
        
        enum ImageView {
            static let size = 172
            static let topInset = 100
        }
    }
    
    enum ProfileView {
        enum ImageView {
            static let size = 68
            static let cornerRadius: CGFloat = 34
        }
        
        enum NameLabel {
            static let topOffset = 5
        }
    }
}
