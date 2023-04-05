//
//  RegisterManipulationViewController.swift
//  Manipulations
//
//  Created by Leonardo Portes on 28/02/23.
//

import UIKit

final class RegisterManipulationViewController: CoordinatedViewController {

    // MARK: - Private properties

    private let viewModel: RegisterManipulationViewModel
    private let products: [Product]
    private let contributors: [Contributor]

    private lazy var rootView = RegisterManipulationView(
        showAlertAction: weakify { $0.showAlert() },
        didTapContinue: weakify { $0.viewModel.openRegisterManipulationSecondStep($1) },
        contributors: contributors,
        products: products
    )

    // MARK: - Init

    init(
        viewModel: RegisterManipulationViewModel,
        coordinator: CoordinatorProtocol,
        products: [Product],
        contributors: [Contributor]
    ) {
        self.viewModel = viewModel
        self.products = products
        self.contributors = contributors
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
            message: "Por favor, preencha todos os campos!"
        )
    }
}
