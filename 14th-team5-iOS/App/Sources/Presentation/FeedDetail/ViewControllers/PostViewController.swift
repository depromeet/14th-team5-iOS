////
////  PostViewController.swift
////  App
////
////  Created by 마경미 on 20.12.23.
////
//
//import UIKit
//import Core
//import DesignSystem
//
//import RxSwift
//
//final class PostViewController: BaseViewController<PostReactor> {
//    private let navigationView = PostNavigationView()
//    private let backgroundImageView = UIImageView()
//    private let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffect.Style.dark))
//    private let imageView = UIImageView()
//    //        private let imageTextLabel = UILabel()
//    private let standardEmojiStackView = UIStackView()
//    private let addEmojiButton = UIButton()
//    private let emojiCountStackView = UIStackView()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//    }
//    
//    override func setupUI() {
//        super.setupUI()
//        
//        view.addSubviews(backgroundImageView, blurEffectView, navigationView,
//                    imageView, emojiCountStackView, standardEmojiStackView)
//    }
//    
//    override func setupAutoLayout() {
//        super.setupAutoLayout()
//        
//        backgroundImageView.snp.makeConstraints {
//            $0.edges.equalToSuperview()
//        }
//        
//        blurEffectView.snp.makeConstraints {
//            $0.edges.equalToSuperview()
//        }
//        
//        
//        navigationView.snp.makeConstraints {
//            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
//            $0.height.equalTo(52)
//        }
//        
//        imageView.snp.makeConstraints {
//            $0.horizontalEdges.equalToSuperview()
//            $0.top.equalTo(navigationView.snp.bottom).offset(82)
//            $0.height.equalTo(view.snp.width)
//        }
//        
//        emojiCountStackView.snp.makeConstraints {
//            $0.trailing.equalToSuperview().inset(20)
//            $0.top.equalTo(imageView.snp.bottom).offset(6)
//            $0.height.equalTo(30)
//        }
//        
//        standardEmojiStackView.snp.makeConstraints {
//            $0.horizontalEdges.bottom.equalToSuperview()
//            $0.height.equalTo(50)
//        }
//    }
//    
//    override func setupAttributes() {
//        super.setupAttributes()
//        
//        backgroundImageView.do {
//            $0.kf.setImage(with: URL(string: "https://src.hidoc.co.kr/image/lib/2021/4/28/1619598179113_0.jpg")!)
//        }
//        
////        blurEffectView.do {
//////            $0.frame = backgroundImageView.bounds
//////            $0.autoresizingMask = [.flexibleWidth, .flexibleHeight]
////        }
//        
//        imageView.do {
//            $0.clipsToBounds = true
//            $0.layer.cornerRadius = 24
//        }
//        
//        standardEmojiStackView.do {
//            $0.distribution = .equalCentering
//            $0.spacing = 5
//            $0.isHidden = true
//        }
//        
//        addEmojiButton.do {
//            $0.setImage(DesignSystemAsset.addEmoji.image, for: .normal)
//            $0.backgroundColor = .blue
//        }
//        
//        emojiCountStackView.do {
//            $0.distribution = .fillEqually
//            $0.backgroundColor = UIColor(red: 0.192, green: 0.192, blue: 0.192, alpha: 1)
//            $0.spacing = 15
//            $0.layer.cornerRadius = 25
//            $0.addArrangedSubview(addEmojiButton)
//        }
//    }
//}
//
//extension PostViewController {
//    private func showStandardEmojiStackView(_ isShowing: Bool) {
//        standardEmojiStackView.isHidden = !isShowing
//    }
//    
//    private func setEmojiCountStackView(emojis: [EmojiData]) {
//        for emoji in emojis {
//            let emojiView = EmojiCountButton()
//            emojiView.setInitEmoji(emoji: emoji)
//            emojiCountStackView.addArrangedSubview(emojiView)
//        }
//    }
//    
//    private func setStandardEmojiStackView() {
//        Emojis.allEmojis.enumerated().forEach { index, emoji in
//            let button = StandardEmojiButton()
//            button.setEmoji(emoji: emoji)
//            button.tag = index
//            standardEmojiStackView.addArrangedSubview(button)
//            bindButton(button)
//        }
//    }
//    
//    private func bindButton(_ button: StandardEmojiButton) {
//    }
//}
