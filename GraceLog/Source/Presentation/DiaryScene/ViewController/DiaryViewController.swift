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
    private let diarySettingView = DiarySettingView()
    
    private let shareButton = UIButton().then {
        $0.backgroundColor = .themeColor
        $0.setTitle("공유하기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = GLFont.extraBold18.font
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayouts()
        setupConstraints()
        setupStyles()
    }
    
    private func setupStyles() {
        diaryKeywordView.keywordCollectionView.delegate = self
    }
    
    private func setupLayouts() {
        view.addSubview(scrollView)
        [containerStackView, shareButton].forEach { scrollView.addSubview($0) }
        let subviews = [diaryImageListView, diaryEditView, diaryKeywordView, diaryShareView, diarySettingView]
        containerStackView.addArrangedDividerSubViews(subviews, exclude: [0])
        
        shareButton.snp.makeConstraints {
            $0.height.equalTo(45)
            $0.directionalHorizontalEdges.equalToSuperview().inset(30)
            $0.top.equalTo(containerStackView.snp.bottom).offset(22)
            $0.bottom.equalToSuperview().inset(33)
        }
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
        
        shareButton.rx.tap
            .throttle(.milliseconds(500), latest: false, scheduler: ConcurrentDispatchQueueScheduler(qos: .default))
            .map { DiaryViewReactor.Action.didTapShareButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$isSuccessCreateDiary)
            .compactMap { $0 }
            .subscribe(with: self) { owner, isSuccess in
                // TODO: - 일기장 생성 성공여부에 따른 로직 구현
                print("일기장 생성 성공여부: \(isSuccess)")
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
        reactor.pulse(\.$keywords)
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
                    print("추가 설정화면 이동")
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
