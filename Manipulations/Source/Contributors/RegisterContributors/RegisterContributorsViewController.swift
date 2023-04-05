//
//  RegisterContributorsViewController.swift
//  Manipulations
//
//  Created by Leonardo Portes on 15/02/23.
//

import UIKit

final class RegisterContributorsViewController: CoordinatedViewController {

    // MARK: - Private properties
    private let viewModel: RegisterContributorsViewModel
    private let contributors: [Contributor]

    private lazy var rootView = RegisterContributorsView(
        showAlertAction: { },
        didTapRegister: weakify { $0.registerContributor($1) }
    )

    // MARK: - Init
    init(
        viewModel: RegisterContributorsViewModel,
        coordinator: CoordinatorProtocol,
        contributors: [Contributor]
    ) {
        self.viewModel = viewModel
        self.contributors = contributors
        super.init(coordinator: coordinator)
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Cadastrar colaborador"
        hideKeyboardWhenTappedAround()
    }

    private func registerContributor(_ model: RegisterContributor) {
        if contributorIsAlreadyRegistered(model.name) {
            self.rootView.registerButton.loadingIndicator(show: false)
            return self.showAlert(
                title: "Oops!",
                message: "Este colaborador já existe.\nPor favor, cadastre outro produto."
            )
        }
        viewModel.registerContributor(contributor: model) { [weak self] result in
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

    
    private func contributorIsAlreadyRegistered(_ name: String) -> Bool {
        contributors.contains(where: {
            $0.name.lowercased().nonAlphanumericsRemoved ==
            name.lowercased().nonAlphanumericsRemoved
        })
    }


    override func loadView() {
        super.loadView()
        view = rootView
    }

}
