//
//  HomeViewController.swift
//  GraceLog
//
//  Created by 이상준 on 12/8/24.
//

import UIKit

import RxDataSources
import ReactorKit

enum HomeMenuItem: CaseIterable {
    case user
    case group
    
    var title: String {
        switch self {
        case .user:
            // TODO: - User관련 정보 처리 필요
            return "승렬"
        case .group:
            return "공동체"
        }
    }
}

final class HomeViewController: GraceLogBaseViewController, View {
    var disposeBag = DisposeBag()
    
    private let navigationBar = GLNavigationBar().then {
        $0.backgroundColor = .white
    }
    
    private let homeMenuView = GLUnderlineSegmentedControl(items: HomeMenuItem.allCases.map { $0.title }).then {
        $0.setHeight(50)
        $0.selectedSegmentIndex = 0
        $0.setTitleTextAttributes([.foregroundColor: UIColor.black, .font: GLFont.bold18.font], for: .normal)
        $0.setTitleTextAttributes([.foregroundColor: UIColor.themeColor, .font: GLFont.bold18.font], for: .selected)
    }
    
    private let bellButton = UIButton().then {
        $0.setImage(UIImage(named: "bell"), for: .normal)
        $0.tintColor = .black
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
    
    private lazy var homeMyViewController = HomeMyViewController()
    private lazy var homeCommunityViewController = HomeCommunityViewController(
        reactor: HomeCommunityViewReactor(
            usecase: DefaultHomeCommunityUseCase(
                homeRepository: DefaultHomeRepository()
            )
        )
    )
    
    private lazy var pages: [UIViewController] = [
        homeMyViewController,
        homeCommunityViewController
    ]
    
    init(reactor: HomeViewReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePageViewController()
        configureUI()
        configureNavBar()
    }
    
    private func configurePageViewController() {
        pageViewController.dataSource = nil
        pageViewController.delegate = self
        
        pageViewController.setViewControllers([pages[0]], direction: .forward, animated: false, completion: nil)
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        let safeArea = view.safeAreaLayoutGuide
        
        [navigationBar, pageViewController.view].forEach { view.addSubview($0) }
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(safeArea)
            $0.directionalHorizontalEdges.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        pageViewController.view.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.directionalHorizontalEdges.bottom.equalToSuperview()
        }
    }
    
    private func configureNavBar() {
        navigationBar.addLeftItem(homeMenuView)
        navigationBar.addRightItem(bellButton)
        navigationBar.addRightItem(profileButton)
    }
    
    func bind(reactor: HomeViewReactor) {
        // Action
        homeMenuView.rx.value
            .map { HomeMenuItem.allCases[$0] }
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
            .map { $0.user }
            .distinctUntilChanged()
            .compactMap { $0 }
            .subscribe(with: self) { owner, user in
                // TODO: - 상준 네비게이션바 사용자 이름 및 프로필 이미지 등록
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
