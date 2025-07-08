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
        case viewDidLoad
        case updateProfileImage(UIImage?)
        case updateNickname(String)
        case updateName(String)
        case updateMessage(String)
        case didTapProfileImageEdit
        case didTapSaveButton
    }
    
    enum Mutation {
        case setProfileImageURL(String)
        case setSelectedImage(UIImage?)
        case setNickname(String)
        case setName(String)
        case setMessage(String)
        case setLoading(Bool)
        case setSaveSuccess(Bool)
        case setError(Error)
    }
    
    struct State {
        var profileImageURL: String = AuthManager.shared.getUser()?.profileImage ?? ""
        var selectedImage: UIImage? = nil
        var nickname: String = AuthManager.shared.getUser()?.nickname ?? ""
        var name: String = AuthManager.shared.getUser()?.name ?? ""
        var message: String = AuthManager.shared.getUser()?.message ?? ""
        var isLoading: Bool = false
        var saveSuccess: Bool = false
        var error: Error? = nil
    }
    
    let initialState: State = State()
    weak var coordinator: ProfileEditCoordinator?
    private let useCase: DefaultMyInfoUseCase
    
    init(coordinator: ProfileEditCoordinator? = nil, useCase: DefaultMyInfoUseCase) {
        self.coordinator = coordinator
        self.useCase = useCase
    }
}

extension ProfileEditViewReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            let user = AuthManager.shared.getUser()
            return Observable.from([
                .setNickname(user?.nickname ?? ""),
                .setName(user?.name ?? ""),
                .setMessage(user?.message ?? ""),
                .setProfileImageURL(user?.profileImage ?? "")
            ])
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
        guard let user = AuthManager.shared.getUser() else { return .empty() }
        
        let updateUser = GraceLogUser(
            id: user.id,
            name: currentState.name,
            nickname: currentState.nickname,
            profileImage: user.profileImage,
            email: user.email,
            message: currentState.message
        )
        
        return Observable.concat([
            .just(.setLoading(true)),
            useCase.updateUser(user: updateUser)
                .asObservable()
                .map { _ in .setSaveSuccess(true) }
                .catch { error in
                    .just(.setError(error)) },
            .just(.setLoading(false))
        ])
    }
}
