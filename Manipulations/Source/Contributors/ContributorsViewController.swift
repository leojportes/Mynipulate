//
//  ContributorsViewController.swift
//  Manipulations
//
//  Created by Leonardo Portes on 08/02/23.
//

import UIKit

final class ContributorsViewController: CoordinatedViewController {

    // MARK: - Private properties
    private let viewModel: ContributorsViewModel
    private var contributors: [Contributor] = []

    private lazy var rootView = ContributorsView(
        didTapDelete: weakify { $0.didTapDelete(contributor: $1) }
    )

    // MARK: - Init
    init(viewModel: ContributorsViewModel, coordinator: CoordinatorProtocol) {
        self.viewModel = viewModel
        super.init(coordinator: coordinator)
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Colaboradores"
        navigationItem.rightBarButtonItem = .init(
            image: UIImage(systemName: "plus"),
            style: .plain,
            target: self,
            action: #selector(didTapInsert)
        )
        navigationItem.rightBarButtonItem?.tintColor = .purpleLight
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getContributors()
    }

    override func loadView() {
        super.loadView()
        view = rootView
    }

    private func getContributors() {
        viewModel.input.viewDidLoad()
        viewModel.output.contributors.bind() { [weak self] result in
            self?.rootView.contributors = result
            self?.contributors = result
        }
        reloadData()
    }

    private func didTapDelete(contributor: String) {
        self.showDeleteAlert(message: "Deseja deletar este colaborador?\n Esta ação é irreversível.", closedScreen: true) {
            self.viewModel.deleteContributor(contributor) { message in
                DispatchQueue.main.async { [weak self] in
                    self?.showAlert(title: "", message: message) { [weak self] in
                        self?.getContributors()
                        return self?.dismiss()
                    }
                }
            }
        }
    }

    @objc
    private func didTapInsert() {
        viewModel.registerContributors(contributors: contributors)
    }

    private func reloadData() {
        self.rootView.tableView.reloadData()
    }

    private func dismiss() {
        self.dismiss(animated: true)
    }
}
