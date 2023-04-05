//
//  ContributorsCoordinator.swift
//  Manipulations
//
//  Created by Leonardo Portes on 08/02/23.
//

import Foundation

final class ContributorsCoordinator: BaseCoordinator {
    override func start() {
        let viewModel = ContributorsViewModel(coordinator: self)
        let controller = ContributorsViewController(viewModel: viewModel, coordinator: self)
        configuration.navigationController?.navigationBar.topItem?.backButtonTitle = ""
        configuration.navigationController?.navigationBar.tintColor = .blackHigh
        configuration.navigationController?.pushViewController(controller, animated: true)
    }

    func registerContributors(contributors: [Contributor]) {
        let coordinator = RegisterContributorsCoordinator(with: configuration)
        coordinator.start(contributors: contributors)
    }
}
