//
//  RegisterContributorsCoordinator.swift
//  Manipulations
//
//  Created by Leonardo Portes on 15/02/23.
//

import Foundation

final class RegisterContributorsCoordinator: BaseCoordinator {
    func start(contributors: [Contributor] ) {
        let viewModel = RegisterContributorsViewModel(coordinator: self)
        let controller = RegisterContributorsViewController(viewModel: viewModel, coordinator: self, contributors: contributors)
        configuration.navigationController?.navigationBar.topItem?.backButtonTitle = ""
        configuration.navigationController?.navigationBar.tintColor = .blackHigh
        configuration.navigationController?.pushViewController(controller, animated: true)
    }

    func pop() {
        configuration.navigationController?.popViewController(animated: true)
    }
}
