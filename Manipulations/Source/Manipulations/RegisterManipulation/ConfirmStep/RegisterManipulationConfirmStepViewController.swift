//
//  RegisterManipulationConfirmStepViewController.swift
//  Manipulations
//
//  Created by Leonardo Portes on 01/03/23.
//

import UIKit

final class RegisterManipulationConfirmStepViewController: CoordinatedViewController {
    
    private let firstStepModel: RegisterManipulationFirstStep
    private let secondStepModel: RegisterManipulationSecondStep
    private let thirdStepModel: RegisterManipulationThirdStep
    
    private let viewModel: RegisterManipulationConfirmStepViewModel
    
    private var finalModel: Manipulation {
        Manipulation(
            emailFirebase: "leojportes@gmail.com",
            product: firstStepModel.productName,
            productType: firstStepModel.productType.iconTitle,
            date: firstStepModel.date,
            responsibleName: firstStepModel.responsible,
            supplier: firstStepModel.supply,
            grossWeight: secondStepModel.grossWeight,
            cleanWeight: secondStepModel.cleanWeight,
            thawedWeight: secondStepModel.thawedWeight,
            skinWeight: secondStepModel.skinWeight,
            cookedWeight: thirdStepModel.cookedWeight,
            headlessWeight: thirdStepModel.headlessWeight,
            discardWeight: thirdStepModel.discardWeight
        )
    }

    private lazy var rootView = RegisterManipulationConfirmStepView(
        model: finalModel,
        onConfirmTap: weakify { $0.registerManipulation($1) }
    )

    // MARK: - Init
    init(_ firstStepModel: RegisterManipulationFirstStep,
         _ secondStepModel: RegisterManipulationSecondStep,
         _ thirdStepModel: RegisterManipulationThirdStep,
         viewModel: RegisterManipulationConfirmStepViewModel,
         coordinator: CoordinatorProtocol
    ) {
        self.firstStepModel = firstStepModel
        self.secondStepModel = secondStepModel
        self.thirdStepModel = thirdStepModel
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
    private func showAlert() {
        self.showAlert(
            title: "Oops!",
            message: "Por favor, preencha os campos obrigatórios!"
        )
    }

    private func registerManipulation(_ model: Manipulation) {

        viewModel.registerManipulation(manipulation: model) { [ weak self ] result in
            if result {
                self?.rootView.registerButton.loadingIndicator(show: false)
                self?.showAlert(title: "", message: "Adicionado com sucesso!") { [weak self] in
                    self?.dismiss(animated: true)
                    self?.viewModel.pop()
                }
            } else {
                DispatchQueue.main.async {
                    self?.showAlert(title: "Ocorreu um erro", message: "Tente novamente mais tarde")
                    self?.rootView.registerButton.loadingIndicator(show: false)
                }
            }
        }
    }
}
