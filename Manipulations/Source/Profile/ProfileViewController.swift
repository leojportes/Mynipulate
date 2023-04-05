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
        getNumberOfContributors()
    }

    override func loadView() {
        super.loadView()
        view = rootView
    }

    // MARK: - Private methods
    private func didTapExitAccount() {
        print("EXIT ACCOUNT")
    }

    private func openContributor() {
        viewModel.openContributors()
    }

    private func didTapContributorModeSwitch(_ isOn: Bool) {
        MNUserDefaults.set(value: isOn, forKey: .contributorMode)
    }

    private func getNumberOfContributors() {
        viewModel.input.viewDidLoad()
        viewModel.output.numberOfContributors.bind() { [weak self] result in
            self?.rootView.setup(numberOfContributors: result.description)
        }
    }
    
}

