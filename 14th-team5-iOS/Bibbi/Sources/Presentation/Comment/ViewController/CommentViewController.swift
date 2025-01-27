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
    private let recorderManager: BBRecorderManager = BBRecorderManager()
    
    
    // MARK: - Views
    
    private let topBarView: CommentTopBarView = CommentTopBarView()
    private lazy var commentTableView: CommentTableView = makeCommentTableView()
    private lazy var textFieldView: CommentTextFieldView = makeCommentTextFieldView()
    
    
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
    }
    
    private func bindInput(reactor: CommentViewReactor) { 
        Observable<Void>.just(())
            .map { Reactor.Action.fetchComment }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        Observable<String>.merge(
            textFieldView.rx.didTapDoneButton,
            textFieldView.rx.didTapConfirmButton
        )
        .throttle(RxInterval._300milliseconds, scheduler: RxScheduler.main)
        .map { Reactor.Action.createComment($0) }
        .bind(to: reactor.action)
        .disposed(by: disposeBag)
        
        // TODO: - 코드 리팩토링하기
        commentTableView.rx.itemDeleted
            .withUnretained(self)
            .bind { $0.0.reactor?.action.onNext(.deleteComment($0.0.dataSource[$0.1].currentState.comment.commentId)) }
            .disposed(by: disposeBag)
        
        recorderManager.rx.requestMicrophonePermission
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, isPermission in
                guard isPermission else {
                    owner.showPermissionAlertController()
                    return
                }
            }
            .disposed(by: disposeBag)
        // TODO: - 테이블 등 다른 화면 터치 시 키보드 내리기
        
        
    }
    
    private func bindOutput(reactor: CommentViewReactor) {
        reactor.pulse(\.$commentDatasource)
            .bind(to: commentTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.hiddenTableProgressHud }
            .distinctUntilChanged()
            .bind(with: self) { $0.commentTableView.hiddenTableProgressHud(hidden: $1) }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.hiddenFetchFailureView }
            .distinctUntilChanged()
            .bind(with: self) {  $0.commentTableView.hiddenFetchFailureView(hidden: $1) }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.hiddenNoneCommentView }
            .distinctUntilChanged()
            .bind(with: self) { $0.commentTableView.hiddenNoneCommentView(hidden: $1) }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.enableConfirmButton }
            .distinctUntilChanged()
            .bind(with: self) { $0.textFieldView.enableConfirmButton(enable: $1) }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.enableCommentTextField }
            .distinctUntilChanged()
            .bind(with: self) { $0.textFieldView.enableCommentTextField(enable: $1) }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$text)
            .bind(with: self) { $0.textFieldView.assignText($1) }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$makeTextFieldFirstResponder)
            .bind(with: self) { owner, _ in owner.textFieldView.makeTextFieldFirstResponder() }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$scrollTableToLast)
            .filter { $0 }
            .bind(with: self) { owner, _ in owner.scrollCommentTableToLast() }
            .disposed(by: disposeBag)
        
        let keyboardWillShow = NotificationCenter.default.rx
            .notification(UIResponder.keyboardWillShowNotification)
            .flatMap {
                guard
                    let rect = $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
                else { return Observable<CGFloat>.just(.zero) }
                return Observable<CGFloat>.just(rect.height)
            }
        
        let keyboardWillHide = NotificationCenter.default.rx
            .notification(UIResponder.keyboardWillHideNotification)
            .flatMap { _ in Observable<CGFloat>.just(.zero) }
        
        keyboardWillShow
            .bind(with: self) { owner, height in
                let bottomInset = owner.view.safeAreaInsets.bottom
                let keyboardHeight = height - bottomInset
                
                // TODO: - 애니메이션 메서드로 빼기
                UIView.animate(withDuration: 1.0) {
                    owner.textFieldView.snp.updateConstraints {
                        $0.bottom.equalTo(owner.view.safeAreaLayoutGuide.snp.bottom).offset(-keyboardHeight)
                    }
                    owner.textFieldView.layoutIfNeeded()
                }
            }
            .disposed(by: disposeBag)
        
        keyboardWillHide
            .bind(with: self) { owner, height in
                // TODO: - 애니메이션 메서드로 빼기
                UIView.animate(withDuration: 1.0) {
                    owner.textFieldView.snp.updateConstraints {
                        $0.bottom.equalTo(owner.view.safeAreaLayoutGuide.snp.bottom).offset(0)
                    }
                    owner.textFieldView.layoutIfNeeded()
                }
            }
            .disposed(by: disposeBag)
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
    }
    
    public override func setupAttributes() {
        super.setupAttributes()
    }
}


// MARK: - Extensions

extension CommentViewController {
    
    private func makeCommentTableView() -> CommentTableView {
        CommentTableView(
            reactor: CommentTableReactor()
        )
    }

    private func makeCommentTextFieldView() -> CommentTextFieldView {
        CommentTextFieldView(
            reactor: CommentTextFieldReactor()
        )
    }
    
    private func prepareDatasource() -> RxDataSource {
        let dataSource = RxDataSource { dataSource, tableView, indexPath, reactor in
            let cell = tableView.dequeueReusableCell(
                withIdentifier: CommentCell.id
            ) as! CommentCell
            cell.reactor = reactor
            return cell
        }
        dataSource.canEditRowAtIndexPath = {
            let myMemberId = App.Repository.member.memberID.value
            let commentMemberId = $0[$1].currentState.comment.memberId
            return myMemberId == commentMemberId
        }
        return dataSource
    }
    
}


extension CommentViewController {
    
    private func scrollCommentTableToLast() {
        guard
            let count = reactor?.currentState.commentDatasource.first?.items.count
        else { return }
        let indexPath = IndexPath(item: count - 1, section: 0)
        commentTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    private func showPermissionAlertController() {
        let permissionAlertController = UIAlertController(title: "마이크 접근 권한 설정이 없습니다.", message: "마이크를 사용하려면 마이크에 접근할 수 있도록 허용되어 있어야 합니다.", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        let settingAction = UIAlertAction(title: "설정으로 이동하기", style: .default) { _ in
            UIApplication.shared.open(URLTypes.settings.originURL)
        }
        
        [cancelAction, settingAction].forEach(permissionAlertController.addAction(_:))
        present(permissionAlertController, animated: true)
    }
    
}
