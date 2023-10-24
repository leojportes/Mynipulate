//
//  RegisterProductsViewController.swift
//  Manipulations
//
//  Created by Leonardo Portes on 07/02/23.
//

import UIKit

final class RegisterProductsViewController: CoordinatedViewController {

    // MARK: - Private properties
    private let viewModel: RegisterProductsViewModel
    private let products: [Product]

    private lazy var rootView = RegisterProductsView(
        showAlertAction: weakify { $0.showAlert() },
        didTapRegister: weakify { $0.didTapRegister(name: $1, type: $2) }
    )
    
    // MARK: - Init
    init(viewModel: RegisterProductsViewModel, coordinator: CoordinatorProtocol, products: [Product]) {
        self.products = products
        self.viewModel = viewModel
        super.init(coordinator: coordinator)
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Cadastrar Produto"
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

    private func didTapRegister(name: String, type: ProductType) {
        if productIsAlreadyRegistered(name) {
            self.rootView.registerButton.loadingIndicator(show: false)
            return self.showAlert(
                title: "Oops!",
                message: "Este produto já existe.\nPor favor, cadastre outro produto."
            )
        }
        viewModel.registerProduct(
            product: RegisterProduct(
                emailFirebase: Current.shared.email,
                name: name,
                type: type.iconTitle
            )
        ) { [weak self] result in
            guard let self = self else {return}
            if result {
                self.rootView.registerButton.loadingIndicator(show: false)
                self.showAlert(title: "", message: "Adicionado com sucesso!") {
                    self.viewModel.pop()
                }
            } else {
                DispatchQueue.main.async {
                    self.showAlert(title: "Ocorreu um erro", message: "Tente novamente mais tarde")
                    self.rootView.registerButton.loadingIndicator(show: false)
                }
            }
        }
    }

    private func productIsAlreadyRegistered(_ name: String) -> Bool {
        products.contains(where: { $0.name == name })
    }

}
