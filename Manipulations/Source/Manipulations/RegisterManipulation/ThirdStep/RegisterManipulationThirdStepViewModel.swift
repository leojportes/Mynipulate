//
//  RegisterManipulationThirdStepViewModel.swift
//  Manipulations
//
//  Created by Leonardo Portes on 02/03/23.
//

import Foundation

protocol RegisterManipulationThirdStepViewModelProtocol: AnyObject {
    func openConfirmRegisterManipulation(
    _ firstStepModel: RegisterManipulationFirstStep,
    _ secondStepModel: RegisterManipulationSecondStep,
    _ thirdStepModel: RegisterManipulationThirdStep
    )
}

class RegisterManipulationThirdStepViewModel: RegisterManipulationThirdStepViewModelProtocol {

    // MARK: - Properties
    private var coordinator: RegisterManipulationThirdStepCoordinator?

    // MARK: - Init
    init(coordinator: RegisterManipulationThirdStepCoordinator?) {
        self.coordinator = coordinator
    }

    func openConfirmRegisterManipulation(
    _ firstStepModel: RegisterManipulationFirstStep,
    _ secondStepModel: RegisterManipulationSecondStep,
    _ thirdStepModel: RegisterManipulationThirdStep
    ) {
        coordinator?.openConfirmRegisterManipulation(firstStepModel, secondStepModel, thirdStepModel)
    }
}
