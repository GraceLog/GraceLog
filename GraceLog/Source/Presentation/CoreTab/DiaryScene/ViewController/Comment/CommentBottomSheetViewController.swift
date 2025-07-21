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

final class CommentBottomSheetViewController: GraceLogBaseViewController, View {
    var disposeBag = DisposeBag()
    
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
    
    init(reactor: CommentBottomSheetViewReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStyles()
        setupLayouts()
        setupConstraints()
    }
    
    private func setupStyles() {
        view.backgroundColor = .systemBackground
    }
    
    private func setupLayouts() {
        view.addSubview(containerStackView)
        
        let subviews = [commentTableView, commentEditView]
        containerStackView.addArrangedDividerSubViews(subviews)
    }
    
    private func setupConstraints() {
        containerStackView.snp.makeConstraints {
            $0.top.directionalHorizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        commentEditView.snp.makeConstraints {
            $0.height.equalTo(76)
        }
    }
    
    func bind(reactor: CommentBottomSheetViewReactor) {
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
        
        commentEditView.commentSendButton.rx.tap
            .throttle(.milliseconds(300), scheduler: ConcurrentDispatchQueueScheduler(qos: .default))
            .withLatestFrom(commentEditView.commentTextField.rx.text.orEmpty)
            .map { CommentBottomSheetViewReactor.Action.didEditButton($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}

extension CommentBottomSheetViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: CommentTableHeaderView.identifier) as? CommentTableHeaderView ?? CommentTableHeaderView()
        let sectionedModel = commentDataSource[section]
        let mainComment = sectionedModel.mainComment
        let item = mainComment.item
        let isFolder = mainComment.isFolder
        
        headerView.configureUI(
            profileImageURL: item.profileImageURL,
            authorName: item.authorName,
            editedDate: item.editedDate,
            comment: item.comment
        )
        
        headerView.commentToggleButton.currentState = isFolder ? .folded(replyCount: sectionedModel.subComments.count) : .unfolded
        
        headerView.commentToggleButton.rx.tapGesture().when(.recognized)
            .throttle(.milliseconds(500), scheduler: ConcurrentDispatchQueueScheduler(qos: .default))
            .subscribe(with: self) { owner, _ in
                let isFolder = (headerView.commentToggleButton.currentState == .unfolded)
                
                DispatchQueue.main.async {
                    headerView.commentToggleButton.currentState = isFolder ? .folded(replyCount: sectionedModel.subComments.count) : .unfolded
                }
                
                owner.reactor?.action.onNext(.didTapFolderButton((section, isFolder)))
            }
            .disposed(by: headerView.disposeBag)
        
        return headerView
    }
}
