//
//  RegisterManipulationSecondStepCoordinator.swift
//  Manipulations
//
//  Created by Leonardo Portes on 28/02/23.
//

import Foundation

final class RegisterManipulationSecondStepCoordinator: BaseCoordinator {
    func start(_ model: RegisterManipulationFirstStep) {
        let viewModel = RegisterManipulationSecondStepViewModel(coordinator: self)
        let controller = RegisterManipulationSecondStepViewController(
            model,
            viewModel: viewModel,
            coordinator: self
        )
        configuration.navigationController?.navigationBar.topItem?.backButtonTitle = ""
        configuration.navigationController?.navigationBar.tintColor = .blackHigh
        configuration.navigationController?.pushViewController(controller, animated: true)
    }
    
    func openRegisterManipulationThirdStep(
        _ firstStepModel: RegisterManipulationFirstStep,
        _ secondStepModel: RegisterManipulationSecondStep
    ) {
        let coordinator = RegisterManipulationThirdStepCoordinator(with: configuration)
        coordinator.start(firstStepModel, secondStepModel)
    }
    
}
