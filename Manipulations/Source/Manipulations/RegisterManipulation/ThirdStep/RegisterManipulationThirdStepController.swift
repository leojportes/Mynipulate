//
//  RegisterManipulationThirdStepController.swift
//  Manipulations
//
//  Created by Leonardo Portes on 01/03/23.
//

import UIKit

final class RegisterManipulationThirdStepController: CoordinatedViewController {
    
    private let firstStepModel: RegisterManipulationFirstStep
    private let secondStepModel: RegisterManipulationSecondStep
    private let viewModel: RegisterManipulationThirdStepViewModel

    private lazy var rootView = RegisterManipulationThirdStepView(
        showAlertAction: weakify { $0.showAlert() },
        didTapContinue: weakify {
            $0.viewModel.openConfirmRegisterManipulation($0.firstStepModel, $0.secondStepModel, $1)
        }
    )

    // MARK: - Init
    init(_ firstStepModel: RegisterManipulationFirstStep,
         _ secondStepModel: RegisterManipulationSecondStep,
         viewModel: RegisterManipulationThirdStepViewModel,
         coordinator: CoordinatorProtocol
    ) {
        self.firstStepModel = firstStepModel
        self.secondStepModel = secondStepModel
        self.viewModel = viewModel
        super.init(coordinator: coordinator)
        print(firstStepModel, secondStepModel)
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Cadastrar manipulação"
        hideKeyboardWhenTappedAround()
    }

    override func loadView() {
        super.loadView()
        view = rootView
    }

    // MARK: - Private methods
    private func showAlert() {
        self.showAlert(
            title: "Oops!",
            message: "Por favor, preencha os campos obrigatórios!"
        )
    }
}
