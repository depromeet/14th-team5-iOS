//
//  PostCGFloat.swift
//  App
//
//  Created by 마경미 on 01.01.24.
//

import UIKit

enum PostAutoLayout {
    enum NavigationView {
        static let height = 52
        
        enum BackButton {
            static let size = 52
            static let cornerRadius: CGFloat = 10
        }
        
        enum ProfileImageView {
            static let size = 44
            static let cornerRadius: CGFloat = 22
        }
        
        enum NameLabel {
            static let leading = 12
            static let height = 24
        }
        
        enum DateLabel {
            static let height = 17
        }
    }
    
    enum CollectionView {
        static let topOffset = 8
        static let horizontalInset = 20
        static let height = 20
        static let scrollIndicatorInsets: UIEdgeInsets = .zero
        
        enum CollectionViewCell {
            enum PostImageView {
                static let topInset = 82
                static let cornerRadius: CGFloat = 48
            }
            
            enum ShowSelectableEmojiButton {
                static let trailingInset = 20
                static let height = 36
                static let width = 42
                static let topOffset = 12
                static let cornerRadius: CGFloat = 18
            }
            
            enum EmojiCountStackView {
                static let trailingOffset = -4
                static let topOffset = 12
                static let height = 36
                static let spacing: CGFloat = 4
                static let cornerRadius: CGFloat = 25
                
                enum EmojiCountButton {
                    static let cornerRadius: CGFloat = 18
                    
                    enum EmojiImageView {
                        static let leadingInset = 8
                        static let size = 24
                    }
                    
                    enum CountLabel {
                        static let leadingOffset = 4
                        static let trailingInset = 8
                        static let width = 10
                    }
                }
            }
            
            enum SelectableEmojiStackView {
                static let trailingInset = 20
                static let topOffset = 12
                static let height = 62
                static let cornerRadius: CGFloat = 31
                static let spacing: CGFloat = 16
                static let layoutMargins: UIEdgeInsets = .init(top: 10, left: 16, bottom: 10, right: 16)
            }
        }
    }
    
    enum CollectionViewLayout {
        static let sectionInset: UIEdgeInsets = .zero
        static let minimumLineSpacing: CGFloat = 0
    }
}
