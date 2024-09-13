//
//  CommentTableView.swift
//  App
//
//  Created by 김건우 on 9/12/24.
//

import Core
import UIKit

import SnapKit
import Then

public final class CommentTableView: BaseTableView<CommentTableReactor> {
    
    // MARK: - Views
    
    private let basicRefreshControl: UIRefreshControl = UIRefreshControl()
    // TODO: - 리팩토링된 FetchFailureView로 바꾸기
    private let fetchFailureView: BibbiFetchFailureView = BibbiFetchFailureView(type: .comment)
    private let noneCommentView: NoneCommentView = NoneCommentView()
    
    
    // MARK: - Properties
    
    private lazy var progressHud: BBProgressHUD = {
        let config = BBProgressHUDConfiguration(attachedTo: self)
        let viewConfig = BBProgressHUDViewConfiguration(
            offsetFromCenterY: -50,
            backgroundColor: UIColor.clear
        )
        let hud = BBProgressHUD.lottie(
            .airplane,
            title: "열심히 불러오는 중..",
            titleFontStyle: .body1Regular,
            titleColor: .gray400,
            viewConfig: viewConfig,
            config: config
        )
        return hud
    }()
    
    
    // MARK: - Intializer
    
    public override init(
        frame: CGRect, 
        style: UITableView.Style
    ) {
        super.init(frame: .zero, style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Helpers
    
    public override func setupUI() {
        super.setupUI()
        
        addSubviews(noneCommentView, fetchFailureView)
    }
    
    public override func setupAutoLayout() {
        super.setupAutoLayout()
        
        self.do {
            $0.separatorStyle = .none
            $0.estimatedRowHeight = 250
            $0.rowHeight = UITableView.automaticDimension
            
            $0.allowsSelection = false
            
            $0.backgroundColor = UIColor.bibbiBlack
            $0.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
            
            $0.register(CommentCell.self, forCellReuseIdentifier: CommentCell.id)
        }
        
        fetchFailureView.do {
            $0.isHidden = true
        }
        
        noneCommentView.do {
            $0.isHidden = true
        }
    }

    public override func setupAttributes() {
        super.setupAttributes()
        
        noneCommentView.snp.makeConstraints {
            $0.top.equalTo(self.snp.top).offset(75)
            $0.bottom.equalTo(self.snp.bottom).offset(-5)
            $0.horizontalEdges.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        
        fetchFailureView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(70)
            $0.centerX.equalToSuperview()
        }
    }
    
}


// MARK: - Extensions

extension CommentTableView {
    
    func hiddenTableProgressHud(hidden: Bool) {
        hidden ? progressHud.close() : progressHud.show()
    }
    
    func hiddenFetchFailureView(hidden: Bool) {
        fetchFailureView.isHidden = hidden
    }
    
    func hiddenNoneCommentView(hidden: Bool) {
        noneCommentView.isHidden = hidden
    }
    
}
