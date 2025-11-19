//
//  HomeViewController.swift
//  GraceLog
//
//  Created by 이상준 on 12/8/24.
//

import UIKit

import RxDataSources
import ReactorKit

final class HomeViewController: GraceLogBaseViewController<HomeViewReactor> {
    private let homeMenuView = GLUnderlineSegmentedControl(items: []).then {
        $0.setHeight(50)
        $0.setTitleTextAttributes([.foregroundColor: GLColor.textHome.color, .font: GLFont.bold18.font], for: .normal)
        $0.setTitleTextAttributes([.foregroundColor: UIColor.themeColor, .font: GLFont.bold18.font], for: .selected)
    }
    
    private let bellButton = UIButton().then {
        $0.setImage(UIImage(named: "bell"), for: .normal)
        $0.tintColor = GLColor.textSub.color
        $0.setDimensions(width: 32, height: 32)
    }
    
    private let profileButton = UIButton().then {
        $0.backgroundColor = .systemGray2
        $0.layer.cornerRadius = 16
        $0.clipsToBounds = true
        $0.setBackgroundImage(UIImage(named: "profile"), for: .normal)
        $0.setDimensions(width: 32, height: 32)
    }
    
    private let pageViewController = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .horizontal,
        options: nil
    )
    
    lazy var homeMyViewController = DependencyContainer.shared.injector.resolve(HomeMyViewController.self)
    lazy var homeCommunityViewController = DependencyContainer.shared.injector.resolve(HomeCommunityViewController.self)
    
    private lazy var pages: [UIViewController] = [
        homeMyViewController,
        homeCommunityViewController
    ]
    
    private func configurePageViewController() {
        pageViewController.dataSource = nil
        pageViewController.delegate = self
        
        pageViewController.setViewControllers([pages[0]], direction: .forward, animated: false, completion: nil)
    }
    
    override func setupStyles() {
        super.setupStyles()
        view.backgroundColor = GLColor.backgroundSub.color
        configureNavBar()
        configurePageViewController()
    }
    
    override func setupLayouts() {
        super.setupLayouts()
        contentView.addSubview(pageViewController.view)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        pageViewController.view.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
    }
    
    private func configureNavBar() {
        navigationBar.addLeftItem(homeMenuView)
        navigationBar.addRightItem(bellButton)
        navigationBar.addRightItem(profileButton)
    }
    
    override func bind(reactor: HomeViewReactor) {
        super.bind(reactor: reactor)
        // Action
        homeMenuView.rx.value
            .map { index -> HomeViewReactor.State.HomeModeSegment in
                return index == 0 ? .user : .group
            }
            .bind(with: self) { owner, selectedMenu in
                let targetIndex = selectedMenu == .user ? 0 : 1
                owner.moveToPage(at: targetIndex, animated: true)
                
                switch selectedMenu {
                case .user:
                    reactor.action.onNext(HomeViewReactor.Action.userButtonTapped)
                case .group:
                    reactor.action.onNext(HomeViewReactor.Action.groupButtonTapped)
                }
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.segmentTitles }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: ["사용자", "공동체"])
            .drive(with: self) { owner, titles in
                titles.enumerated().forEach { index, title in
                    owner.homeMenuView.insertSegment(withTitle: title, at: index, animated: false)
                }
                owner.homeMenuView.selectedSegmentIndex = 0
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .compactMap { $0.profileImageUrl }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: nil)
            .drive(with: self) { owner, imageUrl in
                owner.profileButton.kf.setBackgroundImage(
                    with: imageUrl,
                    for: .normal,
                    placeholder: UIImage(named: "profile")
                )
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .compactMap { $0.error }
            .asDriver(onErrorDriveWith: .empty())
            .drive(with: self) { owner, error in
                owner.view.makeToast(error.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
    
    private func moveToPage(at index: Int, animated: Bool) {
        guard index < pages.count,
              let currentViewController = pageViewController.viewControllers?.first,
              let currentIndex = pages.firstIndex(of: currentViewController),
              currentIndex != index else { return }
        
        let direction: UIPageViewController.NavigationDirection = index > currentIndex ? .forward : .reverse
        
        pageViewController.setViewControllers(
            [pages[index]],
            direction: direction,
            animated: animated,
            completion: nil
        )
    }
}

// MARK: - UIPageViewControllerDataSource, UIPageViewControllerDelegate
extension HomeViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        
        guard currentIndex > 0 else { return nil }
        return pages[currentIndex - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        
        guard currentIndex < (pages.count - 1) else { return nil}
        return pages[currentIndex + 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed,
              let currentViewController = pageViewController.viewControllers?.first,
              let index = pages.firstIndex(of: currentViewController) else { return }
        
        homeMenuView.selectedSegmentIndex = index
        let selectedSegment: HomeViewReactor.State.HomeModeSegment = index == 0 ? .user : .group
        if selectedSegment != reactor?.currentState.currentSegment {
            switch selectedSegment {
            case .user:
                reactor?.action.onNext(.userButtonTapped)
            case .group:
                reactor?.action.onNext(.groupButtonTapped)
            }
        }
    }
}
