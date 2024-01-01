//
//  AccountSignUpViewController.swift
//  App
//
//  Created by geonhui Yu on 12/8/23.
//

import UIKit
import Core
import DesignSystem
import PhotosUI

fileprivate typealias _Str = AccountSignUpStrings
public final class AccountSignUpViewController: BasePageViewController<AccountSignUpReactor> {
    private let nextButton = UIButton()
    private let descLabel = UILabel()
    
    private var pickerConfiguration: PHPickerConfiguration = {
        var configuration: PHPickerConfiguration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        configuration.selection = .default
        return configuration
    }()
    private lazy var profilePickerController: PHPickerViewController = PHPickerViewController(configuration: pickerConfiguration)
    
    private var pages = [UIViewController]()
    private var initalPage = 0
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        profilePickerController.delegate = self
        setViewControllers([pages[initalPage]], direction: .forward, animated: true)
        isPagingEnabled = false
    }
    
    public override func bind(reactor: AccountSignUpReactor) {
        App.Repository.token.accessToken
            .filter { $0?.isEmpty == true }
            .withUnretained(self)
            .take(1)
            .observe(on: Schedulers.main)
            .bind(onNext: { $0.0.showOnboardingViewCotnroller() })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.nicknameButtonTappedFinish }
            .filter { $0 }
            .take(1)
            .withUnretained(self)
            .bind(onNext: { $0.0.goToNextPage() })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.dateButtonTappedFinish }
            .filter { $0 }
            .take(1)
            .withUnretained(self)
            .bind(onNext: { $0.0.goToNextPage() })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.profileImageButtontapped }
            .filter { $0 }
            .observe(on: Schedulers.main)
            .withUnretained(self)
            .bind(onNext: { $0.0.createAlertController(owner: $0.0) })
            .disposed(by: disposeBag)
    }
    
    public override func setupUI() {
        super.setupUI()
        
        let nicknamePage = AccountNicknameViewController(reacter: reactor)
        let datePage = AccountDateViewController(reacter: reactor)
        let profilePage = AccountProfileViewController(reacter: reactor)
        
        pages.append(nicknamePage)
        pages.append(datePage)
        pages.append(profilePage)
        
        view.addSubviews(descLabel, nextButton)
    }
}

extension AccountSignUpViewController {
    private func goToNextPage() {
        guard let currentPage = viewControllers?[0],
              let nextPage = self.dataSource?.pageViewController(self, viewControllerAfter: currentPage) else { return }
        setViewControllers([nextPage], direction: .forward, animated: true)
    }
    
    private func showOnboardingViewCotnroller() {
        let onBoardingViewController = OnBoardingDIContainer().makeViewController()
        onBoardingViewController.modalPresentationStyle = .fullScreen
        present(onBoardingViewController, animated: true)
    }
}

extension AccountSignUpViewController: UIPageViewControllerDataSource {
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return nil
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        
        guard currentIndex < pages.count - 1 else { return nil }
        return pages[currentIndex + 1]
    }
}


extension AccountSignUpViewController {
    private func createAlertController(owner: AccountSignUpViewController) {
        let alertController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let presentCameraAction: UIAlertAction = UIAlertAction(title: "카메라", style: .default) { _ in
            let cameraViewController = CameraDIContainer(cameraType: .profile).makeViewController()
            owner.navigationController?.pushViewController(cameraViewController, animated: true)
        }
        let presentAlbumAction: UIAlertAction = UIAlertAction(title: "앨범", style: .default) { _ in
            self.profilePickerController.modalPresentationStyle = .fullScreen
            self.present(self.profilePickerController, animated: true)
        }
        let presentDefaultAction: UIAlertAction = UIAlertAction(title: "초기화", style: .destructive) { _ in
            print("초기화 구문")
        }
        let presentCancelAction: UIAlertAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        [presentCameraAction, presentAlbumAction, presentDefaultAction, presentCancelAction].forEach {
            alertController.addAction($0)
        }
        owner.present(alertController, animated: true)
    }
}

extension AccountSignUpViewController: PHPickerViewControllerDelegate {
    public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        let itemProvider = results.first?.itemProvider
        picker.dismiss(animated: true)
        if let imageProvider = itemProvider, imageProvider.canLoadObject(ofClass: UIImage.self) {
            imageProvider.loadObject(ofClass: UIImage.self) { image, error in
                guard let photoImage: UIImage = image as? UIImage,
                      let originalData: Data = photoImage.jpegData(compressionQuality: 1.0) else { return }
                imageProvider.didSelectProfileImageWithProcessing(photo: originalData, error: error)
            }
        }
    }
}
