//
//  ChattingBottomSheetViewController.swift
//  GraceLog
//
//  Created by 이건준 on 7/19/25.
//

import UIKit

import ReactorKit
import RxDataSources
import SnapKit
import Then

final class CommentBottomSheetViewController: GraceLogBaseViewController<CommentBottomSheetViewReactor> {
    private var commentDataSource: RxTableViewSectionedAnimatedDataSource<CommentSection>!
    
    private let containerStackView = UIStackView().then {
        $0.backgroundColor = .clear
        $0.axis = .vertical
        $0.distribution = .fill
        $0.alignment = .fill
    }
    
    private let commentTableView = UITableView(frame: .zero, style: .grouped).then {
        $0.register(CommentTableHeaderView.self, forHeaderFooterViewReuseIdentifier: CommentTableHeaderView.identifier)
        $0.register(CommentTableViewCell.self, forCellReuseIdentifier: CommentTableViewCell.identifier)
        $0.backgroundColor = .clear
        $0.sectionHeaderHeight = UITableView.automaticDimension
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 84
        $0.sectionHeaderTopPadding = .leastNonzeroMagnitude
        $0.estimatedSectionFooterHeight = .leastNonzeroMagnitude
        $0.alwaysBounceVertical = true
        $0.separatorStyle = .none
    }
    private let commentEditView = CommentEditView()
    
    override func setupLayouts() {
        super.setupLayouts()
        view.addSubview(containerStackView)
        
        let subviews = [commentTableView, commentEditView]
        containerStackView.addArrangedDividerSubViews(subviews)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        containerStackView.snp.makeConstraints {
            $0.top.directionalHorizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        commentEditView.snp.makeConstraints {
            $0.height.equalTo(76)
        }
    }
    
    override func bind(reactor: CommentBottomSheetViewReactor) {
        super.bind(reactor: reactor)
        rx.methodInvoked(#selector(UIViewController.viewDidLoad))
            .take(1)
            .map { _ in CommentBottomSheetViewReactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        commentTableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        commentDataSource = RxTableViewSectionedAnimatedDataSource(configureCell: { dataSource, tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: CommentTableViewCell.identifier, for: indexPath) as? CommentTableViewCell ?? CommentTableViewCell()
            cell.configureUI(
                profileImageURL: item.profileImageURL,
                authorName: item.authorName,
                editedDate: item.editedDate,
                comment: item.comment
            )
            return cell
        })
        
        reactor.pulse(\.$commentList)
            .asDriver(onErrorJustReturn: [])
            .drive(commentTableView.rx.items(dataSource: commentDataSource))
            .disposed(by: disposeBag)
    }
}

extension CommentBottomSheetViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: CommentTableHeaderView.identifier) as? CommentTableHeaderView ?? CommentTableHeaderView()
        let sectionedModel = commentDataSource[section]
        let mainComment = sectionedModel.mainComment
        let item = mainComment.item
        
        let parentId = item.id
        
        headerView.configureUI(
            profileImageURL: item.profileImageURL,
            authorName: item.authorName,
            editedDate: item.editedDate,
            comment: item.comment
        )
        
        headerView.commentToggleButton.currentState =
        mainComment.isFolder
        ? .folded(replyCount: sectionedModel.mainComment.replyCount)
        : .unfolded
        
        headerView.commentToggleButton.rx.tapGesture().when(.recognized)
            .throttle(.milliseconds(500), scheduler: ConcurrentDispatchQueueScheduler(qos: .default))
            .subscribe(with: self) { owner, _ in
                owner.reactor?.action.onNext(.didTapToggleReplies(parentId: parentId))
            }
            .disposed(by: headerView.disposeBag)
        
        headerView.replyButton.rx.tap
            .throttle(.milliseconds(500), scheduler: ConcurrentDispatchQueueScheduler(qos: .default))
            .subscribe(with: self) { owner, _ in
                owner.reactor?.action.onNext(.didEditReplyButton(parentId: parentId))
                DispatchQueue.main.async {
                    owner.commentEditView.commentTextField.becomeFirstResponder()
                }
            }
            .disposed(by: headerView.disposeBag)
        
        return headerView
    }
}
