//
//  CreateCommunityViewController.swift
//  GraceLog
//
//  Created by 이건준 on 11/14/25.
//

import UIKit

import RxSwift
import RxDataSources
import SnapKit
import Then
import YPImagePicker

final class CreateCommunityViewController: GraceLogBaseViewController<CreateCommunityReactor> {
    private let scrollView = UIScrollView().then {
        $0.backgroundColor = .clear
        $0.showsHorizontalScrollIndicator = false
        $0.alwaysBounceVertical = true
    }
    
    private let containerStackView = UIStackView().then {
        $0.axis = .vertical
        $0.backgroundColor = .clear
        $0.distribution = .fill
        $0.alignment = .fill
    }
    
    private let communityEditView = CommunityEditView()
    private let communityImageListView = CommunityImageListView()
    
    private let createButton = UIButton().then {
        $0.backgroundColor = GLColor.textAccent.color
        $0.setTitle("만들기", for: .normal)
        $0.setTitleColor(GLColor.backgroundSub.color, for: .normal)
        $0.titleLabel?.font = GLFont.bold18.font
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }
    
    override func setupStyles() {
        super.setupStyles()
        navigationBar.setupTitleLabel(text: "공동체")
    }
    
    override func setupLayouts() {
        super.setupLayouts()
        [createButton, scrollView].forEach { contentView.addSubview($0) }
        [containerStackView].forEach { scrollView.addSubview($0) }
        let subviews = [communityEditView, communityImageListView]
        containerStackView.addArrangedDividerSubViews(subviews)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        createButton.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalToSuperview().inset(30)
            $0.bottom.equalTo(contentView.safeAreaLayoutGuide).offset(-42)
            $0.height.equalTo(45)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.directionalHorizontalEdges.width.equalToSuperview()
            $0.bottom.equalTo(createButton.snp.top)
        }
        
        containerStackView.snp.makeConstraints {
            $0.top.directionalHorizontalEdges.width.equalToSuperview()
            $0.bottom.lessThanOrEqualToSuperview()
        }
    }
    
    override func bind(reactor: CreateCommunityReactor) {
        super.bind(reactor: reactor)
        bindDiaryImageCollectionView(reactor: reactor)
        communityImageListView.imageListView.addImageButton.rx.tap
            .asDriver()
            .drive(with: self) { owner, _ in
                owner.showImagePicker()
            }
            .disposed(by: disposeBag)
        
        communityEditView.communityTitleEditView.text
            .map { CreateCommunityReactor.Action.editTitle($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        createButton.rx.tap
            .throttle(.milliseconds(300), scheduler: ConcurrentDispatchQueueScheduler(qos: .default))
            .map { CreateCommunityReactor.Action.didTapCreateButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.errorMessage }
            .distinctUntilChanged()
            .compactMap { $0 }
            .asDriver(onErrorDriveWith: .empty())
            .drive(with: self) { owner, message in
                owner.showToast(message)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Diary Bindings

extension CreateCommunityViewController {
    private func bindDiaryImageCollectionView(reactor: CreateCommunityReactor) {
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
                owner.communityImageListView.imageListView.updateWrittenCount(count: imageCount)
            }
            .disposed(by: disposeBag)
        
        diaryImageSectionState
            .bind(to: communityImageListView.imageListView.diaryImageCollectionView.rx.items(dataSource: imageDataSource))
            .disposed(by: disposeBag)
    }
}

// MARK: - ImagePicker For Community

extension CreateCommunityViewController {
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
}
