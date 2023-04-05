//
//  LoginCoordinator.swift
//  Manipulations
//
//  Created by Leonardo Portes on 07/03/23.
//

import Foundation

final class LoginCoordinator: BaseCoordinator {
    override func start() {
        let viewModel = LoginViewModel(coordinator: self)
        let controller = LoginViewController(viewModel: viewModel, coordinator: self)
        configuration.navigationController?.navigationBar.topItem?.backButtonTitle = ""
        configuration.navigationController?.navigationBar.tintColor = .blackHigh
        configuration.navigationController?.pushViewController(controller, animated: true)
    }

    func openHomeScreen() {
        
    }

    func openRegisterAccountScreen() {
        
    }

    func openRecoveryPassword() {
        
    }

}
