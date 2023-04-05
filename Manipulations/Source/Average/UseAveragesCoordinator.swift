//
//  UseAveragesCoordinator.swift
//  Manipulations
//
//  Created by Leonardo Portes on 31/12/22.
//

import Foundation

final class UseAveragesCoordinator: BaseCoordinator {
    func start(manipulations: [Manipulation]) {
        let viewModel = AverageViewModel(coordinator: self)
        let controller = UseAveragesHomeViewController(viewModel: viewModel, coordinator: self, manipulations: manipulations)
        configuration.navigationController?.navigationBar.topItem?.backButtonTitle = ""
        configuration.navigationController?.navigationBar.tintColor = .blackHigh
        configuration.navigationController?.pushViewController(controller, animated: true)
    }
}

extension UseAveragesCoordinator {

    // MARK: - Routes

    func openAverageList(
        averageType: UseAveragesType,
        _ products: [Product] = [],
        _ contributors: [Contributor] = [],
        _ manipulations: [Manipulation]
    ) {
        let coordinator = AverageListCoordinator(with: configuration)
        coordinator.start(averageType: averageType, products, contributors, manipulations)
    }

}
