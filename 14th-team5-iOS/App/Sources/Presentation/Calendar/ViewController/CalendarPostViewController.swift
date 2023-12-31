//
//  CalendarFeedViewController.swift
//  App
//
//  Created by 김건우 on 12/8/23.
//

import UIKit

import Core
import Domain
import FSCalendar
import Kingfisher
import ReactorKit
import RxCocoa
import RxSwift
import RxDataSources
import SnapKit
import Then


public final class CalendarPostViewController: BaseViewController<CalendarPostViewReactor> {
    // MARK: - Views
    private let imageBlurView: UIImageView = UIImageView()
    
    private let navigationBarView: UIView = UIView()
    private let backButton: UIButton = UIButton(type: .system)
    private let navigationTitle: UILabel = UILabel()
    
    private let calendarView: FSCalendar = FSCalendar()
    private let postView: UIView = UIView()
    
    private var postViewController: PostViewController = PostViewController(reacter: PostReactor())
    
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
            navigationBarView, calendarView, postView
        )
        navigationBarView.addSubviews(
            backButton, navigationTitle
        )
        
        embedPostViewController()
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
            
            $0.dataSource = self
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
        
        setupBlurEffect()
        setupNavigationTitle(calendarView.currentPage)
    }

    public override func bind(reactor: CalendarPostViewReactor) {
        super.bind(reactor: reactor)
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    private func bindInput(reactor: CalendarPostViewReactor) {
        let previousNextMonths: [String] = reactor.currentState.selectedCalendarCell.generatePreviousNextYearMonth()
        
        backButton.rx.tap
            .withUnretained(self)
            .subscribe {
                $0.0.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        calendarView.rx.didSelect
            .distinctUntilChanged()
            .map { Reactor.Action.didSelectCalendarCell($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        calendarView.rx.calendarCurrentPageDidChange
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe {
                $0.0.setupNavigationTitle($0.1)
            }
            .disposed(by: disposeBag)
        
        Observable<String>.from(previousNextMonths)
            .map { Reactor.Action.fetchCalendarResponse($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        calendarView.rx.fetchCalendarResponseDidChange
            .distinctUntilChanged()
            .flatMap {
                Observable<String>.from($0)
                    .map { Reactor.Action.fetchCalendarResponse($0) }
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        calendarView.rx.boundingRectWillChange
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe {
                $0.0.adjustWeeklyCalendarRect($0.1)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: CalendarPostViewReactor) {
        reactor.state.map { $0.dictCalendarResponse }
            .distinctUntilChanged(\.count)
            .withUnretained(self)
            .subscribe {
                $0.0.calendarView.reloadData()
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.selectedCalendarCell }
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe {
                $0.0.calendarView.select($0.1, scrollToDate: true)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Extensions
extension CalendarPostViewController {
    private func setupBlurEffect() {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.alpha = 0.9
        visualEffectView.frame = view.frame
        imageBlurView.insertSubview(visualEffectView, at: 0)
    }
    
    private func setupNavigationTitle(_ date: Date) {
        navigationTitle.text = DateFormatter.yyyyMM.string(from: date)
    }
    
    private func embedPostViewController() {
        view.addSubview(postView)
        postView.snp.makeConstraints {
            $0.top.equalTo(calendarView.snp.bottom)
            $0.leading.bottom.trailing.equalToSuperview()
        }
        postViewController.view.backgroundColor = UIColor.clear
        
        addChild(postViewController)
        postView.addSubview(postViewController.view)
        postViewController.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        postViewController.didMove(toParent: self)
    }
    
    private func adjustWeeklyCalendarRect(_ bounds: CGRect) {
        calendarView.snp.updateConstraints {
            $0.height.equalTo(bounds.height)
        }
        view.layoutIfNeeded()
    }
}

extension CalendarPostViewController: FSCalendarDataSource {
    public func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(
            withIdentifier: ImageCalendarCell.id,
            for: date,
            at: position
        ) as! ImageCalendarCell
        
        // 해당 일에 불러온 데이터가 없다면
        let yyyyMM: String = date.toFormatString()
        guard let currentState = reactor?.currentState,
              let dayResponse = currentState.dictCalendarResponse[yyyyMM]?.filter({ $0.date == date }).first
        else {
            let emptyResponse = CalendarResponse(
                date: date,
                representativePostId: "",
                representativeThumbnailUrl: "",
                allFamilyMemebersUploaded: false
            )
            cell.reactor = ImageCalendarCellDIContainer(
                .week,
                dayResponse: emptyResponse,
                isSelected: false
            ).makeReactor()
            return cell
        }
        
        cell.reactor = ImageCalendarCellDIContainer(
            .week,
            dayResponse: dayResponse,
            isSelected: currentState.selectedCalendarCell.isEqual(with: date)
        ).makeReactor()
        return cell
    }
}
