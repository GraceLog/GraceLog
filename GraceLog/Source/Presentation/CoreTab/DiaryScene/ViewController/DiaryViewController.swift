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

final class DiaryViewController: GraceLogBaseViewController<DiaryViewReactor> {
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
        $0.spacing = 20
    }
    
    private let cancelButton = UIButton().then {
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
        let image = UIImage(systemName: "xmark", withConfiguration: config)
        $0.setImage(image, for: .normal)
        $0.tintColor = GLColor.textAccent.color
    }
    
    private lazy var addImageContainerView = UIView().then {
        $0.addSubview(diaryImageListView)
        diaryImageListView.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalToSuperview().inset(30)
            $0.top.equalToSuperview().inset(14)
            $0.bottom.equalToSuperview()
        }
    }
    private let diaryImageListView = DiaryImageListView()
    private let diaryEditView = DiaryEditView()
    private let diaryKeywordView = DiaryKeywordView()
    private let diaryShareDivider = GLDividerView()
    private let diaryShareView = DiaryShareView()
    private let diarySettingView = DiarySettingView()
    
    private let shareButton = UIButton().then {
        $0.backgroundColor = .themeColor
        $0.setTitle("공유하기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = GLFont.extraBold18.font
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }
    
    override func setupStyles() {
        super.setupStyles()
        view.backgroundColor = .white
        navigationBar.setupTitleLabel(text: "일기 쓰기")
        navigationBar.addRightItem(cancelButton)
    }
    
    override func setupLayouts() {
        super.setupLayouts()
        contentView.addSubview(scrollView)
        [containerStackView, shareButton].forEach { scrollView.addSubview($0) }
        let subviews = [addImageContainerView, diaryEditView, diaryKeywordView, diaryShareDivider, diaryShareView, diarySettingView]
        containerStackView.addArrangedDividerSubViews(subviews, exclude: [2, 3])
        
        shareButton.snp.makeConstraints {
            $0.height.equalTo(45)
            $0.directionalHorizontalEdges.equalToSuperview().inset(30)
            $0.top.equalTo(containerStackView.snp.bottom).offset(61)
            $0.bottom.equalToSuperview().inset(42)
        }
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        scrollView.snp.makeConstraints {
            $0.directionalEdges.width.equalToSuperview()
        }
        
        containerStackView.snp.makeConstraints {
            $0.top.directionalHorizontalEdges.width.equalToSuperview()
            $0.bottom.lessThanOrEqualToSuperview()
        }
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
    
    override func bind(reactor: DiaryViewReactor) {
        super.bind(reactor: reactor)
        cancelButton.rx.tap
            .map { DiaryViewReactor.Action.didTapCloseButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        diaryEditView.titleInputView.text
            .subscribe(with: self) { owner, title in
                reactor.action.onNext(.updateTitle(title))
            }
            .disposed(by: disposeBag)
        
        diaryEditView.descriptionInputView.text
            .subscribe(with: self) { owner, content in
                reactor.action.onNext(.updateContent(content))
            }
            .disposed(by: disposeBag)
        
        diaryImageListView.addImageButton.rx.tap
            .asDriver()
            .drive(with: self) { owner, _ in
                owner.showImagePicker()
            }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$shareStates)
            .asDriver(onErrorJustReturn: [])
            .do(onNext: { [weak self] states in
                guard let self = self else { return }
                let isHidden = states.isEmpty
                self.diaryShareView.isHidden = isHidden
                self.diaryShareDivider.isHidden = isHidden
            })
            .drive(diaryShareView.diaryShareTableView.rx.items(
                cellIdentifier: DiaryShareTableViewCell.identifier,
                cellType: DiaryShareTableViewCell.self)
            ) { index, item, cell in
                cell.updateUI(
                    imageURL: item.diaryOption.logoImageURL,
                    name: item.diaryOption.name,
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
        
        shareButton.rx.tap
            .throttle(.milliseconds(500), latest: false, scheduler: ConcurrentDispatchQueueScheduler(qos: .default))
            .map { DiaryViewReactor.Action.didTapShareButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$isSuccessCreateDiary)
            .compactMap { $0 }
            .asDriver(onErrorJustReturn: false)
            .drive(with: self) { owner, isSuccess in
                if isSuccess == true {
                    reactor.action.onNext(.executeCreateDiary)
                }
            }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$error)
            .compactMap { $0 }
            .asDriver(onErrorDriveWith: .empty())
            .drive(with: self) { owner, error in
                owner.view.makeToast(error.localizedDescription)
            }
            .disposed(by: disposeBag)
        
        bindDiaryImageCollectionView(reactor: reactor)
        bindDiaryKeywordCollectionView(reactor: reactor)
        bindDiarySettingTableView(reactor: reactor)
    }
}

// MARK: - Diary Bindings
extension DiaryViewController {
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
        diaryKeywordView.keywordCollectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<Void, DiaryKeywordState>>(
            configureCell: { _, collectionView, indexPath, item in
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: DiaryKeywordCollectionViewCell.identifier,
                    for: indexPath
                ) as! DiaryKeywordCollectionViewCell
                
                cell.isSelected = item.isSelected
                cell.configureUI(keyword: item.keyword.rawValue)
                
                if item.isSelected {
                    collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
                } else {
                    collectionView.deselectItem(at: indexPath, animated: false)
                }
                
                return cell
            }
        )
        
        reactor.pulse(\.$keywords)
            .map { [SectionModel(model: (), items: $0)] }
            .asDriver(onErrorJustReturn: [])
            .drive(diaryKeywordView.keywordCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        Observable.merge(
            diaryKeywordView.keywordCollectionView.rx.modelSelected(DiaryKeywordState.self)
                .map { DiaryKeywordState(keyword: $0.keyword, isSelected: true) },
            diaryKeywordView.keywordCollectionView.rx.modelDeselected(DiaryKeywordState.self)
                .map { DiaryKeywordState(keyword: $0.keyword, isSelected: false) }
        )
        .map { DiaryViewReactor.Action.didSelectKeyword($0) }
        .bind(to: reactor.action)
        .disposed(by: disposeBag)
    }
    
    private func bindDiarySettingTableView(reactor: DiaryViewReactor) {
        Observable.just(DiarySettingMenu.allCases)
            .asDriver(onErrorJustReturn: [])
            .drive(diarySettingView.diarySettingTableView.rx.items(
                cellIdentifier: DiarySettingTableViewCell.identifier,
                cellType: DiarySettingTableViewCell.self)
            ) { index, item, cell in
                cell.configureUI(imageNamed: item.imageNamed, title: item.title)
            }
            .disposed(by: disposeBag)
        
        diarySettingView.diarySettingTableView.rx.modelSelected(DiarySettingMenu.self)
            .asDriver()
            .drive(with: self) { owner, selectedMenu in
                switch selectedMenu {
                case .setting:
                    reactor.action.onNext(.didTapSettings)
                }
            }
            .disposed(by: disposeBag)
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
