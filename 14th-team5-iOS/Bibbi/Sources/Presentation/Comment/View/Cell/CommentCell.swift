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
import RxCocoa
import SnapKit
import Then

final public class CommentCell: BaseTableViewCell<CommentCellReactor> {
    
    // MARK: - Views
    public let commentEqualizerView: BBEqualizerView = BBEqualizerView(state: .inital)
    
    private let profileBackground: UIView = UIView()
    private let profilePlaceholder: UILabel = BBLabel(.head2Bold, textAlignment: .center)
    private let profileImage: UIImageView = UIImageView()
    private let profileButton: UIButton = UIButton()
    
    private let labelStack: UIStackView = UIStackView()
    private let nameLabel: BBLabel = BBLabel(.body2Bold, textColor: .gray100)
    private let createdAtLabel: BBLabel = BBLabel(.body2Regular, textColor: .gray500)
    private let voicePlayButton: UIButton = UIButton(type: .custom)
    private let voicePlayContainerView: UIView = UIView()
    private let voiceCotainerView: UIView = UIView()
    private let commentLabel: BBLabel = BBLabel(.body1Regular, textColor: .gray100)
    private var hasErrorOccurred = false
    
    // MARK: - Properties
    
    static var id: String = "CommentCell"
    
    
    // MARK: - Helpers
    public override func prepareForReuse() {
        super.prepareForReuse()
        commentEqualizerView.invalidateEqaulizerLayout()
        commentEqualizerView.resetEqualizerLayout()
        
        nameLabel.text = ""
        createdAtLabel.text = ""
        profileImage.image = nil
        hasErrorOccurred = false
        disposeBag = DisposeBag()
    }
    
    public override func bind(reactor: CommentCellReactor) {
        super.bind(reactor: reactor)
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    private func bindInput(reactor: CommentCellReactor) {
        
        Observable.just(())
            .map { Reactor.Action.prepareForReuse }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
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
        
        voicePlayContainerView.rx.tap
            .throttle(.milliseconds(300), scheduler: RxScheduler.main)
            .do { _ in Haptic.impact(style: .medium) }
            .withLatestFrom(reactor.state.map { $0.audioId })
            .map { Reactor.Action.didTapPlayButton($0) }
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
        .filter { $0.0 == "VOICE"}
        .map { $0.1 }
        .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
        .requestAudioFileDecibels { $0 }
        .observe(on: RxScheduler.main)
        .distinctUntilChanged()
        .catchError(with: self) {
            guard !$0.hasErrorOccurred else { return .empty() }
            $0.hasErrorOccurred = true
            $0.showErrorToast($1.localizedDescription)
            return .empty()
        }
        .bind(to: commentEqualizerView.rx.equalizerLevels)
        .disposed(by: disposeBag)
        
        Observable.combineLatest(
            reactor.pulse(\.$equalizerState),
            reactor.state.map { $0.comment.commentType }.distinctUntilChanged(),
            reactor.state.map { $0.comment.commentId }.distinctUntilChanged()
        )
        .filter { $0.0 == .inital && $0.1 == "VOICE" }
        .map { $0.2 }
        .requestAudioCurrentTime { $0 }
        .catchError(with: self) { _, _ in
            return .just("0:00")
        }
        .observe(on: RxScheduler.main)
        .bind(to: commentEqualizerView.timerLabel.rx.text)
        .disposed(by: disposeBag)
        
        
        Observable.combineLatest(
            reactor.pulse(\.$equalizerState),
            reactor.state.map { $0.comment.commentType},
            reactor.state.map { $0.comment.commentId}
        )
        .filter { $0.0 == .play && $0.1 == "VOICE" }
        .map { $0.2 }
        .requestAudioElapsedTime { $0 }
        .distinctUntilChanged()
        .observe(on: RxScheduler.main)
        .catchError(with: self) { _,_ in
            return .just(1.0)
        }
        .bind(to: commentEqualizerView.rx.elapsedTime)
        .disposed(by: disposeBag)
        
        Observable.combineLatest(
            reactor.pulse(\.$equalizerState),
            reactor.pulse(\.$audioId)
        )
        .willChangedAudioTime { $0 }
        .observe(on: RxScheduler.main)
        .bind(with: self) { owner, timer in
            if timer == "0:00" {
                owner.reactor?.action.onNext(.didChangedInitalLayout)
                owner.commentEqualizerView.resetEqualizerLayout()
            }
            owner.commentEqualizerView.timerLabel.text = timer
        }
        .disposed(by: disposeBag)
        
        reactor.state.map { $0.equalizerState }
            .map { $0 == .play }
            .distinctUntilChanged()
            .bind(to: voicePlayButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$equalizerState)
            .skip(1)
            .observe(on: RxScheduler.main)
            .bind(to: commentEqualizerView.rx.state)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.comment.commentType }
            .bind(with: self) { owner, type in
                switch type {
                case "TEXT":
                    owner.commentLabel.snp.makeConstraints {
                        $0.top.equalTo(owner.labelStack.snp.bottom).offset(8)
                        $0.leading.equalTo(owner.labelStack.snp.leading)
                        $0.trailing.equalToSuperview().offset(-8)
                        $0.bottom.equalToSuperview().offset(-10)
                    }
                case "VOICE":
                    owner.voiceCotainerView.snp.makeConstraints {
                        $0.top.equalTo(owner.labelStack.snp.bottom).offset(8)
                        $0.left.equalTo(owner.labelStack)
                        $0.right.equalToSuperview().inset(20)
                        $0.bottom.equalToSuperview().offset(-16)
                    }
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
        
        Observable.combineLatest(
            reactor.state.map { $0.equalizerState }.distinctUntilChanged(),
            reactor.pulse(\.$audioId)
        )
        .filter { !$0.1.isEmpty }
        .observe(on: RxScheduler.asyncMain)
        .bind(with: self) { owner, response in
            let (state, audioId) = response

            guard let audioURL = BBDiskCacheStorage<String, URL>.read(forkey: audioId) else {
                owner.showErrorToast("오디오 파일을 찾을 수 없습니다")
                return
            }
            switch state {
            case .inital:
                BBRecorderManager.shared.stopPlayback()
            case .play:
                do {
                    try BBRecorderManager.shared.play(audioURL)
                } catch {
                    owner.reactor?.action.onNext(.didChangedInitalLayout)
                    owner.commentEqualizerView.resetEqualizerLayout()
                    owner.showErrorToast("재생에 실패했습니다")
                }
            default:
                break
            }
        }
        .disposed(by: disposeBag)
    }
    
    public override func setupUI() {
        super.setupUI()
        voicePlayContainerView.addSubview(voicePlayButton)
        voiceCotainerView.addSubviews(commentEqualizerView, voicePlayContainerView)
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
            $0.height.equalTo(40)
            $0.centerY.equalToSuperview()
            $0.left.equalTo(voicePlayButton.snp.right).offset(16)
            $0.right.equalToSuperview().inset(16)
        }
        
        voicePlayContainerView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().inset(2)
            $0.size.height.equalTo(40)
            $0.centerY.equalToSuperview()
        }
        
        voicePlayButton.snp.makeConstraints {
            $0.size.equalTo(11)
            $0.center.equalToSuperview()
        }
    }
    
    public override func setupAttributes() {
        super.setupAttributes()
        
        contentView.do {
            $0.backgroundColor = UIColor.bibbiBlack
        }
        
        voiceCotainerView.do {
            $0.backgroundColor = .clear
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


private extension CommentCell {
    func showErrorToast(_ descrption: String) {
        let config = BBToastConfiguration(direction: .top(yOffset: 75))
        let viewConfig = BBToastViewConfiguration(minWidth: 100)
        BBToast.default(
            image: DesignSystemAsset.warning.image,
            title: descrption,
            viewConfig: viewConfig,
            config: config
        ).show()
    }
}
