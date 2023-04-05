//
//  AverageListCoordinator.swift
//  Manipulations
//
//  Created by Leonardo Portes on 22/01/23.
//

import Foundation

final class AverageListCoordinator: BaseCoordinator {
    func start(
        averageType: UseAveragesType,
        _ products: [Product] = [],
        _ contributors: [Contributor] = [],
        _ manipulations: [Manipulation]
    ) {
        let controller = AverageListViewController(
            averageType: averageType,
            coordinator: self,
            products,
            contributors,
            manipulations
        )
        configuration.navigationController?.navigationBar.topItem?.backButtonTitle = ""
        configuration.navigationController?.navigationBar.tintColor = .blackHigh
        configuration.navigationController?.pushViewController(controller, animated: true)
    }
}
