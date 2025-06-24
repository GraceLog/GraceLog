//
//  CommunityTableViewCell.swift
//  GraceLog
//
//  Created by 이상준 on 2/22/25.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

final class CommunityTableViewCell: UITableViewCell {
    static let identifier = "CommunityTableViewCell"
    
    let communityButtonTapped = PublishSubject<CommunityItem>()
    private var disposeBag = DisposeBag()
    
    private let scrollView = UIScrollView().then {
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = false
        $0.bounces = false
    }
    
    private let stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 7
        $0.alignment = .center
    }
    
    private lazy var communityButtons: [CommunityButton] = []
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    private func configureUI() {
        contentView.backgroundColor = .white
        
        contentView.addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(140)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(29)
            $0.leading.equalToSuperview().inset(17)
            $0.trailing.equalToSuperview().inset(17)
            $0.bottom.equalToSuperview().inset(20)
        }
    }
    
    private func createCommunityButton(image: UIImage?, title: String, model: CommunityItem) -> CommunityButton {
        let button = CommunityButton()
        button.configure(model: model, image: image, title: title)
        
        button.tapEvent
            .bind(to: communityButtonTapped)
            .disposed(by: disposeBag)
        
        return button
    }
    
    func configure(with buttons: [CommunityItem]) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        communityButtons.removeAll()
        
        buttons.forEach { buttonModel in
            let buttonView = createCommunityButton(
                image: UIImage(named: buttonModel.imageName),
                title: buttonModel.title,
                model: buttonModel
            )
            communityButtons.append(buttonView)
            stackView.addArrangedSubview(buttonView)
        }
    }
}
