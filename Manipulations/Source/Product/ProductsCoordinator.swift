//
//  ProductsCoordinator.swift
//  Manipulations
//
//  Created by Leonardo Portes on 06/02/23.
//

import Foundation

final class ProductsCoordinator: BaseCoordinator {
    override func start() {
        let viewModel = ProductsViewModel(coordinator: self)
        let controller = ProductsViewController(viewModel: viewModel, coordinator: self)
        configuration.navigationController?.navigationBar.topItem?.backButtonTitle = ""
        configuration.navigationController?.navigationBar.tintColor = .blackHigh
        configuration.navigationController?.pushViewController(controller, animated: true)
    }
    
    func registerProduct(products: [Product]) {
        let coordinator = RegisterProductsCoordinator(with: configuration)
        coordinator.start(products: products)
    }
}
