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
    
    private lazy var scrollView = UIScrollView().then {
        $0.backgroundColor = .clear
        $0.showsHorizontalScrollIndicator = false
        $0.alwaysBounceVertical = true
    }
    
    private lazy var containerStackView = UIStackView().then {
        $0.axis = .vertical
        $0.backgroundColor = .clear
        $0.distribution = .fill
        $0.alignment = .fill
    }
    
    private let diaryImageListView = DiaryImageListView()
    private let diaryEditView = DiaryEditView()
    private let diaryKeywordView = DiaryKeywordView()
    private let diaryShareView = DiaryShareView()
    
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
                guard let cell = tableView.dequeueReusableCell(withIdentifier: DiaryShareTableViewCell.identifier, for: indexPath) as? DiaryShareTableViewCell else {
                    return UITableViewCell()
                }
//                cell.updateUI(imageUrl: imageUrl, title: title, isOn: isOn)
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
        setupLayouts()
        setupConstraints()
        setupStyles()
    }
    
    private func setupStyles() {
        navigationItem.rightBarButtonItem = saveButton
        navigationItem.rightBarButtonItem?.tintColor = .themeColor
        
        diaryKeywordView.keywordCollectionView.delegate = self
    }
    
    private func setupLayouts() {
        view.addSubview(scrollView)
        scrollView.addSubview(containerStackView)
        let subviews = [diaryImageListView, diaryEditView, diaryKeywordView, diaryShareView]
        containerStackView.addArrangedDividerSubViews(subviews, exclude: [0])
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints {
            $0.directionalEdges.width.equalToSuperview()
        }
        
        containerStackView.snp.makeConstraints {
            $0.top.directionalHorizontalEdges.width.equalToSuperview()
            $0.bottom.lessThanOrEqualToSuperview()
        }
    }
    
    private func configureTableView() {
        tableView.delegate = self
        
        tableView.register(CommonSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: CommonSectionHeaderView.identifier)
        tableView.register(CommonSectionWithDescHeaderView.self, forHeaderFooterViewReuseIdentifier: CommonSectionWithDescHeaderView.identifier)
//        tableView.register(DiaryImageTableViewCell.self, forCellReuseIdentifier: DiaryImageTableViewCell.identifier)
        tableView.register(DiaryTitleTableViewCell.self, forCellReuseIdentifier: DiaryTitleTableViewCell.identifier)
        tableView.register(DiaryDescriptionTableViewCell.self, forCellReuseIdentifier: DiaryDescriptionTableViewCell.identifier)
        tableView.register(DiaryKeywordTableViewCell.self, forCellReuseIdentifier: DiaryKeywordTableViewCell.identifier)
        tableView.register(DiaryShareTableViewCell.self, forCellReuseIdentifier: DiaryShareTableViewCell.identifier)
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

            self?.reactor?.action.onNext(.updateImages(newImages))
        }
        
        present(picker, animated: true, completion: nil)
    }
    
    func bind(reactor: DiaryViewReactor) {
        saveButton.rx.tap
            .map { Reactor.Action.saveDiary }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        diaryEditView.titleInputView.didEndEditing
            .withLatestFrom(diaryEditView.titleInputView.text)
            .subscribe(with: self) { owner, text in
                reactor.action.onNext(.updateTitle(text))
            }
            .disposed(by: disposeBag)
        
        diaryEditView.descriptionInputView.didEndEditing
            .withLatestFrom(diaryEditView.descriptionInputView.text)
            .subscribe(with: self) { owner, text in
                reactor.action.onNext(.updateDescription(text))
            }
            .disposed(by: disposeBag)
        
        diaryImageListView.addImageButton.rx.tap
            .asDriver()
            .drive(with: self) { owner, _ in
                owner.showImagePicker()
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.shareStates }
            .asDriver(onErrorJustReturn: [])
            .drive(diaryShareView.diaryShareTableView.rx.items(
                cellIdentifier: DiaryShareTableViewCell.identifier,
                cellType: DiaryShareTableViewCell.self)
            ) { index, item, cell in
                cell.updateUI(
                    imageNamed: item.diaryOption.logoImageNamed,
                    title: item.diaryOption.title,
                    isOn: item.isSelected
                )
                
                cell.shareSwitchButton.rx.isOn
                    .subscribe(with: self) { owner, isOn in
                        guard let indexPath = owner.diaryShareView.diaryShareTableView.indexPath(for: cell),
                              let currentState = try? owner.diaryShareView.diaryShareTableView.rx.model(at: indexPath) as DiaryShareState else {
                            return
                        }
                        let updateState = DiaryShareState(diaryOption: currentState.diaryOption, isSelected: isOn)
                        reactor.action.onNext(.didSelectShareOption(updateState))
                    }
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        bindDiaryImageCollectionView(reactor: reactor)
        bindDiaryKeywordCollectionView(reactor: reactor)
    }
    
    private func bindDiaryImageCollectionView(reactor: DiaryViewReactor) {
        let imageDataSource = RxCollectionViewSectionedAnimatedDataSource<DiaryImageSection>(
            configureCell: { _, collectionView, indexPath, item in
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: DiaryImageCollectionViewCell.reuseIdentifier,
                    for: indexPath
                ) as? DiaryImageCollectionViewCell ?? DiaryImageCollectionViewCell()
                cell.updateUI(diaryImage: item.image)
                cell.deleteButton.rx.tap
                    .subscribe(with: self) { owner, _ in
                        if case let .image(model) = item {
                            let images = reactor.currentState.images
                            if let index = images.firstIndex(where: { $0.id == model.id }) {
                                // TODO: - 삭제버튼 터치영역 재확인 필요
                                reactor.action.onNext(.deleteImage(at: index))
                            }
                        }
                    }
                    .disposed(by: cell.disposeBag)

                return cell
            }
        )
        
        let diaryImageSectionState = reactor.pulse(\.$images)
            .map { images in
                let items = images.map { DiaryImageItem.image($0) }
                return [DiaryImageSection.imageSection(items: items)]
            }.share(replay: 1)

        diaryImageSectionState
            .compactMap { $0.first?.items.count }
            .subscribe(with: self) { owner, imageCount in
                owner.diaryImageListView.updateWrittenCount(count: imageCount)
            }
            .disposed(by: disposeBag)
        
        diaryImageSectionState
            .bind(to: diaryImageListView.diaryImageCollectionView.rx.items(dataSource: imageDataSource))
            .disposed(by: disposeBag)
    }

    private func bindDiaryKeywordCollectionView(reactor: DiaryViewReactor) {
        reactor.state
            .map { $0.keywords }
            .asDriver(onErrorJustReturn: [])
            .drive(diaryKeywordView.keywordCollectionView.rx.items(
                cellIdentifier: DiaryKeywordCollectionViewCell.identifier,
                cellType: DiaryKeywordCollectionViewCell.self)
            ) { index, item, cell in
                cell.configureUI(keyword: item.keyword.rawValue)
            }
            .disposed(by: disposeBag)
        
        let collectionView = diaryKeywordView.keywordCollectionView
        
        let keywordSelectionEvent = Observable.merge(
            collectionView.rx.itemSelected.asObservable(),
            collectionView.rx.itemDeselected.asObservable()
        )

        let selectedKeywordModels = Observable.merge(
            collectionView.rx.modelSelected(DiaryKeywordState.self).asObservable(),
            collectionView.rx.modelDeselected(DiaryKeywordState.self).asObservable()
        )
        
        Observable.zip(keywordSelectionEvent, selectedKeywordModels)
            .subscribe(with: self) { owner, state in
                let (indexPath, model) = state
                guard let cell = collectionView.cellForItem(at: indexPath) as? DiaryKeywordCollectionViewCell else {
                    return
                }
                
                cell.configureUI(keyword: model.keyword.rawValue)
                
                Observable.just(DiaryKeywordState(
                    keyword: model.keyword,
                    isSelected: cell.isSelected
                ))
                .map { DiaryViewReactor.Action.didSelectKeyword($0) }
                .bind(to: reactor.action)
                .disposed(by: owner.disposeBag)
                
            }.disposed(by: disposeBag)
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

extension DiaryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == diaryKeywordView.keywordCollectionView {
            let width = (collectionView.frame.width - 20) / 3
            return CGSize(width: width, height: 30)
        }
        return .zero
    }
}
