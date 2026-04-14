//
//  LocationViewController.swift
//  Bibbi
//
//  Created by 마경미 on 30.03.26.
//

import Core
import UIKit

import CoreLocation
import DesignSystem
import ReactorKit
import RxCocoa
import RxSwift
import SnapKit

private struct LocationPlace {
    let name: String
    let address: String
    let latitude: Double
    let longitude: Double
    var distanceText: String = "거리 미확인"
}

// MARK: - Kakao Local API

private struct KakaoLocalResponse: Decodable {
    let documents: [KakaoDocument]
}

private struct KakaoDocument: Decodable {
    let placeName: String
    let addressName: String
    let roadAddressName: String
    let x: String
    let y: String
    let distance: String

    enum CodingKeys: String, CodingKey {
        case placeName = "place_name"
        case addressName = "address_name"
        case roadAddressName = "road_address_name"
        case x, y, distance
    }
}

private final class KakaoLocalAPIClient {
    static let shared = KakaoLocalAPIClient()
    private init() {}

    private var restAPIKey: String {
        Bundle.main.object(forInfoDictionaryKey: "KAKAO_LOCAL_REST_API_KEY") as? String ?? ""
    }

    @discardableResult
    func searchKeyword(
        query: String,
        x: Double? = nil,
        y: Double? = nil,
        radius: Int = 20000,
        completion: @escaping ([KakaoDocument]) -> Void
    ) -> URLSessionDataTask? {
        var components = URLComponents(string: "https://dapi.kakao.com/v2/local/search/keyword.json")!
        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "size", value: "15")
        ]
        if let x, let y {
            queryItems += [
                URLQueryItem(name: "x", value: "\(x)"),
                URLQueryItem(name: "y", value: "\(y)"),
                URLQueryItem(name: "radius", value: "\(radius)"),
                URLQueryItem(name: "sort", value: "distance")
            ]
        }
        components.queryItems = queryItems

        guard let url = components.url else {
            completion([])
            return nil
        }

        var request = URLRequest(url: url)
        request.setValue("KakaoAK \(restAPIKey)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data,
                  let response = try? JSONDecoder().decode(KakaoLocalResponse.self, from: data) else {
                return DispatchQueue.main.async { completion([]) }
            }
            DispatchQueue.main.async { completion(response.documents) }
        }
        task.resume()
        return task
    }

    @discardableResult
    func searchCategory(
        categoryGroupCode: String,
        x: Double,
        y: Double,
        radius: Int = 2000,
        completion: @escaping ([KakaoDocument]) -> Void
    ) -> URLSessionDataTask? {
        var components = URLComponents(string: "https://dapi.kakao.com/v2/local/search/category.json")!
        components.queryItems = [
            URLQueryItem(name: "category_group_code", value: categoryGroupCode),
            URLQueryItem(name: "x", value: "\(x)"),
            URLQueryItem(name: "y", value: "\(y)"),
            URLQueryItem(name: "radius", value: "\(radius)"),
            URLQueryItem(name: "size", value: "15"),
            URLQueryItem(name: "sort", value: "distance")
        ]

        guard let url = components.url else {
            completion([])
            return nil
        }

        var request = URLRequest(url: url)
        request.setValue("KakaoAK \(restAPIKey)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data,
                  let response = try? JSONDecoder().decode(KakaoLocalResponse.self, from: data) else {
                return DispatchQueue.main.async { completion([]) }
            }
            DispatchQueue.main.async { completion(response.documents) }
        }
        task.resume()
        return task
    }
}

// MARK: - LocationViewReactor

final class LocationViewReactor: Reactor {
    enum Action {
        case updateQuery(String)
    }

    enum Mutation {
        case setQuery(String)
    }

    struct State {
        var query: String = ""
    }

    let initialState = State()
}

extension LocationViewReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .updateQuery(query):
            return .just(.setQuery(query))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case let .setQuery(query):
            newState.query = query
            return newState
        }
    }
}

// MARK: - LocationTableViewCell

private final class LocationTableViewCell: UITableViewCell {
    static let id = "LocationTableViewCell"

    private let nameLabel = BBLabel(.body1Bold, textColor: .gray100)
    private let addressLabel = BBLabel(.caption, textColor: .gray400)
    private let distanceLabel = BBLabel(.body2Regular, textAlignment: .right, textColor: .gray300)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupUI()
        setupAutoLayout()
        setupAttributes()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension LocationTableViewCell {
    func setupUI() {
        contentView.addSubviews(nameLabel, addressLabel, distanceLabel)
    }

    func setupAutoLayout() {
        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(14)
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.lessThanOrEqualTo(distanceLabel.snp.leading).offset(-12)
        }

        distanceLabel.snp.makeConstraints {
            $0.centerY.equalTo(nameLabel)
            $0.trailing.equalToSuperview().inset(20)
        }

        addressLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(4)
            $0.leading.equalTo(nameLabel)
            $0.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(14)
        }
    }

    func setupAttributes() {
        backgroundColor = .clear
        selectionStyle = .none
        nameLabel.numberOfLines = 1
        addressLabel.numberOfLines = 2
    }
}

extension LocationTableViewCell {
    func configure(with place: LocationPlace) {
        nameLabel.text = place.name
        addressLabel.text = place.address
        distanceLabel.text = place.distanceText
    }
}

// MARK: - LocationViewController

final class LocationViewController: BBNavigationViewController<LocationViewReactor> {

    private enum SectionMode {
        case nearby
        case search

        var title: String {
            switch self {
            case .nearby: return "주변 위치"
            case .search: return "검색 결과"
            }
        }
    }

    private let searchContainerView = UIView()
    private let searchIconImageView = UIImageView()
    private let searchTextField = UITextField()
    private let clearButton = UIButton(type: .system)
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let sectionHeaderLabel = BBLabel(.body2Bold, textColor: .gray400)
    private let loadingIndicator = UIActivityIndicatorView(style: .medium)
    private let emptyImageView = UIImageView()
    private let emptyLabel = BBLabel(.body1Regular, textAlignment: .center, textColor: .gray400)

    var onSelectLocation: ((Double, Double, String) -> Void)?

    private let locationManager = CLLocationManager()
    private var currentLocation: CLLocation?
    private var nearbyPlaces: [LocationPlace] = []
    private var searchPlaces: [LocationPlace] = []
    private var isSearching = false
    private var isShowingLocationPermissionAlert = false
    private var activeTasks: [URLSessionDataTask] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchTextField.becomeFirstResponder()
    }

    override func bind(reactor: LocationViewReactor) {
        super.bind(reactor: reactor)

        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }

    override func setupUI() {
        super.setupUI()

        contentView.addSubviews(
            searchContainerView,
            sectionHeaderLabel,
            tableView,
            loadingIndicator,
            emptyImageView,
            emptyLabel
        )

        searchContainerView.addSubviews(searchIconImageView, searchTextField, clearButton)

        tableView.delegate = self
        tableView.dataSource = self
    }

    override func setupAutoLayout() {
        super.setupAutoLayout()

        searchContainerView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(44)
        }

        searchIconImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(14)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(18)
        }

        clearButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(14)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(20)
        }

        searchTextField.snp.makeConstraints {
            $0.leading.equalTo(searchIconImageView.snp.trailing).offset(8)
            $0.trailing.equalTo(clearButton.snp.leading).offset(-8)
            $0.verticalEdges.equalToSuperview()
        }

        sectionHeaderLabel.snp.makeConstraints {
            $0.top.equalTo(searchContainerView.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }

        tableView.snp.makeConstraints {
            $0.top.equalTo(sectionHeaderLabel.snp.bottom).offset(8)
            $0.horizontalEdges.bottom.equalToSuperview()
        }

        loadingIndicator.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(sectionHeaderLabel.snp.bottom).offset(48)
        }

        emptyImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(emptyLabel.snp.top).offset(-12)
            $0.size.equalTo(72)
        }

        emptyLabel.snp.makeConstraints {
            $0.center.equalTo(tableView)
            $0.horizontalEdges.equalToSuperview().inset(32)
        }
    }

    override func setupAttributes() {
        super.setupAttributes()

        navigationBar.do {
            $0.leftBarButtonItem = .arrowLeft
            $0.navigationTitle = "위치 검색"
        }

        searchContainerView.do {
            $0.backgroundColor = .gray800
            $0.layer.cornerRadius = 12
        }

        searchIconImageView.do {
            $0.image = UIImage(systemName: "magnifyingglass")
            $0.tintColor = .gray400
            $0.contentMode = .scaleAspectFit
        }

        searchTextField.do {
            $0.placeholder = "위치 검색"
            $0.font = .systemFont(ofSize: 15)
            $0.textColor = .gray100
            $0.returnKeyType = .search
            $0.clearButtonMode = .never
            $0.autocorrectionType = .no
            $0.autocapitalizationType = .none
        }

        clearButton.do {
            $0.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
            $0.tintColor = .gray400
            $0.isHidden = true
        }

        sectionHeaderLabel.text = SectionMode.nearby.title

        tableView.do {
            $0.register(LocationTableViewCell.self, forCellReuseIdentifier: LocationTableViewCell.id)
            $0.rowHeight = UITableView.automaticDimension
            $0.estimatedRowHeight = 76
            $0.separatorStyle = .none
            $0.backgroundColor = .clear
            $0.keyboardDismissMode = .onDrag
        }

        loadingIndicator.do {
            $0.hidesWhenStopped = true
            $0.color = .gray400
        }

        emptyImageView.do {
            $0.image = DesignSystemAsset.emptyCaseGraphicEmoji.image
            $0.contentMode = .scaleAspectFit
            $0.isHidden = true
        }

        emptyLabel.do {
            $0.text = "현재 위치 근처 장소를 불러오는 중이에요"
            $0.numberOfLines = 0
        }

        setupLocation()
    }
}

// MARK: - Bind

private extension LocationViewController {
    var currentPlaces: [LocationPlace] {
        isSearching ? searchPlaces : nearbyPlaces
    }

    func bindInput(reactor: LocationViewReactor) {
        navigationBar.rx.didTapLeftBarButton
            .bind(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)

        clearButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.searchTextField.text = ""
                owner.clearButton.isHidden = true
                owner.resetSearchState()
                owner.searchTextField.becomeFirstResponder()
                reactor.action.onNext(.updateQuery(""))
            }
            .disposed(by: disposeBag)

        searchTextField.rx.controlEvent(.editingChanged)
            .withLatestFrom(searchTextField.rx.text.orEmpty)
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .do(onNext: { [weak self] query in
                self?.clearButton.isHidden = query.isEmpty
            })
            .map(Reactor.Action.updateQuery)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    func bindOutput(reactor: LocationViewReactor) {
        reactor.state
            .map(\.query)
            .distinctUntilChanged()
            .bind(with: self) { owner, query in
                owner.handleQueryChange(query)
            }
            .disposed(by: disposeBag)
    }

    func handleQueryChange(_ query: String) {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)

        if trimmedQuery.isEmpty {
            resetSearchState()
            return
        }

        isSearching = true
        sectionHeaderLabel.text = SectionMode.search.title
        executeSearch(query: trimmedQuery)
    }
}

// MARK: - Location

private extension LocationViewController {
    func setupLocation() {
        locationManager.delegate = self
        requestLocationPermission()
    }

    func requestLocationPermission() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            startUpdatingLocation()
        case .restricted, .denied:
            updateEmptyState(message: "위치 권한이 없어서 검색만 가능해요")
            showLocationPermissionAlert()
        @unknown default:
            updateEmptyState(message: "현재 위치를 확인하지 못했어요")
        }
    }

    func startUpdatingLocation() {
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.startUpdatingLocation()
        loadingIndicator.startAnimating()
    }

    func searchNearbyLocations(at location: CLLocation) {
        let longitude = location.coordinate.longitude
        let latitude = location.coordinate.latitude

        // 관광명소, 음식점, 카페, 문화시설 카테고리 병렬 검색
        let categories = ["AT4", "FD6", "CE7", "CT1"]
        let group = DispatchGroup()
        var allDocuments: [KakaoDocument] = []
        let lock = NSLock()

        categories.forEach { code in
            group.enter()
            let task = KakaoLocalAPIClient.shared.searchCategory(
                categoryGroupCode: code,
                x: longitude,
                y: latitude,
                radius: 2000
            ) { documents in
                lock.lock()
                allDocuments += documents
                lock.unlock()
                group.leave()
            }
            if let task {
                activeTasks.append(task)
            }
        }

        group.notify(queue: .main) { [weak self] in
            guard let self else { return }

            self.loadingIndicator.stopAnimating()

            let seen = NSMutableSet()
            let unique = allDocuments.filter { doc in
                let key = "\(doc.placeName)-\(doc.x)-\(doc.y)"
                if seen.contains(key) { return false }
                seen.add(key)
                return true
            }

            self.nearbyPlaces = unique
                .sorted { (Double($0.distance) ?? 0) < (Double($1.distance) ?? 0) }
                .prefix(20)
                .map { self.makePlace(from: $0) }

            self.tableView.reloadData()
            self.updateEmptyState()
        }
    }
}

// MARK: - Search

private extension LocationViewController {
    func executeSearch(query: String) {
        cancelActiveTasks()
        loadingIndicator.startAnimating()
        emptyImageView.isHidden = true
        emptyLabel.isHidden = true
        searchPlaces = []

        let x = currentLocation.map { $0.coordinate.longitude }
        let y = currentLocation.map { $0.coordinate.latitude }

        let task = KakaoLocalAPIClient.shared.searchKeyword(
            query: query,
            x: x,
            y: y,
            radius: 20000
        ) { [weak self] documents in
            guard let self else { return }

            self.loadingIndicator.stopAnimating()
            self.searchPlaces = documents.map { self.makePlace(from: $0) }
            self.tableView.reloadData()
            self.updateEmptyState()
        }
        if let task {
            activeTasks.append(task)
        }
    }

    func resetSearchState() {
        cancelActiveTasks()
        loadingIndicator.stopAnimating()
        isSearching = false
        searchPlaces = []
        sectionHeaderLabel.text = SectionMode.nearby.title
        tableView.reloadData()
        updateEmptyState()
    }

    func cancelActiveTasks() {
        activeTasks.forEach { $0.cancel() }
        activeTasks.removeAll()
    }

    func makePlace(from document: KakaoDocument) -> LocationPlace {
        let address = document.roadAddressName.isEmpty ? document.addressName : document.roadAddressName
        let distanceText = makeDistanceText(from: document.distance)

        return LocationPlace(
            name: document.placeName,
            address: address,
            latitude: Double(document.y) ?? 0,
            longitude: Double(document.x) ?? 0,
            distanceText: distanceText
        )
    }

    func makeDistanceText(from distanceString: String) -> String {
        guard let meters = Double(distanceString), meters > 0 else {
            return "거리 미확인"
        }

        let km = meters / 1000.0

        if km < 0.1 {
            return "\(Int(meters))m"
        }

        if km < 10 {
            return String(format: "%.1fkm", km)
        }

        return "\(Int(km.rounded()))km"
    }

    func updateEmptyState(message: String? = nil) {
        let hasData = currentPlaces.isEmpty == false

        if let message {
            emptyImageView.isHidden = true
            emptyLabel.text = message
            emptyLabel.isHidden = false
            tableView.reloadData()
            return
        }

        if loadingIndicator.isAnimating {
            emptyImageView.isHidden = true
            emptyLabel.text = nil
            emptyLabel.isHidden = true
            return
        }

        if hasData {
            emptyImageView.isHidden = true
            emptyLabel.isHidden = true
            return
        }

        emptyImageView.isHidden = isSearching
        emptyLabel.isHidden = false
        emptyLabel.text = isSearching ? "검색 결과가 없습니다" : "주변 위치가 없습니다"
    }
}

// MARK: - Alert

private extension LocationViewController {
    func showLocationPermissionAlert() {
        guard isShowingLocationPermissionAlert == false else {
            return
        }

        let cancelHandler: BBAlertActionHandler = { [weak self] alert in
            self?.isShowingLocationPermissionAlert = false
            self?.navigationController?.popViewController(animated: true)
            alert?.close()
        }

        let settingsHandler: BBAlertActionHandler = { [weak self] alert in
            self?.isShowingLocationPermissionAlert = false

            guard let url = URL(string: UIApplication.openSettingsURLString),
                  UIApplication.shared.canOpenURL(url) else {
                alert?.close()
                return
            }

            UIApplication.shared.open(url)
            alert?.close()
        }

        let actions: [BBAlertAction] = [
            BBAlertAction(title: "나중에 하기", style: .cancel, handler: cancelHandler),
            BBAlertAction(title: "설정 열기", style: .default, handler: settingsHandler)
        ]

        let viewConfig = BBAlertViewConfiguration(
            minHeight: 205,
            buttonAxis: .horizontal
        )

        isShowingLocationPermissionAlert = true

        BBAlert.textWithButton(
            title: "위치 설정을 열고 '삐삐'에서\n회원님의 위치에 액세스하도록\n허용하세요",
            titleFontStyle: .head2Bold,
            subtitle: "기기 설정에서 '위치'를 눌러 설정하세요.",
            subtitleFontStyle: .body2Regular,
            linkTitle: nil,
            linkActions: { _ in },
            actions: actions,
            viewConfig: viewConfig,
            config: BBAlertConfiguration()
        )?.show()
    }
}

// MARK: - CLLocationManagerDelegate

extension LocationViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            startUpdatingLocation()
        case .restricted, .denied:
            loadingIndicator.stopAnimating()
            updateEmptyState(message: "위치 권한이 없어서 검색만 가능해요")
        case .notDetermined:
            break
        @unknown default:
            loadingIndicator.stopAnimating()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }

        if currentLocation == nil {
            currentLocation = location
            manager.stopUpdatingLocation()
            loadingIndicator.stopAnimating()

            if searchTextField.text?.isEmpty ?? true {
                searchNearbyLocations(at: location)
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        loadingIndicator.stopAnimating()
        updateEmptyState(message: "현재 위치를 확인하지 못했어요")
    }
}

// MARK: - UITextFieldDelegate

extension LocationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - TableView

extension LocationViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        currentPlaces.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: LocationTableViewCell.id,
            for: indexPath
        ) as? LocationTableViewCell else {
            return UITableViewCell()
        }

        cell.configure(with: currentPlaces[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let place = currentPlaces[indexPath.row]
        onSelectLocation?(place.latitude, place.longitude, place.name)
        navigationController?.popViewController(animated: true)
    }
}
