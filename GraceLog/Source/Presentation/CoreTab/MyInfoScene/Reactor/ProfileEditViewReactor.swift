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
    private let coordinator: ProfileEditCoordinator
    private let usecase: DefaultMyInfoUseCase
    private let userManager = UserManager.shared
    
    var initialState: State
    
    enum Action {
        //        case updateProfileImage(UIImage?)
        case updateNickname(String)
        case updateName(String)
        case updateMessage(String)
        case didTapProfileImageEdit
        case didTapSaveButton
        case didTapBackButton
    }
    
    enum Mutation {
        case setImage(Data?)
        case setNickname(String)
        case setName(String)
        case setMessage(String)
        case setError(Error)
        case setUpdateUserResult(Bool)
    }
    
    struct State {
        @Pulse var profileImageData: Data?
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
            profileImageData: nil,
            nickname: userManager.nickname,
            name: userManager.name,
            message: userManager.message,
            isSuccessUpdateUser: nil,
            error: nil
        )
    }
    
    private func createProfileImageMutation() -> Observable<Mutation> {
        guard let imageURL = userManager.profileImageURL else { return .empty() }
        
        return Observable.create { observer in
            Task {
                do {
                    let data = try await imageURL.fetchData()
                    observer.onNext(.setImage(data))
                } catch {
                    observer.onNext(.setImage(nil))
                }
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
}

extension ProfileEditViewReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .updateNickname(let nickname):
            return .just(.setNickname(nickname))
        case .updateName(let name):
            return .just(.setName(name))
        case .updateMessage(let message):
            return .just(.setMessage(message))
        case .didTapProfileImageEdit:
            return Observable.create { [weak self] observer in
                self?.coordinator.showImagePicker { image in
                    if let image = image {
                        observer.onNext(.setImage(image.pngData()))
                    } else {
                        observer.onNext(.setImage(nil))
                    }
                    observer.onCompleted()
                }
                return Disposables.create()
            }
        case .didTapSaveButton:
            usecase.updateUserInfo(
                name: currentState.name,
                nickname: currentState.nickname,
                profileImage: currentState.profileImageData,
                message: currentState.message
            )
        case .didTapBackButton:
            coordinator.popViewController()
        }
        return .empty()
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let profileImageMutation = createProfileImageMutation()
        
        let updateResultMutation = usecase.updateUserResult
            .map { Mutation.setUpdateUserResult($0) }
        
        return Observable.merge(
            profileImageMutation,
            updateResultMutation,
            mutation
        )
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setImage(let profileImageData):
            newState.profileImageData = profileImageData
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
