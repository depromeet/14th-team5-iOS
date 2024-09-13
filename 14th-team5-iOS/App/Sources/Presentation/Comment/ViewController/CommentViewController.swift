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
    
    private let topBarView: CommentTopBarView = CommentTopBarView()
    private let commentTableView: CommentTableView = CommentTableView()
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
        
        commentTableView.rx.itemDeleted
            .withUnretained(self)
            .bind { $0.0.reactor?.action.onNext(.deleteComment($0.0.dataSource[$0.1].currentState.comment.commentId)) }
            .disposed(by: disposeBag)
        
        // TODO: - 테이블 등 다른 화면 터치 시 키보드 내리기
        
    }
    
    private func bindOutput(reactor: CommentViewReactor) {
        reactor.pulse(\.$commentDatasource)
            .bind(to: commentTableView.rx.items(dataSource: dataSource))
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
        
        // TODO: - App.Repository 제거하기
        dataSource.canEditRowAtIndexPath = {
            let myMemberId = App.Repository.member.memberID.value
            let commentMemberId = $0[$1].currentState.comment.memberId
            return myMemberId == commentMemberId
        }
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
            let cell = tableView.dequeueReusableCell(
                withIdentifier: CommentCell.id
            ) as! CommentCell
            cell.reactor = reactor
            return cell
        }
    }
    
}
