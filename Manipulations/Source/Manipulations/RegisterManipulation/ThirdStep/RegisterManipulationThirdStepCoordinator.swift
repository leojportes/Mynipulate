//
//  RegisterManipulationThirdStepCoordinator.swift
//  Manipulations
//
//  Created by Leonardo Portes on 01/03/23.
//

import Foundation

final class RegisterManipulationThirdStepCoordinator: BaseCoordinator {
    func start(
        _ firstStepModel: RegisterManipulationFirstStep,
        _ secondStepModel: RegisterManipulationSecondStep
    ) {
        let viewModel = RegisterManipulationThirdStepViewModel(coordinator: self)
        let controller = RegisterManipulationThirdStepController(
            firstStepModel,
            secondStepModel,
            viewModel: viewModel,
            coordinator: self
        )
        configuration.navigationController?.navigationBar.topItem?.backButtonTitle = ""
        configuration.navigationController?.navigationBar.tintColor = .blackHigh
        configuration.navigationController?.pushViewController(controller, animated: true)
    }

    func openConfirmRegisterManipulation(
        _ firstStepModel: RegisterManipulationFirstStep,
        _ secondStepModel: RegisterManipulationSecondStep,
        _ thirdStepModel: RegisterManipulationThirdStep
    ) {
        let coordinator = RegisterManipulationConfirmStepCoordinator(with: configuration)
        coordinator.start(firstStepModel, secondStepModel, thirdStepModel)
    }
}
