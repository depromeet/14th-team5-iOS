//
//  PostCommentViewController.swift
//  App
//
//  Created by 김건우 on 1/18/24.
//

import Core
import DesignSystem
import UIKit

import RxCocoa
import RxDataSources
import RxSwift
import Then
import SnapKit

final public class PostCommentViewController: BaseViewController<PostCommentViewReactor> {
    // MARK: - Views
    private let navigationBarView: PostCommentTopBarView = PostCommentTopBarView()
    
    private let noCommentLabel: NoCommentLabel = NoCommentLabel()
    private let commentTableView: UITableView = UITableView()
    
    private let commentTextField: UITextField = UITextField()
    private let textFieldContainerView: UIView = UIView()
    private let createCommentButton: UIButton = UIButton(type: .system)
    
    private let airplaneLottieView: AirplaneLottieView = AirplaneLottieView()
    private let fetchFailureView: FetchFailureView = FetchFailureView(type: .comment)
    
    // MARK: - Properties
    private lazy var dataSource: RxTableViewSectionedAnimatedDataSource<PostCommentSectionModel> = prepareDatasource()
    
    // MARK: - LifeCycles
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - Helpers
    public override func bind(reactor: PostCommentViewReactor) {
        super.bind(reactor: reactor)
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
        bindDatasource(reactor: reactor)
    }
    
    private func bindInput(reactor: PostCommentViewReactor) { 
        Observable<Void>.just(())
            .map { Reactor.Action.fetchPostComment }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        Observable.merge(
            commentTableView.rx.tap.asObservable(),
            noCommentLabel.rx.tap.asObservable()
        )
        .throttle(RxConst.throttleInterval, scheduler: Schedulers.main)
        .withUnretained(self)
        .subscribe {
            $0.0.commentTextField.resignFirstResponder()
        }
        .disposed(by: disposeBag)
        
        commentTextField.rx.text.orEmpty
            .skip(while: { $0.isEmpty })
            .map { Reactor.Action.inputComment($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        createCommentButton.rx.tap
            .throttle(RxConst.throttleInterval, scheduler: Schedulers.main)
            .withUnretained(self)
            .do(onNext: { _ in Haptic.impact(style: .rigid) })
            .map { Reactor.Action.createPostComment($0.0.commentTextField.text) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        commentTextField.rx.controlEvent(.editingDidEndOnExit)
            .throttle(RxConst.throttleInterval, scheduler: Schedulers.main)
            .withUnretained(self)
            .map { Reactor.Action.createPostComment($0.0.commentTextField.text) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        let keyboardWillShow = NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
            .flatMap { notification in
                guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
                    return Observable<CGFloat>.just(0)
                }
                return Observable<CGFloat>.just(value.cgRectValue.height)
            }
        
        keyboardWillShow
            .map { Reactor.Action.keyboardWillShow($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        let keyboardWillHide = NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
            .flatMap { notification in
                return Observable<CGFloat>.just(0)
            }
        
        keyboardWillHide
            .map { _ in Reactor.Action.keyboardWillHide }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: PostCommentViewReactor) {
        reactor.pulse(\.$commentCount)
            .map { $0 != 0 }
            .bind(to: noCommentLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.inputComment }
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe {
                $0.0.commentTextField.text = $0.1
                if let button = $0.0.commentTextField.rightView as? UIButton {
                    button.isEnabled = !$0.1.isEmpty
                }
            }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$shouldPresentUploadCommentFailureTaostMessageView)
            .withUnretained(self)
            .subscribe {
                if $0.1 {
                    $0.0.makeErrorBibbiToastView(
                        duration: 0.8,
                        offset: 70,
                        direction: .down
                    )
                }
            }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$shouldPresentDeleteCommentCompleteToastMessageView)
            .withUnretained(self)
            .subscribe {
                if $0.1 {
                    $0.0.makeBibbiToastView(
                        text: "댓글이 삭제되었습니다",
                        image: DesignSystemAsset.warning.image,
                        offset: 70,
                        direction: .down
                    )
                }
            }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$shouldPresentDeleteCommentFailureToastMessageView)
            .withUnretained(self)
            .subscribe {
                if $0.1 {
                    $0.0.makeErrorBibbiToastView(
                        duration: 0.8,
                        offset: 70,
                        direction: .down
                    )
                }
            }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$shouldPresentCommentFetchFailureTaostMessageView)
            .filter { $0 }
            .withUnretained(self)
            .subscribe {
                $0.0.makeBibbiToastView(
                    text: "댓글을 불러오는데 실패했어요",
                    image: DesignSystemAsset.warning.image,
                    offset: 70,
                    direction: .down
                )
                $0.0.fetchFailureView.isHidden = false
            }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$shouldPresentEmptyCommentView)
            .bind(to: noCommentLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$shouldPresentPaperAirplaneLottieView)
            .bind(to: airplaneLottieView.rx.isHidden)
            .disposed(by: disposeBag)
        
        // FIX ME: - 주간 캘린더 화면으로 넘어갈 때, 햅틱 피드백이 발생되는 문제
        reactor.pulse(\.$shouldGenerateErrorHapticNotification)
            .filter { $0 }
            .subscribe(onNext: { _ in Haptic.notification(type: .error) })
            .disposed(by: disposeBag)
            
        reactor.pulse(\.$shouldClearCommentTextField)
            .withUnretained(self)
            .subscribe {
                if $0.1 {
                    $0.0.commentTextField.text = String.none
                }
            }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$shouldScrollToLast)
            .withUnretained(self)
            .subscribe {
                if $0.1 > 0 {
                    let indexPath = IndexPath(row: $0.1, section: 0)
                    self.commentTableView.scrollToRow(
                        at: indexPath,
                        at: .bottom,
                        animated: true
                    )
                }
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.tableViewBottomOffset }
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe { `self`, height in
                let safeAreaHeight = `self`.view.safeAreaInsets.bottom
                let keyboardHeight = height == .zero ? 0 : (-height + safeAreaHeight)
                UIView.animate(withDuration: 1.0) {
                    `self`.textFieldContainerView.snp.updateConstraints {
                        $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(keyboardHeight)
                    }
                    `self`.view.layoutIfNeeded()
                }
            }
            .disposed(by: disposeBag)
    }
    
    public override func setupUI() {
        super.setupUI()
        
        view.addSubviews(navigationBarView, commentTableView, textFieldContainerView)
        commentTableView.addSubviews(airplaneLottieView, noCommentLabel, fetchFailureView)
        textFieldContainerView.addSubviews(commentTextField)
    }
    
    public override func setupAutoLayout() {
        super.setupAutoLayout()
        
        navigationBarView.snp.makeConstraints {
            $0.height.equalTo(60)
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        noCommentLabel.snp.makeConstraints {
            $0.top.equalTo(navigationBarView.snp.bottom).offset(74)
            $0.bottom.equalTo(textFieldContainerView.snp.top).offset(-5)
            $0.horizontalEdges.equalToSuperview()
        }
        
        commentTableView.snp.makeConstraints {
            $0.top.equalTo(navigationBarView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
        }
        
        textFieldContainerView.snp.makeConstraints {
            $0.height.equalTo(46)
            $0.top.equalTo(commentTableView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(0)
        }
        
        airplaneLottieView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalToSuperview().offset(UIScreen.isPhoneSE ? 70 : 90)
        }
        
        fetchFailureView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(70)
            $0.centerX.equalToSuperview()
        }
        
        commentTextField.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(15)
        }
        
        commentTextField.becomeFirstResponder()
    }
    
    public override func setupAttributes() {
        super.setupAttributes()
        
        textFieldContainerView.do {
            $0.backgroundColor = UIColor.gray900
        }
        
        commentTableView.do {
            $0.estimatedRowHeight = 250
            $0.rowHeight = UITableView.automaticDimension
            $0.allowsSelection = false
            $0.separatorStyle = .none
            $0.backgroundColor = UIColor.bibbiBlack
            $0.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
            
            $0.register(CommentCell.self, forCellReuseIdentifier: CommentCell.id)
        }
        
        commentTextField.do {
            $0.textColor = UIColor.bibbiWhite
            $0.attributedPlaceholder = NSAttributedString(
                string: "댓글 달기...",
                attributes: [.foregroundColor: UIColor.gray300]
            )
            $0.backgroundColor = UIColor.clear
            $0.rightView = createCommentButton
            $0.rightViewMode = .always
            $0.returnKeyType = .done
        }
        
        createCommentButton.do {
            $0.isEnabled = false
            $0.setTitle("등록", for: .normal)
            $0.tintColor = UIColor.mainYellow
        }
        
        noCommentLabel.do {
            $0.isHidden = true
        }
        
        fetchFailureView.do {
            $0.isHidden = true
        }
    }
}

extension PostCommentViewController {
    private func prepareDatasource() -> RxTableViewSectionedAnimatedDataSource<PostCommentSectionModel> {
        return RxTableViewSectionedAnimatedDataSource { dataSource, tableView, indexPath, reactor in
            let cell = tableView.dequeueReusableCell(withIdentifier: CommentCell.id) as! CommentCell
            cell.reactor = reactor
            return cell
        }
    }
    
    private func bindDatasource(reactor: PostCommentViewReactor) {
        dataSource.canEditRowAtIndexPath = { dataSource, indexPath in
            let myMemberId = App.Repository.member.memberID.value
            let cellMemberId = dataSource[indexPath].currentState.memberId
            return myMemberId == cellMemberId
        }
        
        reactor.state.map { $0.displayComment }
            .distinctUntilChanged()
            .bind(to: commentTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        commentTableView.rx.itemDeleted
            .withUnretained(self)
            .map {
                let commentId = $0.0.dataSource[$0.1].currentState.commentId
                return Reactor.Action.deletePostComment(commentId)
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}
