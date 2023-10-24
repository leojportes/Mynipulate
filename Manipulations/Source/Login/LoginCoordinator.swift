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
        let controller = LoginViewController(
            viewModel: viewModel,
            coordinator: self,
            didRegisterAccount: { self.openRegisterAccountScreen() }
        )
        configuration.viewController = controller
        configuration.navigationController?.navigationBar.isHidden = true
        configuration.navigationController?.pushViewController(controller, animated: true)
    }

    func openHomeScreen() {
        let coordinator = HomeCoordinator(with: configuration)
        coordinator.start()
        configuration.navigationController?.removeViewController(LoginViewController.self)
    }

    func openRegisterAccountScreen() {
        let coordinator = RegisterAccountCoordinator(with: configuration)
        coordinator.start()
        configuration.navigationController?.removeViewController(LoginViewController.self)
    }

    func openRecoveryPassword() {
        
    }

    func checkYourAccount() {
        let coordinator = CheckYourAccountCoordinator(with: configuration)
        coordinator.start()
    }

    func showUserOnboarding() {
        let coordinator = UserOnboardingCoordinator(with: configuration)
        coordinator.start()
    }
}
