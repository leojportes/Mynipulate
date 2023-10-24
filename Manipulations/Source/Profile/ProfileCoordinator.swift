//
//  ProfileCoordinator.swift
//  Manipulations
//
//  Created by Leonardo Portes on 09/02/23.
//

import Foundation

final class ProfileCoordinator: BaseCoordinator {
    override func start() {
        let viewModel = ProfileViewModel(coordinator: self)
        let controller = ProfileViewController(viewModel: viewModel, coordinator: self)
        configuration.navigationController?.navigationBar.topItem?.backButtonTitle = ""
        configuration.navigationController?.navigationBar.tintColor = .blackHigh
        configuration.navigationController?.pushViewController(controller, animated: true)
    }
    
    func openContributors() {
        let coordinator = ContributorsCoordinator(with: configuration)
        coordinator.start()
    }
    
    func exitAccount() {
        let coordinator = LoginCoordinator(with: configuration)
        configuration.navigationController?.dismiss(animated: true)
        configuration.navigationController?.viewControllers.removeAll()
        coordinator.start()
    }
    
}
