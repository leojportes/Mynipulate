//
//  StartViewModel.swift
//  Manipulations
//
//  Created by Leonardo Portes on 19/09/23.
//

import Foundation
import FirebaseAuth

protocol StartViewModelProtocol {
    func validate()
}

class StartViewModel: StartViewModelProtocol {

    // MARK: - Properties
    private var coordinator: StartCoordinator?

    // MARK: - Init
    init(coordinator: StartCoordinator?) {
        self.coordinator = coordinator
    }

    private func checkPassedTheOnboarding() -> Bool {
        let email = Auth.auth().currentUser?.email ?? .empty
        return MNUserDefaults.get(boolForString: email) ?? false
    }

    func validate() {
        if checkPassedTheOnboarding() {
            autoLogin()
        } else {
            self.coordinator?.navigateToLogin()
        }
    }

    func autoLogin() {
        /// Checa se existe valor na chave
        let data = KeychainService.loadCredentials()
        if KeychainService.verifyIfExists() {
            guard let email = data.first else { return }
            guard let password = data.last else { return }

            Auth.auth().signIn(withEmail: email, password:  password) { _, error in
                if error != nil {
                    self.coordinator?.navigateToLogin()
                } else {
                    self.coordinator?.navigateToHome()
                }
            }
        } else {
            self.coordinator?.navigateToLogin()
        }
    }
}

