//
//  CalendarFeedViewController.swift
//  App
//
//  Created by 김건우 on 12/8/23.
//

import UIKit

import Core
import FSCalendar
import Kingfisher
import ReactorKit
import RxCocoa
import RxSwift
import RxDataSources
import SnapKit
import Then


public final class CalendarFeedViewController: BaseViewController<CalendarFeedViewReactor> {
    // MARK: - Views
    private let imageBlurView: UIImageView = UIImageView()
    
    private let navigationBarView: UIView = UIView()
    private let backButton: UIButton = UIButton(type: .system)
    private let navigationTitle: UILabel = UILabel()
    
    private let calendarView: FSCalendar = FSCalendar()
    private let feedDetailView: UIView = UIView()
    
    private var feedDetailViewController: FeedDetailViewController = FeedDetailViewController(reacter: FeedDetailReactor())
    
    // MARK: - Lifecycles
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesBackButton = true
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - Helpers
    public override func setupUI() {
        super.setupUI()
        view.addSubview(imageBlurView)
        imageBlurView.addSubviews(
            navigationBarView, calendarView, feedDetailView
        )
        navigationBarView.addSubviews(
            backButton, navigationTitle
        )
        
        embedFeedViewController()
    }
    
    public override func setupAutoLayout() {
        super.setupAutoLayout()
        imageBlurView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        navigationBarView.snp.makeConstraints {
            $0.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(40)
        }
        
        backButton.snp.makeConstraints {
            $0.leading.equalTo(navigationBarView.snp.leading).offset(16.0)
            $0.centerY.equalTo(navigationBarView.snp.centerY)
        }
        
        navigationTitle.snp.makeConstraints {
            $0.center.equalTo(navigationBarView.snp.center)
        }
        
        calendarView.snp.makeConstraints {
            $0.top.equalTo(navigationBarView.snp.bottom)
            $0.leading.trailing.equalTo(imageBlurView)
            $0.height.equalTo(CalendarVC.AutoLayout.calendarHeightValue)
        }
    }
    
    public override func setupAttributes() {
        super.setupAttributes()
        imageBlurView.do {
            $0.kf.setImage(with: URL(string: "https://cdn.pixabay.com/photo/2023/12/04/16/12/berlin-8429780_1280.jpg"))
            $0.clipsToBounds = true
            $0.contentMode = .scaleAspectFill
            $0.isUserInteractionEnabled = true
        }
        
        calendarView.do {
            $0.headerHeight = 0.0
            $0.weekdayHeight = 0.0
            
            $0.today = nil
            $0.scope = .week
            $0.allowsMultipleSelection = false
            
            $0.appearance.selectionColor = UIColor.clear
            
            $0.appearance.titleFont = UIFont.boldSystemFont(ofSize: CalendarVC.Attribute.calendarTitleFontSize)
            $0.appearance.titleDefaultColor = UIColor.white
            $0.appearance.titleSelectionColor = UIColor.white
            
            $0.backgroundColor = UIColor.clear
            $0.register(ImageCalendarCell.self, forCellReuseIdentifier: ImageCalendarCell.id)
            $0.register(PlaceholderCalendarCell.self, forCellReuseIdentifier: PlaceholderCalendarCell.id)
        }
        
        navigationBarView.do {
            $0.backgroundColor = UIColor.clear
        }
        
        backButton.do {
            let colorConfig = UIImage.SymbolConfiguration(paletteColors: [UIColor.white])
            let weightConfig = UIImage.SymbolConfiguration(weight: .bold)
            
            let image = UIImage(
                systemName: "chevron.left",
                withConfiguration: colorConfig.applying(weightConfig)
            )
            $0.setImage(image, for: .normal)
            $0.contentMode = .scaleAspectFit
        }
        
        navigationTitle.do {
            $0.text = "2023년 12월"
            $0.textColor = UIColor.white
            $0.font = UIFont.boldSystemFont(ofSize: 18.0)
        }
        
        calendarView.delegate = self
        calendarView.dataSource = self
        
        setupBlurEffect()
        setupNavigationTitle(calendarView.currentPage)
    }

    public override func bind(reactor: CalendarFeedViewReactor) { 
        super.bind(reactor: reactor)
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    private func bindInput(reactor: CalendarFeedViewReactor) {
        backButton.rx.tap
            .withUnretained(self)
            .subscribe {
                $0.0.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        calendarView.rx.didSelect
            .map { Reactor.Action.didTapDate($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: CalendarFeedViewReactor) {
        reactor.state.map { $0.selectedDate }
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe {
                $0.0.calendarView.select($0.1, scrollToDate: true)
            }
            .disposed(by: disposeBag)
    }
}

extension CalendarFeedViewController {
    private func setupBlurEffect() {
        let blurEffect = UIBlurEffect(style: .light)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.alpha = 0.9
        visualEffectView.frame = view.frame
        imageBlurView.insertSubview(visualEffectView, at: 0)
    }
    
    private func setupNavigationTitle(_ date: Date) {
        navigationTitle.text = DateFormatter.yyyyMM.string(from: date)
    }
    
    private func embedFeedViewController() {
        view.addSubview(feedDetailView)
        feedDetailView.snp.makeConstraints {
            $0.top.equalTo(calendarView.snp.bottom)
            $0.leading.bottom.trailing.equalToSuperview()
        }
        feedDetailViewController.view.backgroundColor = UIColor.clear
        
        addChild(feedDetailViewController)
        feedDetailView.addSubview(feedDetailViewController.view)
        feedDetailViewController.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        feedDetailViewController.didMove(toParent: self)
    }
}

extension CalendarFeedViewController: FSCalendarDelegate {
    public func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendar.snp.updateConstraints {
            $0.height.equalTo(bounds.height)
        }
        view.layoutIfNeeded()
    }
    
    public func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        setupNavigationTitle(calendar.currentPage)
    }
}

extension CalendarFeedViewController: FSCalendarDataSource {
    public func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(
            withIdentifier: ImageCalendarCell.id,
            for: date,
            at: position
        ) as! ImageCalendarCell
        
        // NOTE: - 더미 데이터
        let imageUrls = [
            "https://cdn.pixabay.com/photo/2023/11/20/13/48/butterfly-8401173_1280.jpg",
            "https://cdn.pixabay.com/photo/2023/11/10/02/30/woman-8378634_1280.jpg",
            "https://cdn.pixabay.com/photo/2023/11/26/08/27/leaves-8413064_1280.jpg",
            "https://cdn.pixabay.com/photo/2023/09/03/17/00/chives-8231068_1280.jpg",
            "https://cdn.pixabay.com/photo/2023/09/25/13/42/kingfisher-8275049_1280.png",
            "", "", "", ""
        ]
        cell.configure(date, imageUrl: imageUrls.randomElement() ?? "", cellType: .week)
        
        return cell
    }
}
