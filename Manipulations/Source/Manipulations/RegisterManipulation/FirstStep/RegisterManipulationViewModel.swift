//
//  RegisterManipulationViewModel.swift
//  Manipulations
//
//  Created by Leonardo Portes on 28/02/23.
//

import Foundation

protocol RegisterManipulationViewModelProtocol: AnyObject {
    func openRegisterManipulationSecondStep(_ model: RegisterManipulationFirstStep)
}

class RegisterManipulationViewModel: RegisterManipulationViewModelProtocol {

    // MARK: - Properties
    private var coordinator: RegisterManipulationCoordinator?

    // MARK: - Init
    init(coordinator: RegisterManipulationCoordinator?) {
        self.coordinator = coordinator
    }

 
    func openRegisterManipulationSecondStep(_ model: RegisterManipulationFirstStep) {
        coordinator?.openRegisterManipulationSecondStep(model)
    }
   

}
