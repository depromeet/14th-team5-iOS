//
//  CommentCell.swift
//  App
//
//  Created by 김건우 on 1/18/24.
//

import Core
import DesignSystem
import UIKit

import ReactorKit
import RxSwift
import SnapKit
import Then

final public class CommentCell: BaseTableViewCell<CommentCellReactor> {
    
    // MARK: - Views
    
    private let profileBackground: UIView = UIView()
    private let profilePlaceholder: UILabel = BBLabel(.head2Bold, textAlignment: .center)
    private let profileImage: UIImageView = UIImageView()
    private let profileButton: UIButton = UIButton()
    
    private let labelStack: UIStackView = UIStackView()
    private let nameLabel: BBLabel = BBLabel(.body2Bold, textColor: .gray100)
    private let createdAtLabel: BBLabel = BBLabel(.body2Regular, textColor: .gray500)
    private let commentEqualizerView: BBEqualizerView = BBEqualizerView(state: .inital)
    private let voicePlayButton: UIButton = UIButton(type: .custom)
    private let voiceCotainerView: UIView = UIView()
    private let commentLabel: BBLabel = BBLabel(.body1Regular, textColor: .gray100)
    private let playerManager: BBRecorderManager = BBRecorderManager()
    
    
    // MARK: - Properties
    
    static var id: String = "CommentCell"
    
    
    // MARK: - Helpers
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        
        nameLabel.text = ""
        createdAtLabel.text = ""
        profileImage.image = nil
        commentEqualizerView.resetEqualizerLayout()
        disposeBag = DisposeBag()
        print("✅프리페얼 리쥼 호출 되었습니다 \(disposeBag)✅")
    }
    
    public override func bind(reactor: CommentCellReactor) {
        super.bind(reactor: reactor)
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    private func bindInput(reactor: CommentCellReactor) { 
        Observable<Reactor.Action>.merge(
            Observable.just(Reactor.Action.fetchUserName),
            Observable.just(Reactor.Action.fetchProfileImage)
        )
        .bind(to: reactor.action)
        .disposed(by: disposeBag)
        
        profileButton.rx.tap
            .throttle(RxInterval._300milliseconds, scheduler: RxScheduler.main)
            .map { Reactor.Action.didTapProfileButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        voicePlayButton.rx.tap
            .throttle(.milliseconds(300), scheduler: RxScheduler.main)
            .do { _ in Haptic.impact(style: .medium) }
            .map { Reactor.Action.didTapPlayButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: CommentCellReactor) {
        let mamberName = reactor.state
            .compactMap { $0.memberName }
            .asDriver(onErrorJustReturn: "")
        
        mamberName
            .distinctUntilChanged()
            .drive(nameLabel.rx.text)
            .disposed(by: disposeBag)
        
        mamberName
            .distinctUntilChanged()
            .drive(profilePlaceholder.rx.firstLetterText)
            .disposed(by: disposeBag)
        
        reactor.state.compactMap { $0.profileImageUrl }
            .distinctUntilChanged()
            .compactMap { $0 }
            .bind(to: profileImage.rx.kfImage)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.comment.createdAt }
            .distinctUntilChanged()
            .map { $0.relativeFormatter() } // Reactor 안으로 집어넣기
            .bind(to: createdAtLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.comment.comment }
            .distinctUntilChanged()
            .bind(to: commentLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.comment.commentType }
            .distinctUntilChanged()
            .map { $0 == "TEXT" }
            .bind(to: voiceCotainerView.rx.isHidden)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.comment.commentType }
            .distinctUntilChanged()
            .map { $0 == "VOICE" }
            .bind(to: commentLabel.rx.isHidden)
            .disposed(by: disposeBag)

        
        Observable.combineLatest(
            reactor.pulse(\.$comment).map { $0.commentType},
            reactor.pulse(\.$comment).map { $0.commentId }
        )
        .debug("📁이퀄라이져 데시벨 방출 확인 입니다.📁")
        .filter { $0.0 == "VOICE"}
        .map { $0.1 }
        .distinctUntilChanged()
        .do(onDispose: { print("❌이퀄라이져 데시벨이 해체되었습니다❌")})
        .requestAudioFileDecibels { $0 }
        .bind(to: commentEqualizerView.rx.equalizerLevels)
        .disposed(by: disposeBag)
        
        
        //초기화 시 이퀄라이져 상태 값 -> inital
        //녹화 시 이퀄라이져 상태 값 -> play
        
        
        Observable.combineLatest(
            reactor.pulse(\.$equalizerState),
            reactor.state.map { $0.comment.commentType }.distinctUntilChanged(),
            reactor.state.map { $0.comment.commentId }.distinctUntilChanged()
        )
        .filter { $0.0 == .inital && $0.1 == "VOICE" }
        .map { $0.2 }
        .requestAudioCurrentTime { $0 }
        .observe(on: RxScheduler.main)
        .bind(to: commentEqualizerView.timerLabel.rx.text)
        .disposed(by: disposeBag)
        
        // 이퀄라이져 상태 값 -> intaial 로 변환은 잘됨
        // 단 play 에서 -> inital로 변환하는 가정에서 (willChangedAudioTime) 에서 Observable이 구독이 해체되어 있지 않아서 0:00 초로 반횐이 되버림
        
        
        Observable.combineLatest(
            reactor.pulse(\.$equalizerState),
            reactor.pulse(\.$audioId)
        )
//        .debug("🟢녹화 된 이퀄라이져 상태 값 입니다🟢")
        .willChangedAudioTime { $0 }
//        .debug("🎤녹화 된 시간 타임 입니다 🎤")
        .distinctUntilChanged()
        .observe(on: RxScheduler.main)
        .bind(to: commentEqualizerView.timerLabel.rx.text)
        .disposed(by: disposeBag)
        
        reactor.pulse(\.$equalizerState)
            .distinctUntilChanged()
            .map { $0 == .play }
            .bind(to: voicePlayButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$equalizerState)
            .skip(1)
            .bind(to: commentEqualizerView.rx.state)
            .disposed(by: disposeBag)
        
        Observable.combineLatest(
            reactor.state.map { $0.equalizerState }.distinctUntilChanged(),
            reactor.pulse(\.$audioId)
        )
        .skip(1)
        .filter { !$0.1.isEmpty }
        .observe(on: RxScheduler.asyncMain)
        .bind(with: self) { owner, response in
            let (state, audioId) = response
            switch state {
            case .inital:
                owner.playerManager.pauseAudioPlayback()
            case .play:
                owner.playerManager.playAudio(from: audioId)
            default:
                break
            }
        }
        .disposed(by: disposeBag)
            
    }
    
    public override func setupUI() {
        super.setupUI()
        voiceCotainerView.addSubviews(commentEqualizerView, voicePlayButton)
        profileBackground.addSubviews(profilePlaceholder, profileImage, profileButton)
        contentView.addSubviews(profileBackground, labelStack, commentLabel, voiceCotainerView)
        labelStack.addArrangedSubviews(nameLabel, createdAtLabel)
    }
    
    public override func setupAutoLayout() {
        super.setupUI()
        
        profileBackground.snp.makeConstraints {
            $0.size.equalTo(44)
            $0.top.equalTo(contentView.snp.top).offset(8)
            $0.leading.equalTo(contentView.snp.leading).offset(20)
        }
        
        profileButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        profilePlaceholder.snp.makeConstraints {
            $0.size.equalToSuperview()
        }
        
        profileImage.snp.makeConstraints {
            $0.size.equalToSuperview()
        }
        
        labelStack.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalTo(profileBackground.snp.trailing).offset(18)
        }
        
        commentEqualizerView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalTo(voicePlayButton.snp.right).offset(16)
            $0.right.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview()
        }
        
        voicePlayButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(14)
            $0.left.equalToSuperview().inset(19)
            $0.width.height.equalTo(11)
            $0.centerY.equalToSuperview()
        }
        
        voiceCotainerView.snp.makeConstraints {
            $0.top.equalTo(labelStack.snp.bottom).offset(8)
            $0.left.equalTo(labelStack)
            $0.right.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(16)
        }
        
        commentLabel.snp.makeConstraints {
            $0.top.equalTo(labelStack.snp.bottom).offset(8)
            $0.leading.equalTo(labelStack.snp.leading)
            $0.trailing.equalToSuperview().offset(-8)
            $0.bottom.equalToSuperview().offset(-10)
        }
    }
    
    public override func setupAttributes() {
        super.setupAttributes()
        
        contentView.do {
            $0.backgroundColor = UIColor.bibbiBlack
        }
        
        profileButton.do {
            $0.setTitle("", for: .normal)
            $0.backgroundColor = UIColor.clear
        }
        
        voiceCotainerView.do {
            $0.backgroundColor = .gray900
            $0.layer.cornerRadius = 20
            $0.clipsToBounds = true
        }
        
        voicePlayButton.do {
            $0.setBackgroundImage(DesignSystemAsset.pause.image, for: .selected)
            $0.setBackgroundImage(DesignSystemAsset.play.image, for: .normal)
            $0.setTitle("", for: .normal)
        }
        
        
        profileBackground.do {
            $0.layer.cornerRadius = 44 / 2
            $0.backgroundColor = UIColor.gray800
        }
        
        profileImage.do {
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = 44 / 2
            $0.contentMode = .scaleAspectFill
        }
        
        labelStack.do {
            $0.axis = .horizontal
            $0.spacing = 8
            $0.alignment = .fill
        }
        
        commentLabel.do {
            $0.numberOfLines = 0
        }
    }
}
