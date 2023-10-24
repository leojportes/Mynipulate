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
        didTapDeleteAction: weakify { $0.deleteManipulation($1) }
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
        title = "Detalhes da manipulação"
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

    private func deleteManipulation(_ manipulationId: String) {
        self.showDeleteAlert(message: "Deseja deletar esta manipulação?\n Esta ação é irreversível.", closedScreen: true) {
            self.viewModel.deleteManipulation(manipulationId) { message in
                DispatchQueue.main.async { [weak self] in
                    self?.showAlert(title: "", message: message) { [weak self] in
                        DispatchQueue.main.async { [weak self] in
                            self?.dismiss(animated: true) {
                                self?.navigationController?.popToRootViewController(animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
}
