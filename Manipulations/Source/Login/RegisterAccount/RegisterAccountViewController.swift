//
//  RegisterAccountViewController.swift
//  Manipulations
//
//  Created by Leonardo Portes on 02/05/23.
//

import Foundation
import FirebaseAuth

class RegisterAccountViewController: CoordinatedViewController {

    private lazy var customView = RegisterAccountView()
    private let viewModel: RegisterAccountViewModelProtocol
    private var authUser : User? {
        Auth.auth().currentUser
    }

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
                    weakSelf.showAlert(title: "Oops!", message: descriptionError)
                }
            })
        }
    }

    private func accountCreatedSuccessfully() {
        if self.authUser != nil && Current.shared.isEmailVerified.not {
            self.authUser!.sendEmailVerification() { (error) in
                self.showAlert(
                    title: "Parabéns!",
                    message: "Conta criada com sucesso. \n Foi enviado para seu email um link de verificação. Após verificar, retorne ao app para efetuar o login. \n Verifique sua caixa de spam."
                ) {
                    self.viewModel.closed()
                }
            }
        }
    }

}
