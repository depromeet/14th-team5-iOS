import UIKit
import Core
import DesignSystem
import Domain

import ReactorKit
import RxCocoa
import RxDataSources
import RxSwift
import SnapKit
import Then

final class FamilyEntranceViewController: BaseViewController<FamilyEntranceReactor> {
    private let profileStackView = UIStackView()
    private let familyCountLabel = BBLabel(.body1Regular, textColor: .gray300)
    
    private let titleLabel = BBLabel(.head1, textColor: .gray100)
    private let captionLabel = BBLabel(.body1Regular, textColor: .gray300)
    
    private let showHomeButton = BBButton()
    private let showCodeButton = BBButton()
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func setupUI() {
        super.setupUI()
        
        view.addSubviews(profileStackView, familyCountLabel, titleLabel,
                         captionLabel, showHomeButton, showCodeButton)
    }
    
    override func setupAttributes() {
        super.setupAttributes()
        
        profileStackView.do {
            $0.axis = .horizontal
            $0.distribution = .fillEqually
            $0.spacing = -40
        }
        
        titleLabel.do {
            $0.text = "이미 가입된 가족이 있어요"
        }
        
        captionLabel.do {
            $0.text = "하나의 가족에만 소속될 수 있어요."
        }
        
        showHomeButton.do {
            $0.setTitle("홈으로 돌아가기", for: .normal)
            $0.backgroundColor = .mainYellow
            $0.layer.cornerRadius = 28
            $0.setTitleColor(.bibbiBlack, for: .normal)
            $0.setTitleFontStyle(.body1Bold)
        }

        showCodeButton.do {
            $0.setTitle("그룹 탈퇴 후 초대링크로 입장하기", for: .normal)
            $0.backgroundColor = .mainYellow
            $0.layer.cornerRadius = 28
            $0.setTitleColor(.bibbiBlack, for: .normal)
            $0.setTitleFontStyle(.body1Bold)
        }
    }
    
    override func setupAutoLayout() {
        super.setupAutoLayout()
        
        profileStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(100)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(80)
        }
        
        familyCountLabel.snp.makeConstraints {
            $0.top.equalTo(profileStackView.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }
     
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(familyCountLabel.snp.bottom).offset(32)
            $0.centerX.equalToSuperview()
        }
        
        captionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }
        
        showHomeButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(12)
            $0.bottom.equalTo(showCodeButton.snp.top).offset(-22)
            $0.height.equalTo(56)
        }
        
        showCodeButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(12)
            $0.height.equalTo(56)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-17)
        }
    }
    
    override func bind(reactor: FamilyEntranceReactor) {
        super.bind(reactor: reactor)
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
}

extension FamilyEntranceViewController {
    private func bindInput(reactor: FamilyEntranceReactor) {
        Observable.just(())
            .map { Reactor.Action.loadFamily }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        showHomeButton.rx.tap
            .throttle(RxConst.milliseconds300Interval, scheduler: MainScheduler.instance)
            .map { Reactor.Action.showHome }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        showCodeButton.rx.tap
            .throttle(RxConst.milliseconds300Interval, scheduler: MainScheduler.instance)
            .map { Reactor.Action.joinFamily }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: FamilyEntranceReactor) {
        reactor.state
            .compactMap { $0.profiles }
            .distinctUntilChanged()
            .observe(on: RxSchedulers.main)
            .withUnretained(self)
            .bind(onNext: { $0.0.setProfileStackView(profiles: $0.1) })
            .disposed(by: disposeBag)
    }
}

extension FamilyEntranceViewController {
    private func updateProfileStackViewWidth() {
        let profileWidth: CGFloat = 80
        let profileSpacing: CGFloat = -40
        let itemCount = profileStackView.arrangedSubviews.count
        
        let totalWidth = profileWidth * CGFloat(itemCount) + profileSpacing * CGFloat(itemCount - 1)
        
        profileStackView.snp.remakeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(100)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(80)
            $0.width.equalTo(totalWidth)
        }
    }
    
    private func setProfileStackView(profiles: [FamilyMemberProfileEntity]) {
        profileStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let displayProfiles = profiles.prefix(3)
        
        displayProfiles.enumerated().forEach { index, profile in
            let profileView: UIImageView
            if index == 2, profiles.count > 3 {
                profileView = createProfileImageView(with: nil, name: "+\(profiles.count - 2)")
            } else {
                profileView = createProfileImageView(with: profile.profileImageURL, name: profile.name)
            }
            
            profileStackView.addArrangedSubview(profileView)
        }
        
        updateProfileStackViewWidth()
    }

    private func createProfileImageView(with url: String?, name: String) -> UIImageView {
        let imageView = UIImageView(frame: .init(x: 0, y: 0, width: 80, height: 80)).then {
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 40
            $0.layer.borderWidth = 6
            $0.layer.borderColor = DesignSystemColors.Color.bibbiBlack.cgColor
            
            if let urlString = url, let imageUrl = URL(string: urlString) {
                $0.kf.setImage(with: imageUrl)
            } else {
                $0.backgroundColor = .gray800
                addLabeltoImage(to: $0, withText: name)
            }
        }
        return imageView
    }
    
    private func addLabeltoImage(to view: UIImageView, withText text: String) {
        let label = BBLabel(.head2Bold, textAlignment: .center, textColor: .gray200)
        label.text = text
        
        view.addSubview(label)
        label.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
