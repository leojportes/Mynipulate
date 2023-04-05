//
//  RegisterManipulationSecondStepViewController.swift
//  Manipulations
//
//  Created by Leonardo Portes on 28/02/23.
//

import UIKit

final class RegisterManipulationSecondStepViewController: CoordinatedViewController {
    
    private let firstStepModel: RegisterManipulationFirstStep
    private let viewModel: RegisterManipulationSecondStepViewModel

    private lazy var rootView = RegisterManipulationSecondStepView(
        showAlertAction: weakify { $0.showAlert($1) },
        didTapContinue: weakify { $0.viewModel.openRegisterManipulationThirdStep($0.firstStepModel, $1) }
    )

    // MARK: - Init
    init(
        _ firstStepModel: RegisterManipulationFirstStep,
        viewModel: RegisterManipulationSecondStepViewModel,
        coordinator: CoordinatorProtocol
    ) {
        self.firstStepModel = firstStepModel
        self.viewModel = viewModel
        super.init(coordinator: coordinator)
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
    private func showAlert(_ message: String) {
        self.showAlert(title: "Oops!", message: message)
    }
}
