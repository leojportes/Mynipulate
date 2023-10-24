//
//  RegisterAccountCoordinator.swift
//  Manipulations
//
//  Created by Leonardo Portes on 02/05/23.
//

import Foundation

final class RegisterAccountCoordinator: BaseCoordinator {
    override func start() {
        let viewModel = RegisterAccountViewModel(coordinator: self)
        let controller = RegisterAccountViewController(viewModel: viewModel, coordinator: self)
        configuration.viewController = controller
        configuration.navigationController?.present(controller, animated: true)
    }

    func closed() {
        configuration.navigationController?.dismiss(animated: true)
    }
}
