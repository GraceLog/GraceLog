//
//  DiaryViewController.swift
//  GraceLog
//
//  Created by 이상준 on 2/5/25.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa
import ReactorKit
import RxDataSources
import YPImagePicker

final class DiaryViewController: UIViewController, View {
    typealias Reactor = DiaryViewReactor
    
    var disposeBag = DisposeBag()
    
    private lazy var tableView = UITableView(frame: .zero, style: .grouped).then {
        $0.backgroundColor = .white
        $0.separatorStyle = .none
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 100
        $0.sectionFooterHeight = 0
        $0.sectionHeaderTopPadding = 0
    }
    
    private let bottomView = UIView().then {
        $0.backgroundColor = .white
        $0.setHeight(100)
    }
    
    private let splitView = UIView().then {
        $0.backgroundColor = .gray100
        $0.setHeight(1)
    }
    
    private let shareButton = UIButton().then {
        $0.backgroundColor = .themeColor
        $0.setTitle("공유하기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = GLFont.extraBold18.font
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }
    
    private lazy var saveButton = UIBarButtonItem(title: "임시저장", style: .plain, target: nil, action: nil)
    private lazy var dataSource = RxTableViewSectionedReloadDataSource<DiarySection>(
        configureCell: { [weak self] dataSource, tableView, indexPath, item in
            guard let self = self, let reactor = self.reactor else {
                return UITableViewCell()
            }
            
            switch item {
            case .images(let images):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: DiaryImageTableViewCell.identifier, for: indexPath) as? DiaryImageTableViewCell else {
                    return UITableViewCell()
                }
                cell.setImages(images)
                
                cell.imageAddTap
                    .subscribe(onNext: { [weak self] _ in
                        self?.showImagePicker()
                    })
                    .disposed(by: cell.disposeBag)
                
                cell.imageDeleteTap
                    .subscribe(onNext: { [weak self] indexToDelete in
                        guard let self = self, let reactor = self.reactor else { return }
                        reactor.action.onNext(.deleteImage(at: indexToDelete))
                    })
                    .disposed(by: cell.disposeBag)
                
                return cell
            case .title(let title):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: DiaryTitleTableViewCell.identifier, for: indexPath) as? DiaryTitleTableViewCell else {
                    return UITableViewCell()
                }
                cell.configure(with: reactor, title: title ?? "")
                return cell
            case .description(let description):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: DiaryDescriptionTableViewCell.identifier, for: indexPath) as? DiaryDescriptionTableViewCell else {
                    return UITableViewCell()
                }
                cell.configure(with: reactor, description: description ?? "")
                return cell
            case .keyword:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: DiaryKeywordTableViewCell.identifier, for: indexPath) as? DiaryKeywordTableViewCell else {
                    return UITableViewCell()
                }
                return cell
            case .shareOption(let imageUrl, let title, let isOn):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: DiarySwitchTableViewCell.identifier, for: indexPath) as? DiarySwitchTableViewCell else {
                    return UITableViewCell()
                }
                cell.updateUI(imageUrl: imageUrl, title: title, isOn: isOn)
                return cell
            case .settings:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: DiarySettingsTableViewCell.identifier, for: indexPath) as? DiarySettingsTableViewCell else {
                    return UITableViewCell()
                }
                return cell
            case .button(let title):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: CommonButtonTableViewCell.identifier, for: indexPath) as? CommonButtonTableViewCell else {
                    return UITableViewCell()
                }
                cell.updateUI(title: title)
                return cell
            case .divide(let left, right: let right):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: CommonDivideTableViewCell.identifier, for: indexPath) as? CommonDivideTableViewCell else {
                    return UITableViewCell()
                }
                cell.setUI(left: left, right: right)
                return cell
            }
        }
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureTableView()
    }
    
    private func configureUI() {
        navigationItem.rightBarButtonItem = saveButton
        navigationItem.rightBarButtonItem?.tintColor = .themeColor
        
        let safeArea = view.safeAreaLayoutGuide
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(safeArea)
        }
    }
    
    private func configureTableView() {
        tableView.delegate = self
        
        tableView.register(CommonSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: CommonSectionHeaderView.identifier)
        tableView.register(CommonSectionWithDescHeaderView.self, forHeaderFooterViewReuseIdentifier: CommonSectionWithDescHeaderView.identifier)
        tableView.register(DiaryImageTableViewCell.self, forCellReuseIdentifier: DiaryImageTableViewCell.identifier)
        tableView.register(DiaryTitleTableViewCell.self, forCellReuseIdentifier: DiaryTitleTableViewCell.identifier)
        tableView.register(DiaryDescriptionTableViewCell.self, forCellReuseIdentifier: DiaryDescriptionTableViewCell.identifier)
        tableView.register(DiaryKeywordTableViewCell.self, forCellReuseIdentifier: DiaryKeywordTableViewCell.identifier)
        tableView.register(DiarySwitchTableViewCell.self, forCellReuseIdentifier: DiarySwitchTableViewCell.identifier)
        tableView.register(DiarySettingsTableViewCell.self, forCellReuseIdentifier: DiarySettingsTableViewCell.identifier)
        tableView.register(CommonButtonTableViewCell.self, forCellReuseIdentifier: CommonButtonTableViewCell.identifier)
        tableView.register(CommonDivideTableViewCell.self, forCellReuseIdentifier: CommonDivideTableViewCell.identifier)
    }
    
    private func configureImagePicker() -> YPImagePicker {
        var config = YPImagePickerConfiguration()
        config.library.maxNumberOfItems = 5
        config.startOnScreen = .library
        config.screens = [.library, .photo]
        config.library.mediaType = .photo
        config.hidesStatusBar = false
        config.hidesBottomBar = false
        config.library.skipSelectionsGallery = false
        
        config.wordings.libraryTitle = "사진 선택"
        config.wordings.cameraTitle = "카메라"
        config.wordings.next = "다음"
        config.wordings.cancel = "취소"
        config.wordings.done = "완료"
        
        let picker = YPImagePicker(configuration: config)
        return picker
    }
    
    private func showImagePicker() {
        let picker = configureImagePicker()
        
        picker.didFinishPicking { [weak self] items, cancelled in
            defer {
                picker.dismiss(animated: true, completion: nil)
            }
            
            if cancelled { return }
            
            var newImages: [UIImage] = []
            for item in items {
                if case .photo(let photo) = item {
                    newImages.append(photo.image)
                }
            }
            
            if let reactor = self?.reactor {
                let existingImages = reactor.currentState.images
                
                var combinedImages = existingImages + newImages
                if combinedImages.count > 5 {
                    combinedImages = Array(combinedImages.prefix(5))
                }
                reactor.action.onNext(.updateImages(combinedImages))
            }
        }
        
        present(picker, animated: true, completion: nil)
    }
    
    func bind(reactor: DiaryViewReactor) {
        // Action
        saveButton.rx.tap
            .map { Reactor.Action.saveDiary }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // State
        reactor.state.map { $0.sections }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

extension DiaryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionModel = dataSource[section]
        
        switch sectionModel {
        case .title, .description, .shareOptions:
            if let title = dataSource[section].title {
                let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: CommonSectionHeaderView.identifier) as? CommonSectionHeaderView
                headerView?.setTitle(title, font: GLFont.bold14.font)
                return headerView
            }
        case .keyword:
            if let title = dataSource[section].title, let desc = dataSource[section].desc {
                let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: CommonSectionWithDescHeaderView.identifier) as? CommonSectionWithDescHeaderView
                headerView?.setTitleWithDesc(title: title, desc: desc)
                return headerView
            }
        default:
            return nil
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let sectionModel = dataSource[section]
        
        switch sectionModel {
        case .images, .divide, .settings, .button:
            return .leastNonzeroMagnitude
        case .keyword:
            return 70
        default:
            return 40
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let sectionModel = dataSource[section]
        
        switch sectionModel {
        case .shareOptions:
            return 26
        default:
            return .leastNonzeroMagnitude
        }
    }
}
