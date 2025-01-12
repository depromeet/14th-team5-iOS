//
//  ManagementTableView.swift
//  App
//
//  Created by 김건우 on 9/1/24.
//

import Core
import UIKit

import SnapKit
import Then

public final class ManagementTableView: BaseTableView<ManagementTableReactor> {
    
    // MARK: - Views
    
    private let basicRefreshControl: UIRefreshControl = UIRefreshControl()
    // TODO: - 리팩토링된 FetchFailure로 바꾸기
    private let fetchFailureView: BibbiFetchFailureView = BibbiFetchFailureView(type: .family)
    
    // MARK: - Properties
    
    public weak var control: ManagementTableDelegate?
    
    private lazy var progressHud: BBProgressHUD = {
        let config = BBProgressHUDConfiguration(attachedTo: self)
        let viewConfig = BBProgressHUDViewConfiguration(
            offsetFromCenterY: -100,
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
    
    public convenience init() {
        self.init(frame: .zero, style: .plain)
    }
    
    public override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        setupAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Helpers
    
    public override func setupUI() {
        super.setupUI()
        
        self.addSubview(fetchFailureView)
    }
    
    public override func setupAttributes() {
        super.setupAttributes()
        
        self.do {
            $0.separatorStyle = .none
            $0.estimatedRowHeight = UITableView.automaticDimension
            $0.backgroundColor = UIColor.clear
            
            $0.refreshControl = basicRefreshControl
            
            $0.register(FamilyMemberCell.self, forCellReuseIdentifier: FamilyMemberCell.id)
        }
        
        basicRefreshControl.do {
            $0.tintColor = UIColor.bibbiWhite
            $0.addTarget(self, action: #selector(didPullDownRefreshControl(_:event:)), for: .valueChanged)
        }
        
        fetchFailureView.do {
            $0.isHidden = true
        }
    }
    
    public override func setupAutoLayout() {
        super.setupAutoLayout()
        
        fetchFailureView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(70)
            $0.centerX.equalToSuperview()
        }
    }
    
}


// MARK: - Extensions

extension ManagementTableView {
    
    func hiddenTableProgressHud(hidden: Bool) {
        hidden ? progressHud.close() : progressHud.show()
    }
    
    func hiddenFetchFailureView(hidden: Bool) {
        fetchFailureView.isHidden = hidden
    }
    
    func endRefreshing() {
        basicRefreshControl.endRefreshing()
    }
    
}

extension ManagementTableView {
    
    @objc func didPullDownRefreshControl(_ refreshControl: UIRefreshControl, event: UIRefreshControl.Event) {
        control?.table?(refreshControl, didPullDownRefreshControl: event)
    }
    
}
