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
    enum Action {
        case updateProfileImage(UIImage?)
        case updateNickname(String)
        case updateName(String)
        case updateMessage(String)
        case didTapProfileImageEdit
        case didTapSaveButton
    }
    
    enum Mutation {
        case setProfileImageURL(URL?)
        case setSelectedImage(UIImage?)
        case setNickname(String)
        case setName(String)
        case setMessage(String)
        case setLoading(Bool)
        case setSaveSuccess(Bool)
        case setError(Error)
    }
    
    struct State {
        var profileImageURL: URL?
        var selectedImage: UIImage?
        var nickname: String?
        var name: String?
        var message: String?
        var isLoading: Bool
        var saveSuccess: Bool
        var error: Error?
    }
    
    var initialState: State
    weak var coordinator: ProfileEditCoordinator?
    private let useCase: DefaultMyInfoUseCase
    
    init(coordinator: ProfileEditCoordinator? = nil, useCase: DefaultMyInfoUseCase) {
        self.coordinator = coordinator
        self.useCase = useCase
        
        self.initialState = State(
            profileImageURL: URL(string: UserManager.shared.userProfileImageUrl),
            selectedImage: nil,
            nickname: UserManager.shared.userNickname,
            name: UserManager.shared.username,
            message: UserManager.shared.userMessage,
            isLoading: false,
            saveSuccess: false,
            error: nil
        )
    }
}

extension ProfileEditViewReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .updateProfileImage(let image):
            return .just(.setSelectedImage(image))
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
            return saveProfile()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setProfileImageURL(let url):
            newState.profileImageURL = url
            newState.selectedImage = nil
        case .setSelectedImage(let image):
            newState.selectedImage = image
        case .setNickname(let nickname):
            newState.nickname = nickname
        case .setName(let name):
            newState.name = name
        case .setMessage(let message):
            newState.message = message
        case .setLoading(let isLoading):
            newState.isLoading = isLoading
        case .setSaveSuccess(let success):
            newState.saveSuccess = success
        case .setError(let error):
            newState.error = error
        }
        
        return newState
    }
    
    private func saveProfile() -> Observable<Mutation> {
        guard let userId = UserManager.shared.userId else { return .empty()}
 
        let updateUser = GraceLogUser(
            id: userId,
            name: currentState.name ?? "",
            nickname: currentState.nickname ?? "",
            profileImage: currentState.profileImageURL ?? "",
            email: UserManager.shared.username ?? "",
            message: currentState.message ?? ""
        )
        
        return Observable.concat([
            .just(.setLoading(true)),
            useCase.updateUser(
                name: updateUser.name,
                nickname: updateUser.nickname,
                profileImage: updateUser.profileImage,
                message: updateUser.message
            )
            .asObservable()
            .map { _ in .setSaveSuccess(true) }
                .catch { error in
                    .just(.setError(error)) },
            .just(.setLoading(false))
        ])
    }
}
