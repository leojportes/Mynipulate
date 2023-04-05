//
//  ManipulationsDetailViewController.swift
//  Manipulations
//
//  Created by Leonardo Portes on 25/01/23.
//

import UIKit

final class ManipulationsDetailViewController: CoordinatedViewController {
    private let item: Manipulation
    private let viewModel: ManipulationsDetailViewModel

    private lazy var rootView = ManipulationsDetailView(
        item: item,
        showAlertAction: weakify { $0.showAlert($1) },
        didTapEditAction: weakify { $0.openEditManipulation() },
        didTapDeleteAction: weakify { $0.deleteManipulation() }
    )

    // MARK: - Init
    init(
        item: Manipulation,
        coordinator: CoordinatorProtocol,
        viewModel: ManipulationsDetailViewModel
    ) {
        self.item = item
        self.viewModel = viewModel
        super.init(coordinator: coordinator)
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .back
    }

    override func loadView() {
        super.loadView()
        view = rootView
    }

    private func showAlert(_ type: String) {
        showAlert(
            title: "Oops!",
            message: "A função \(type) não está disponível no modo colaborador.\nEntre em Perfil para alterar o modo."
        )
    }

    private func openEditManipulation() {
        // let item = item
        viewModel.openRegisterManipulation()
    }

    private func deleteManipulation() {
        // let item = item
    }
}
