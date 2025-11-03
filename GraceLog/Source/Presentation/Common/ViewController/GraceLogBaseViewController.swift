//
//  GraceLogBaseViewController.swift
//  GraceLog
//
//  Created by 이상준 on 6/2/25.
//

import UIKit

import ReactorKit
import SnapKit
import Then
import Toast_Swift

class GraceLogBaseViewController<R: Reactor>: UIViewController, View {
    typealias Reactor = R
    var disposeBag: RxSwift.DisposeBag = DisposeBag()
    
    let navigationBar = GLNavigationBar()
    let contentView = UIView()
    var showNavigationBar: Bool = true {
        didSet {
            updateNavigationBarLayout()
        }
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init(reactor: Reactor? = nil) {
        self.init()
        self.reactor = reactor
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStyles()
        setupLayouts()
        setupConstraints()
    }
    
    func setupStyles() {
        view.backgroundColor = GLColor.backgroundMain.color
    }
    
    func setupLayouts() {
        [navigationBar, contentView].forEach { view.addSubview($0) }
    }
    
    func setupConstraints() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.directionalHorizontalEdges.equalToSuperview()
            $0.height.equalTo(Constants.navigationBarHeight)
        }
        
        contentView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.directionalHorizontalEdges.bottom.equalToSuperview()
        }
        
        view.bringSubviewToFront(navigationBar)
    }
    
    func bind(reactor: R) {
        
    }
}

extension GraceLogBaseViewController {
    private func updateNavigationBarLayout() {
        navigationBar.snp.updateConstraints { $0.height.equalTo(showNavigationBar ? Constants.navigationBarHeight : 0) }
    }
}

extension GraceLogBaseViewController {
    func showToast(_ message: String) {
        view.makeToast(message)
    }
    
    func showErrorToast(_ error: Error) {
        view.makeToast(error.localizedDescription)
    }
}
