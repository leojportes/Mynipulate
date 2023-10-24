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
    private let viewModel: AverageViewModelProtocol?

    // MARK: - View

    private lazy var rootView = UseAveragesHomeView(
        didTapByProductItem: weakify { $0.didTapItem(.byProduct) },
        didTapByContributorsItem: weakify { $0.didTapItem(.byContributors) },
        didTapTopItem: { item in print(item) }
    )

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
        setTopContributors()
        setTopProducts()
    }

    private func setTopContributors() {
        let groupedManipulations = Dictionary(grouping: manipulations) {
            GroupedForContributorsManipulationsV2(responsibleName: $0.responsibleName)
        }
        var mergedManipulations: [Manipulation] = []

        for (_, manipulations) in groupedManipulations {
            var mergedManipulation = manipulations[0]
            for i in 1..<manipulations.count {
                mergedManipulation.grossWeight += manipulations[i].grossWeight
                mergedManipulation.cleanWeight += manipulations[i].cleanWeight
            }
            mergedManipulations.append(mergedManipulation)
        }
        rootView.topManipulationsByContributors = mergedManipulations
            .sorted { $0.avarage > $1.avarage }
            .prefix(3)
            .mapToVoid()
    }

    private func setTopProducts() {
        let groupedManipulationsByProduct = Dictionary(grouping: manipulations) {
            GroupedManipulations(product: $0.product)
        }

        var mergedManipulationsByProduct: [Manipulation] = []

        for (_, manipulations) in groupedManipulationsByProduct {
            var mergedManipulation = manipulations[0]
            for i in 1..<manipulations.count {
                mergedManipulation.grossWeight += manipulations[i].grossWeight
                mergedManipulation.cleanWeight += manipulations[i].cleanWeight
            }
            mergedManipulationsByProduct.append(mergedManipulation)
        }

        rootView.topManipulationsByProduct = mergedManipulationsByProduct
            .sorted { $0.avarage > $1.avarage }
            .prefix(3)
            .mapToVoid()
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

    private func didTapItem(_ type: UseAveragesType) {
        viewModel?.openAverageList(
            averageType: type,
            products,
            contributors,
            manipulations
        )
    }

}

struct GroupedForContributorsManipulationsV2: Hashable {
    let responsibleName: String
}

struct GroupedManipulations: Hashable {
    let product: String
}
