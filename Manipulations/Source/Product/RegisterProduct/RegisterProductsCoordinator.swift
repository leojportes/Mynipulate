//
//  RegisterProductsCoordinator.swift
//  Manipulations
//
//  Created by Leonardo Portes on 07/02/23.
//

import Foundation

import Foundation

final class RegisterProductsCoordinator: BaseCoordinator {
    
    func start(products: [Product]) {
        let viewModel = RegisterProductsViewModel(coordinator: self)
        let controller = RegisterProductsViewController(viewModel: viewModel, coordinator: self, products: products)
        configuration.navigationController?.navigationBar.topItem?.backButtonTitle = ""
        configuration.navigationController?.navigationBar.tintColor = .blackHigh
        configuration.navigationController?.pushViewController(controller, animated: true)
    }

    func pop() {
        configuration.navigationController?.popViewController(animated: true)
    }
}
