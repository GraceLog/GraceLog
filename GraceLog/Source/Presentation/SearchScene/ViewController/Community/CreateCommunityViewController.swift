//
//  CreateCommunityViewController.swift
//  GraceLog
//
//  Created by 이건준 on 11/14/25.
//

import UIKit

import RxDataSources
import SnapKit
import Then
import YPImagePicker

final class CreateCommunityViewController: GraceLogBaseViewController<CreateCommunityReactor> {
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
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = .init(top: 24, left: 30, bottom: .zero, right: 30)
    }
    
    let communityImageListView = CommunityImageListView()
    
    override func setupStyles() {
        super.setupStyles()
        
    }
    
    override func setupLayouts() {
        super.setupLayouts()
        contentView.addSubview(scrollView)
        [containerStackView].forEach { scrollView.addSubview($0) }
        let subviews = [communityImageListView]
        containerStackView.addArrangedDividerSubViews(subviews, exclude: [0])
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
    
    override func bind(reactor: CreateCommunityReactor) {
        super.bind(reactor: reactor)
        bindDiaryImageCollectionView(reactor: reactor)
        communityImageListView.imageListView.addImageButton.rx.tap
            .asDriver()
            .drive(with: self) { owner, _ in
                owner.showImagePicker()
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
