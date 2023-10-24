//
//  HomeCoordinator.swift
//  Manipulations
//
//  Created by Leonardo Portes on 29/12/22.
//

import Foundation

final class HomeCoordinator: BaseCoordinator {
    override func start() {
        let viewModel = HomeViewModel(coordinator: self)
        let controller = HomeViewController(viewModel: viewModel, coordinator: self)
        configuration.viewController = controller
        configuration.navigationController?.pushViewController(controller, animated: true)
    }

    // MARK: - Routes
    func didTapMenuItem(
        _ item: MenuCollectionType,
        products: [Product],
        contributors: [Contributor],
        manipulations: [Manipulation]
    ) {
        switch item {
        case .manipulations: openManipulations(products: products, contributors: contributors)
        case .products: openProducts()
        case .contributors: openContributors()
        case .averages: openUseAveragesHome(manipulations: manipulations)
        case .discarts: openDiscarts()
        case .profile: openProfile()
        }
    }
}

extension HomeCoordinator {

    private func openUseAveragesHome(manipulations: [Manipulation]) {
        let coordinator = UseAveragesCoordinator(with: configuration)
        coordinator.start(manipulations: manipulations)
    }

    private func openManipulations(products: [Product], contributors: [Contributor]) {
        let coordinator = ManipulationsCoordinator(with: configuration)
        coordinator.start(products: products, contributors: contributors)
    }

    private func openProducts() {
        let coordinator = ProductsCoordinator(with: configuration)
        coordinator.start()
    }

    private func openDiscarts() {
        // let coordinator = ProductsCoordinator(with: configuration)
        // coordinator.start()
    }

    private func openContributors() {
        let coordinator = ContributorsCoordinator(with: configuration)
        coordinator.start()
    }

    func openProfile() {
        let coordinator = ProfileCoordinator(with: configuration)
        coordinator.start()
    }

    func openRegisterManipulation(products: [Product], contributors: [Contributor]) {
        let coordinator = RegisterManipulationCoordinator(with: configuration)
        coordinator.start(products: products, contributors: contributors)
    }

    func openAddProduct(products: [Product]) {
        let coordinator = RegisterProductsCoordinator(with: configuration)
        coordinator.start(products: products)
    }
}
