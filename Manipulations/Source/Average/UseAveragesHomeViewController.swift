//
//  UseAveragesHomeViewController.swift
//  Manipulations
//
//  Created by Leonardo Portes on 31/12/22.
//

import UIKit

final class UseAveragesHomeViewController: CoordinatedViewController {

    // MARK: - Private properties

    private var contributors: [Contributor] = []
    private var products: [Product] = []
    private let manipulations: [Manipulation]

    private lazy var rootView = UseAveragesHomeView(
        didTapByProductItem: weakify {
            $0.viewModel?.openAverageList(
                averageType: .byProduct,
                $0.products,
                [],
                $0.manipulations)
        },
        didTapByContributorsItem: weakify {
            $0.viewModel?.openAverageList(
                averageType: .byContributors,
                [],
                $0.contributors,
                $0.manipulations
            )
        }
    )

    private let viewModel: AverageViewModelProtocol?

    // MARK: - Init

    init(
        viewModel: AverageViewModelProtocol,
        coordinator: CoordinatorProtocol,
        manipulations: [Manipulation]
    ) {
        self.viewModel = viewModel
        self.manipulations = manipulations
        super.init(coordinator: coordinator)
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Médias de Aproveitamento"
        fetchItems()
    }

    override func loadView() {
        super.loadView()
        view = rootView
    }

    // MARK: - Private methods

    private func fetchItems() {
        viewModel?.input.viewDidLoad()
        viewModel?.output.products.bind() { [weak self] result in
            self?.products = result
        }
        viewModel?.output.contributors.bind() { [weak self] result in
            self?.contributors = result
        }
    }

}
