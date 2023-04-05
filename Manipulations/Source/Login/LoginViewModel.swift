//
//  LoginViewModel.swift
//  Manipulations
//
//  Created by Leonardo Portes on 07/03/23.
//

import Foundation

protocol LoginViewModelProtocol: AnyObject {
    func openHomeScreen()
}

class LoginViewModel: LoginViewModelProtocol {

    // MARK: - Properties
    private var coordinator: LoginCoordinator?

    // MARK: - Init
    init(coordinator: LoginCoordinator?) {
        self.coordinator = coordinator
    }

    // MARK: Routes
    func openHomeScreen() {
        
    }

}
