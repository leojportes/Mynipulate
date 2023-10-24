//
//  ProfileViewController.swift
//  Manipulations
//
//  Created by Leonardo Portes on 09/02/23.
//

import UIKit

final class ProfileViewController: CoordinatedViewController {

    // MARK: - Private properties
    private let viewModel: ProfileViewModel

    private lazy var rootView = ProfileView(
        didTapExitAccountClosure: weakify { $0.didTapExitAccount() },
        didTapContributorClosure: weakify { $0.openContributor() },
        didTapContributorModeSwitch: weakify { $0.didTapContributorModeSwitch($1) }
    )

    // MARK: - Init
    init(viewModel: ProfileViewModel, coordinator: CoordinatorProtocol) {
        self.viewModel = viewModel
        super.init(coordinator: coordinator)
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Perfil"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getViewData()
    }

    override func loadView() {
        super.loadView()
        view = rootView
    }

    // MARK: - Private methods
    private func didTapExitAccount() {
        viewModel.signOut { [weak self] result in
            result
                ? self?.showAlertToLogout()
                : self?.showAlert(
                    title: "Ocorreu um erro",
                    message: "Tente novamente mais tarde"
                )
        }
    }

    private func showAlertToLogout() {
        showAlert(
            title: "Atenção!",
            message: "Você realmente deseja sair da sua conta?",
            leftButtonTitle: "Cancelar",
            rightButtonTitle: "Sair"
        ) {
            self.viewModel.logout()
        }
    }

    private func openContributor() {
        viewModel.openContributors()
    }

    private func didTapContributorModeSwitch(_ isOn: Bool) {
        showAlertWithTextField(
            okCompletion: weakify {
                $0.viewModel.authLogin($1) { [weak self] onSuccess, error in
                    onSuccess
                        ? self?.setSwitch(isOn: isOn)
                        : self?.showAlert(title: "Atenção", message: error)
                }
            },
            cancelCompletion: weakify {
                $0.rootView.contributorModeView.switchView.isOn.toggle()
            }
        )
    }

    private func setSwitch(isOn: Bool) {
        MNUserDefaults.set(value: isOn, forKey: .contributorMode)
        viewModel.logout()
    }

    private func getViewData() {
        viewModel.input.viewDidLoad()
        viewModel.output.numberOfContributors.bind() { [weak self] result in
            let user = Current.shared.user
            self?.rootView.setup(
                model: .init(
                    companyName: user.companyName,
                    numberOfContributors: result.description,
                    mananger: user.manangerName,
                    documentNumber: user.document.format(mask: .brazilianDocument) ?? user.document
                )
            )
        }
    }
}
