//
//  ManipulationsCoordinator.swift
//  Manipulations
//
//  Created by Leonardo Portes on 25/01/23.
//

import Foundation
import UIKit

final class ManipulationsCoordinator: BaseCoordinator {
    func start(products: [Product], contributors: [Contributor]) {
        let viewModel = ManipulationsListViewModel(coordinator: self)
        let controller = ManipulationsListViewController(
            viewModel: viewModel,
            coordinator: self,
            products: products,
            contributors: contributors
        )
        configuration.navigationController?.navigationBar.topItem?.backButtonTitle = ""
        configuration.navigationController?.navigationBar.tintColor = .neutralHigh
        configuration.navigationController?.navigationBar.barTintColor = .white
//        if #available(iOS 15, *) {
//            let appearance = UINavigationBarAppearance()
//            appearance.configureWithOpaqueBackground()
//            appearance.backgroundColor = .purpleLight
//            configuration.navigationController?.navigationBar.standardAppearance = appearance;
//            configuration.navigationController?.navigationBar.scrollEdgeAppearance = configuration.navigationController?.navigationBar.standardAppearance
//        }
  
        configuration.navigationController?.pushViewController(controller, animated: true)
    }
}

extension ManipulationsCoordinator {

    // MARK: - Routes

    func openManipulationsList() {
        
    }

    func openManipulationDetail(_ item: Manipulation, products: [Product], contributors: [Contributor]) {
        let coordinator = ManipulationsDetailCoordinator(with: configuration)
        coordinator.start(item, products: products, contributors: contributors)
    }

    func openAverages() {
        
    }

    func openRegisterManipulation(products: [Product], contributors: [Contributor]) {
        let coordinator = RegisterManipulationCoordinator(with: configuration)
        coordinator.start(products: products, contributors: contributors)
    }
}
