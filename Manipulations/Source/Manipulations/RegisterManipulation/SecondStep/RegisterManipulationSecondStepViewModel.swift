//
//  RegisterManipulationSecondStepViewModel.swift
//  Manipulations
//
//  Created by Leonardo Portes on 01/03/23.
//

import Foundation

protocol RegisterManipulationSecondStepViewModelProtocol: AnyObject {
    func openRegisterManipulationThirdStep(
        _ firstStepModel: RegisterManipulationFirstStep,
        _ secondStepModel: RegisterManipulationSecondStep
    )
}

class RegisterManipulationSecondStepViewModel: RegisterManipulationSecondStepViewModelProtocol {

    // MARK: - Properties
    private var coordinator: RegisterManipulationSecondStepCoordinator?

    // MARK: - Init
    init(coordinator: RegisterManipulationSecondStepCoordinator?) {
        self.coordinator = coordinator
    }

    func openRegisterManipulationThirdStep(
        _ firstStepModel: RegisterManipulationFirstStep,
        _ secondStepModel: RegisterManipulationSecondStep
    ) {
        coordinator?.openRegisterManipulationThirdStep(firstStepModel, secondStepModel)
    }

}
