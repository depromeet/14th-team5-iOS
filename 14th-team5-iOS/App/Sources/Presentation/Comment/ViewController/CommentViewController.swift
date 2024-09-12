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

final public class CommentViewController: ReactorViewController<CommentViewReactor> {
    
    // MARK: - Typealias
    
    private typealias RxDataSource = RxTableViewSectionedAnimatedDataSource<CommentSectionModel>
    
    
    // MARK: - Views
    
    // topBarView
    private let topBarView: CommentTopBarView = CommentTopBarView()
    
//    private let noneCommentView: NoneCommentView = NoneCommentView()
    
    private let commentTableView: UITableView = UITableView()
  
    private lazy var textFieldView: CommentTextFieldView = makeCommentTextFieldView()
    
//    private let commentTextField: UITextField = UITextField()
//    private let textFieldContainerView: UIView = UIView()
//    private let createCommentButton: UIButton = UIButton(type: .system)
    
//    private let bibbiLottieView: AirplaneLottieView = AirplaneLottieView()
//    private let fetchFailureView: BibbiFetchFailureView = BibbiFetchFailureView(type: .comment)
    
    
    // MARK: - Properties
    
    private lazy var dataSource: RxDataSource = prepareDatasource()

    
    // MARK: - LifeCycles

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    
    // MARK: - Helpers
    
    public override func bind(reactor: CommentViewReactor) {
        super.bind(reactor: reactor)
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
        bindDatasource(reactor: reactor)
    }
    
    private func bindInput(reactor: CommentViewReactor) { 
        Observable<Void>.just(())
            .map { Reactor.Action.fetchComment }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
//        Observable.merge(
//            commentTableView.rx.tap.asObservable(),
//            noCommentLabel.rx.tap.asObservable()
//        )
//        .throttle(RxConst.milliseconds300Interval, scheduler: RxSchedulers.main)
//        .withUnretained(self)
//        .subscribe { $0.0.commentTextField.resignFirstResponder() }
//        .disposed(by: disposeBag)
        
//        commentTextField.rx.text.orEmpty
//            .skip(while: { $0.isEmpty })
//            .map { Reactor.Action.inputComment($0) }
//            .bind(to: reactor.action)
//            .disposed(by: disposeBag)
//        
//        createCommentButton.rx.tap
//            .throttle(RxConst.milliseconds300Interval, scheduler: RxSchedulers.main)
//            .withUnretained(self)
//            .do(onNext: { _ in Haptic.impact(style: .rigid) })
//            .map { Reactor.Action.createPostComment($0.0.commentTextField.text) }
//            .bind(to: reactor.action)
//            .disposed(by: disposeBag)
//        
//        commentTextField.rx.controlEvent(.editingDidEndOnExit)
//            .throttle(RxConst.milliseconds300Interval, scheduler: RxSchedulers.main)
//            .withUnretained(self)
//            .map { Reactor.Action.createPostComment($0.0.commentTextField.text) }
//            .bind(to: reactor.action)
//            .disposed(by: disposeBag)
        
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
    
    private func bindOutput(reactor: CommentViewReactor) {
//        reactor.pulse(\.$commentCount)
//            .map { $0 != 0 }
//            .bind(to: noneCommentView.rx.isHidden)
//            .disposed(by: disposeBag)
        
//        reactor.state.map { $0.inputComment }
//            .distinctUntilChanged()
//            .withUnretained(self)
//            .subscribe {
//                $0.0.commentTextField.text = $0.1
//                if let button = $0.0.commentTextField.rightView as? UIButton {
//                    button.isEnabled = !$0.1.isEmpty
//                }
//            }
//            .disposed(by: disposeBag)
//        
//        reactor.pulse(\.$shouldPresentUploadCommentFailureTaostMessageView)
//            .filter { $0 }
//            .withUnretained(self)
//            .subscribe {
//                $0.0.makeErrorBibbiToastView(
//                    duration: 0.8,
//                    offset: 70,
//                    direction: .down
//                )
//            }
//            .disposed(by: disposeBag)
//        
//        reactor.pulse(\.$shouldPresentDeleteCommentCompleteToastMessageView)
//            .filter { $0 }
//            .withUnretained(self)
//            .subscribe {
//                $0.0.makeBibbiToastView(
//                    text: "댓글이 삭제되었습니다",
//                    image: DesignSystemAsset.warning.image,
//                    offset: 70,
//                    direction: .down
//                )
//            }
//            .disposed(by: disposeBag)
//        
//        reactor.pulse(\.$shouldPresentDeleteCommentFailureToastMessageView)
//            .filter { $0 }
//            .withUnretained(self)
//            .subscribe {
//                $0.0.makeErrorBibbiToastView(
//                    duration: 0.8,
//                    offset: 70,
//                    direction: .down
//                )
//            }
//            .disposed(by: disposeBag)
        
//        reactor.pulse(\.$shouldPresentCommentFetchFailureTaostMessageView)
//            .filter { $0 }
//            .delay(RxConst.milliseconds100Interval, scheduler: RxSchedulers.main)
//            .withUnretained(self)
//            .subscribe {
//                $0.0.makeBibbiToastView(
//                    text: "댓글을 불러오는데 실패했어요",
//                    image: DesignSystemAsset.warning.image,
//                    offset: 70,
//                    direction: .down
//                )
//                $0.0.fetchFailureView.isHidden = false
//                $0.0.textFieldView.isUserInteractionEnabled = false
//                $0.0.commentTextField.rightView?.isUserInteractionEnabled = false
//            }
//            .disposed(by: disposeBag)
        
//        reactor.pulse(\.$shouldPresentEmptyCommentView)
//            .bind(to: noneCommentView.rx.isHidden)
//            .disposed(by: disposeBag)
        
//        reactor.pulse(\.$shouldPresentPaperAirplaneLottieView)
//            .bind(to: bibbiLottieView.rx.isHidden)
//            .disposed(by: disposeBag)
        
//        reactor.pulse(\.$shouldDismiss)
//            .filter { $0 }
//            .bind(with: self, onNext: { owner, _ in
//                owner.dismiss(animated: true)
//            })
//            .disposed(by: disposeBag)
        
//        reactor.pulse(\.$shouldGenerateErrorHapticNotification)
//            .filter { $0 }
//            .subscribe(onNext: { _ in Haptic.notification(type: .error) })
//            .disposed(by: disposeBag)
        
        reactor.state.map { $0.enableCommentTextField }
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe {
//                if let button = $0.0.commentTextField.rightView as? UIButton {
//                    button.isEnabled = $0.1
//                }
            }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$becomeFirstResponder)
            .filter { $0 }
            .withUnretained(self)
            .subscribe { /*$0.0.commentTextField.becomeFirstResponder()*/ }
            .disposed(by: disposeBag)
            
        reactor.pulse(\.$shouldClearCommentTextField)
            .filter { $0 }
            .withUnretained(self)
            .subscribe { /*$0.0.commentTextField.text = String.none*/ }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$shouldScrollToLast)
            .filter { $0 > 0 }
            .withUnretained(self)
            .subscribe {
                let indexPath = IndexPath(row: $0.1, section: 0)
                $0.0.commentTableView.scrollToRow(
                    at: indexPath,
                    at: .bottom,
                    animated: true
                )
            }
            .disposed(by: disposeBag)
//        
//        reactor.state.map { $0.tableViewBottomOffset }
//            .distinctUntilChanged()
//            .withUnretained(self)
//            .subscribe { `self`, height in
//                let safeAreaHeight = `self`.view.safeAreaInsets.bottom
//                let keyboardHeight = height == .zero ? 0 : (-height + safeAreaHeight)
//                UIView.animate(withDuration: 1.0) {
//                    `self`.textFieldContainerView.snp.updateConstraints {
//                        $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(keyboardHeight)
//                    }
//                    `self`.view.layoutIfNeeded()
//                }
//            }
//            .disposed(by: disposeBag)
    }
    
    public override func setupUI() {
        super.setupUI()
        view.addSubviews(topBarView, commentTableView, textFieldView)
    }
    
    public override func setupAutoLayout() {
        super.setupAutoLayout()
        
        topBarView.snp.makeConstraints {
            $0.height.equalTo(60)
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
//        noneCommentView.snp.makeConstraints {
//            $0.top.equalTo(topBarView.snp.bottom).offset(74)
//            $0.bottom.equalTo(textFieldView.snp.top).offset(-5)
//            $0.horizontalEdges.equalToSuperview()
//        }
        
        commentTableView.snp.makeConstraints {
            $0.top.equalTo(topBarView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
        }
        
        textFieldView.snp.makeConstraints {
            $0.height.equalTo(46)
            $0.top.equalTo(commentTableView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(0)
        }
        
//        bibbiLottieView.snp.makeConstraints {
//            $0.centerX.equalToSuperview()
//            $0.horizontalEdges.equalToSuperview()
//            $0.top.equalToSuperview().offset(UIScreen.isPhoneSE ? 100 : 140)
//        }
        
//        fetchFailureView.snp.makeConstraints {
//            $0.top.equalToSuperview().offset(70)
//            $0.centerX.equalToSuperview()
//        }
        
//        commentTextField.snp.makeConstraints {
//            $0.verticalEdges.equalToSuperview()
//            $0.horizontalEdges.equalToSuperview().inset(15)
//        }
    }
    
    public override func setupAttributes() {
        super.setupAttributes()
        
//        textFieldContainerView.do {
//            $0.backgroundColor = UIColor.gray900
//        }
        
//        commentTableView.do {
//            $0.estimatedRowHeight = 250
//            $0.rowHeight = UITableView.automaticDimension
//            $0.allowsSelection = false
//            $0.separatorStyle = .none
//            $0.backgroundColor = UIColor.bibbiBlack
//            $0.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
//            
//            $0.register(CommentCell.self, forCellReuseIdentifier: CommentCell.id)
//        }
        
//        commentTextField.do {
//            $0.textColor = UIColor.bibbiWhite
//            $0.attributedPlaceholder = NSAttributedString(
//                string: "댓글 달기...",
//                attributes: [.foregroundColor: UIColor.gray300]
//            )
//            $0.backgroundColor = UIColor.clear
//            $0.rightView = createCommentButton
//            $0.rightViewMode = .always
//            $0.returnKeyType = .done
//        }
//        
//        createCommentButton.do {
//            $0.isEnabled = false
//            $0.setTitle("등록", for: .normal)
//            $0.tintColor = UIColor.mainYellow
//        }
//
//        noneCommentView.do {
//            $0.isHidden = true
//        }
//        
//        fetchFailureView.do {
//            $0.isHidden = true
//        }
    }
}


// MARK: - Extensions

extension CommentViewController {
    
    private func makeCommentTextFieldView() -> CommentTextFieldView {
        CommentTextFieldView(
            reactor: CommentTextFieldReactor()
        )
    }
    
}


extension CommentViewController {
    
    private func prepareDatasource() -> RxDataSource {
        return RxDataSource { dataSource, tableView, indexPath, reactor in
            let cell = tableView.dequeueReusableCell(withIdentifier: CommentCell.id) as! CommentCell
            cell.reactor = reactor
            return cell
        }
    }
    
    private func bindDatasource(reactor: CommentViewReactor) {
        // attributes
        dataSource.canEditRowAtIndexPath = { dataSource, indexPath in
            let myMemberId = App.Repository.member.memberID.value
            let cellMemberId = dataSource[indexPath].currentState.comment.memberId
            return myMemberId == cellMemberId
        }
        
        
        // binding out
        reactor.state.map { $0.displayComment }
            .distinctUntilChanged()
            .bind(to: commentTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        
        // binding input
        commentTableView.rx.itemDeleted
            .withUnretained(self)
            .map {
                let commentId = $0.0.dataSource[$0.1].currentState.comment.commentId
                return Reactor.Action.deleteComment(commentId)
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
}
