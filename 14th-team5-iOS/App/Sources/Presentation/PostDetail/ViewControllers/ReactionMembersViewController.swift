//
//  ReactionMembersViewController.swift
//  App
//
//  Created by 마경미 on 06.01.24.
//

import UIKit
import Core
import DesignSystem

import RxSwift
import RxDataSources

final class ReactionMembersViewController: BaseViewController<ReactionMemberViewReactor> {
    private let grabber: UIView = UIView()
    
    private let reactionImageView: UIImageView = UIImageView()
    private let reactionBadgeView: UIImageView = UIImageView()
    private let reactionLabel: UILabel = BBLabel(.body1Bold)
    private let memberTableView: UITableView = UITableView()
    private let closeButton: UIButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func bind(reactor: ReactionMemberViewReactor) {
        Observable.just(())
            .take(1)
            .map { Reactor.Action.makeDataSource }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.emojiData }
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .bind(onNext: {
                if let url = URL(string: $0.1.realEmojiImageURL) {
                    $0.0.reactionImageView.kf.setImage(with: url)
                } else {
                    $0.0.reactionImageView.image = $0.1.emojiType.emojiImage
                }
                $0.0.reactionBadgeView.image = $0.1.emojiType.emojiBadgeImage
                $0.0.reactionLabel.text = "총 \($0.1.memberIds.count)명이 반응을 남겼어요"
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.memberDataSource }
            .observe(on: MainScheduler.instance)
            .bind(to: memberTableView.rx.items(dataSource: createDataSource()))
            .disposed(by: disposeBag)
        
        closeButton.rx.tap
            .withUnretained(self)
            .throttle(RxConst.milliseconds300Interval, scheduler: MainScheduler.instance)
            .bind(onNext: { $0.0.dismiss(animated: true) })
            .disposed(by: disposeBag)
    }
    
    override func setupUI() {
        super.setupUI()
        
        view.addSubviews(grabber, reactionImageView, reactionBadgeView, reactionLabel,
            memberTableView, closeButton)
    }
    
    override func setupAutoLayout() {
        super.setupAutoLayout()
        
        grabber.snp.makeConstraints {
            $0.width.equalTo(36)
            $0.height.equalTo(5.08)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(6)
        }
        
        reactionImageView.snp.makeConstraints {
            $0.size.equalTo(66)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(32)
        }
        
        reactionBadgeView.snp.makeConstraints {
            $0.size.equalTo(30)
            $0.trailing.bottom.equalTo(reactionImageView)
        }
        
        reactionLabel.snp.makeConstraints {
            $0.top.equalTo(reactionImageView.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(25)
        }
        
        memberTableView.snp.makeConstraints {
            $0.top.equalTo(reactionLabel.snp.bottom).offset(16)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        closeButton.snp.makeConstraints {
            $0.top.equalTo(memberTableView.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(12)
            $0.height.equalTo(56)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(6)
        }
    }
    
    override func setupAttributes() {
        super.setupAttributes()
        
        grabber.do {
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = 5.08 / 2.0
            $0.backgroundColor = UIColor.gray500
        }
        
        reactionImageView.do {
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 33
            $0.contentMode = .scaleAspectFill
            $0.layer.borderWidth = 4.5
            $0.layer.borderColor = DesignSystemAsset.gray600.color.cgColor
        }
        
        reactionBadgeView.do {
            $0.layer.cornerRadius = 15
            $0.contentMode = .scaleAspectFill
        }

        memberTableView.do {
            $0.delegate = self
            $0.separatorStyle = .none
            $0.allowsSelection = false
            $0.backgroundColor = UIColor.clear
            $0.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
            $0.register(FamilyMemberCell.self, forCellReuseIdentifier: FamilyMemberCell.id)
        }
        
        closeButton.do {
            $0.layer.cornerRadius = 28
            $0.backgroundColor = .mainYellow
            $0.titleLabel?.font = DesignSystemFontFamily.Pretendard.semiBold.font(size: 16)
            $0.setTitle("닫기", for: .normal)
            $0.setTitleColor(.black, for: .normal)
        }
    }
}

extension ReactionMembersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

extension ReactionMembersViewController {
    private func createDataSource() -> RxTableViewSectionedReloadDataSource<FamilyMemberSectionModel> {
        return RxTableViewSectionedReloadDataSource<FamilyMemberSectionModel> { datasource, tableView, indexPath, reactor in
            let cell = tableView.dequeueReusableCell(withIdentifier: FamilyMemberCell.id, for: indexPath) as! FamilyMemberCell
            cell.reactor = reactor
            return cell
        }
    }
}
