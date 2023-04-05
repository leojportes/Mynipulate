//
//  RegisterManipulationCoordinator.swift
//  Manipulations
//
//  Created by Leonardo Portes on 28/02/23.
//

import Foundation

final class RegisterManipulationCoordinator: BaseCoordinator {
    func start(products: [Product], contributors: [Contributor]) {
        let viewModel = RegisterManipulationViewModel(coordinator: self)
        let controller = RegisterManipulationViewController(
            viewModel: viewModel,
            coordinator: self,
            products: products,
            contributors: contributors
        )
        configuration.navigationController?.navigationBar.topItem?.backButtonTitle = ""
        configuration.navigationController?.navigationBar.tintColor = .blackHigh
        
        configuration.navigationController?.pushViewController(controller, animated: true)
    }

    func openRegisterManipulationSecondStep(_ model: RegisterManipulationFirstStep) {
        let coordinator = RegisterManipulationSecondStepCoordinator(with: configuration)
        coordinator.start(model)
    }
    
}
