//
//  RegisterAccountViewController.swift
//  Manipulations
//
//  Created by Leonardo Portes on 02/05/23.
//

import Foundation

class RegisterAccountViewController: CoordinatedViewController {

    private lazy var customView = RegisterAccountView()
    private let viewModel: RegisterAccountViewModelProtocol

    init(
        viewModel: RegisterAccountViewModelProtocol,
        coordinator: CoordinatorProtocol
    ) {
        self.viewModel = viewModel
        super.init(coordinator: coordinator)
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        createAccount()
        self.hideKeyboardWhenTappedAround()
    }


    override func loadView() {
        super.loadView()
        self.view = customView
    }

    private func createAccount() {
        customView.createAccount = weakify { weakSelf, email, password in
            weakSelf.viewModel.createAccount(email, password, resultCreateUser: { result, descriptionError  in
                weakSelf.customView.createAccountButton.loadingIndicator(show: false)
                if result {
                    weakSelf.accountCreatedSuccessfully()
                } else {
                    weakSelf.showAlert(title: "Atenção", message: descriptionError)
                }
            })
        }
        customView.closedView = weakify { $0.viewModel.closed()}
    }

    private func accountCreatedSuccessfully() {
        showAlert(title: "Parabéns!", message: "Conta criada com sucesso.") {
            self.viewModel.closed()
        }
    }


}
