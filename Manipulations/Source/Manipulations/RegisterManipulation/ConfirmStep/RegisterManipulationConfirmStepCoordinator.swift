//
//  RegisterManipulationConfirmStepCoordinator.swift
//  Manipulations
//
//  Created by Leonardo Portes on 01/03/23.
//

import Foundation

final class RegisterManipulationConfirmStepCoordinator: BaseCoordinator {
    func start(
        _ firstStepModel: RegisterManipulationFirstStep,
        _ secondStepModel: RegisterManipulationSecondStep,
        _ thirdStepModel: RegisterManipulationThirdStep
    ) {
        let viewModel = RegisterManipulationConfirmStepViewModel(coordinator: self)
        let controller = RegisterManipulationConfirmStepViewController(
            firstStepModel,
            secondStepModel,
            thirdStepModel,
            viewModel: viewModel,
            coordinator: self
        )
        configuration.navigationController?.navigationBar.topItem?.backButtonTitle = ""
        configuration.navigationController?.navigationBar.tintColor = .blackHigh
        configuration.navigationController?.pushViewController(controller, animated: true)
    }

    func pop() {
        configuration.navigationController?.popToRootViewController(animated: true)
    }
}
