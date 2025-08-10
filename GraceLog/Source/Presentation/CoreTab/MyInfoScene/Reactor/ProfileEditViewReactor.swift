//
//  ProfileEditViewReactor.swift
//  GraceLog
//
//  Created by 이상준 on 4/15/25.
//

import ReactorKit
import RxSwift
import RxCocoa

final class ProfileEditViewReactor: Reactor {
    weak var coordinator: ProfileEditCoordinator?
    private let usecase: DefaultMyInfoUseCase
    
    let user = UserManager.shared
    var initialState: State
    
    enum Action {
        case updateProfileImage(UIImage?)
        case updateNickname(String)
        case updateName(String)
        case updateMessage(String)
        case didTapProfileImageEdit
        case didTapSaveButton
        case didTapBackButton
    }
    
    enum Mutation {
        case setImage(UIImage?)
        case setNickname(String)
        case setName(String)
        case setMessage(String)
        case setError(Error)
        case setUpdateUserResult(Bool)
    }
    
    struct State {
        @Pulse var profileImage: UIImage?
        @Pulse var nickname: String
        @Pulse var name: String
        @Pulse var message: String
        @Pulse var isSuccessUpdateUser: Bool?
        @Pulse var error: Error?
    }
    
    init(coordinator: ProfileEditCoordinator, usecase: DefaultMyInfoUseCase) {
        self.coordinator = coordinator
        self.usecase = usecase
        
        self.initialState = State(
            profileImage: nil,
            nickname: user.nickname,
            name: user.name,
            message: user.message,
            isSuccessUpdateUser: nil,
            error: nil
        )
        
        usecase.loadProfileImageData()
    }
}

extension ProfileEditViewReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .updateProfileImage(let image):
            return .just(.setImage(image))
        case .updateNickname(let nickname):
            return .just(.setNickname(nickname))
        case .updateName(let name):
            return .just(.setName(name))
        case .updateMessage(let message):
            return .just(.setMessage(message))
        case .didTapProfileImageEdit:
            coordinator?.showImagePicker { [weak self] image in
                self?.action.onNext(.updateProfileImage(image))
            }
            return .empty()
        case .didTapSaveButton:
            usecase.updateUser(
                name: currentState.name,
                nickname: currentState.nickname,
                profileImage: currentState.profileImage?.pngData(),
                message: currentState.message
            )
            return .empty()
        case .didTapBackButton:
            coordinator?.popProfileEditViewController()
            return .empty()
        }
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let imageDataMutation = usecase.profileImageData
            .map { data -> UIImage? in
                guard let data = data else { return UIImage(named: "profile") }
                return UIImage(data: data)
            }
            .map { Mutation.setImage($0) }
        
        let updateResultMutation = usecase.updateUserResult
            .map { Mutation.setUpdateUserResult($0) }
        
        return Observable.merge(
            imageDataMutation,
            updateResultMutation,
            mutation
        )
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setImage(let image):
            newState.profileImage = image
        case .setNickname(let nickname):
            newState.nickname = nickname
        case .setName(let name):
            newState.name = name
        case .setMessage(let message):
            newState.message = message
        case .setError(let error):
            newState.error = error
        case .setUpdateUserResult(let isSuccess):
            newState.isSuccessUpdateUser = isSuccess
        }
        
        return newState
    }
}
