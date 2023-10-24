//
//  UserOnboardingViewController.swift
//  Manipulations
//
//  Created by Leonardo Portes on 05/04/23.
//

import UIKit
import FirebaseAuth

final class UserOnboardingViewController: CoordinatedViewController {

    // MARK: - Properties
    private lazy var customView = UserOnboardingView(
        addUserOnboarding: weakify { $0.addUserOnboarding(model: $1) },
        alertEmptyField: weakify { $0.alertEmptyField() }
    )
    private let viewModel: UserOnboardingViewModelProtocol

    init(viewModel: UserOnboardingViewModelProtocol, coordinator: CoordinatorProtocol){
        self.viewModel = viewModel
        super.init(coordinator: coordinator)
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
    }

    override func loadView() {
        super.loadView()
        self.view = customView
    }
}

extension UserOnboardingViewController {
    func addUserOnboarding(model: CreateUserModel) {
        customView.continueButton.loadingIndicator(show: true)
        viewModel.createUser(userModel: model) { [weak self] onSuccess in
            DispatchQueue.main.async {
                if onSuccess {
                    guard let email = Auth.auth().currentUser?.email else { return }
                    MNUserDefaults.set(value: true, forString: email)
                    self?.viewModel.navigateToHome()

                } else {
                    self?.showAlert(title: "Ocorreu um erro", message: "Tente novamente.")
                }
                self?.customView.continueButton.loadingIndicator(show: true)
            }
        }
    }

    func alertEmptyField() {
        customView.continueButton.loadingIndicator(show: false)
        showAlert(
            title: "Atenção",
            message: "Preencha todos os campos."
        )
    }
}
