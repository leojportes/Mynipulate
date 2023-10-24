//
//  ProfileViewModel.swift
//  Manipulations
//
//  Created by Leonardo Portes on 09/02/23.
//

import Foundation
import FirebaseAuth

protocol ProfileViewModelProtocol: AnyObject {
    var input: ProfileViewModelInputProtocol { get }
    var output: ProfileViewModelOutputProtocol { get }
    func signOut(resultSignOut: (Bool) -> Void)
    func authLogin(_ password: String, resultLogin: @escaping (Bool, String) -> Void)
    func logout()
    func openContributors()
}

// MARK: - Protocols
protocol ProfileViewModelOutputProtocol {
    var numberOfContributors: Bindable<Int> { get }
}

protocol ProfileViewModelInputProtocol {
    func viewDidLoad()
}

class ProfileViewModel: ProfileViewModelProtocol, ProfileViewModelOutputProtocol {
    var input: ProfileViewModelInputProtocol { self }
    var output: ProfileViewModelOutputProtocol { self }
    
    private let service: ProfileServiceProtocol
    
    var numberOfContributors: Bindable<Int> = .init(0)
    
    // MARK: - Properties
    private var coordinator: ProfileCoordinator?

    // MARK: - Init
    init(service: ProfileServiceProtocol = ProfileService(), coordinator: ProfileCoordinator?) {
        self.coordinator = coordinator
        self.service = service
    }

    private func getNumberOfContributors() {
        service.getContributorList { result in
            DispatchQueue.main.async {
                self.numberOfContributors.value = result.count
            }
        }
    }

    func signOut(resultSignOut: (Bool) -> Void) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            resultSignOut(true)
        } catch {
            resultSignOut(false)
        }
    }
    
    // MARK: Routes
    func openContributors() {
        coordinator?.openContributors()
    }

    func logout() {
        KeychainService.deleteCredentials()
        coordinator?.exitAccount()
    }

    func authLogin(_ password: String, resultLogin: @escaping (Bool, String) -> Void) {
        Auth.auth().signIn(withEmail: Current.shared.email, password: password) { _, error in
            if error != nil {
                guard let typeError = error as? NSError else { return }
                resultLogin(false, self.descriptionError(error: typeError))
            } else {
                resultLogin(true, .empty)
            }
        }
    }

    private func descriptionError(error: NSError) -> String {
        var description: String = .empty
        switch error.code {
        case AuthErrorCode.userNotFound.rawValue:
            description = "Não existe uma conta com esse e-mail"
        case AuthErrorCode.wrongPassword.rawValue:
            description = "Senha incorreta"
        default:
            description = "Ocorreu um erro. Tente novamente."
        }
        return description
    }
}

extension ProfileViewModel: ProfileViewModelInputProtocol {
    func viewDidLoad() {
        getNumberOfContributors()
    }
}

