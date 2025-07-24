//
//  GraceLogBaseViewController.swift
//  GraceLog
//
//  Created by 이상준 on 6/2/25.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import ReactorKit
import SnapKit
import Then
import Toast_Swift
import NVActivityIndicatorView

class GraceLogBaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func onUserProfileUpdated(_ user: GraceLogUser) {
        
    }
    
    func showToast(_ message: String) {
        view.makeToast(message)
    }
    
    func showErrorToast(_ error: Error) {
        view.makeToast(error.localizedDescription)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
