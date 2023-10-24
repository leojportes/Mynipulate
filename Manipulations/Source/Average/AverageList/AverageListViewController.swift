//
//  AverageListViewController.swift
//  Manipulations
//
//  Created by Leonardo Portes on 22/01/23.
//

import UIKit

final class AverageListViewController: CoordinatedViewController {

    private lazy var dateFiltered: String = "Todos"
    private lazy var productFiltered: String = "Todos"

    private var averageType: UseAveragesType
    private let contributors: [Contributor]
    private let products: [Product]
    private var manipulations: [Manipulation]

    private lazy var rootView = AverageListView(
        averageType: averageType,
        products: products,
        contributors: contributors,
        manipulations: manipulations,
        didFilterProductByDate: weakify { $0.didFilterProduct($1) },
        didFilterCustomDate: weakify { $0.didSelectFilterDatePicker($1) }
    )

    // MARK: - Init

    init(
        averageType: UseAveragesType,
        coordinator: CoordinatorProtocol,
        _ products: [Product],
        _ contributors: [Contributor],
        _ manipulations: [Manipulation]
    ) {
        self.averageType = averageType
        self.products = products
        self.contributors = contributors
        self.manipulations = manipulations
        super.init(coordinator: coordinator)
        configureInitialList()
    }

    private func configureInitialList() {
        didFilterProduct(.all)
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Médias de Aproveitamento"
    }

    override func loadView() {
        super.loadView()
        view = rootView
    }

    private func didFilterProduct(_ item: ButtonFilterType) {
        switch item {
        case .all:
            dateFiltered = item.rawValue
            rootView.manipulations = averageType == .byProduct
            ? filteredManipulations(manipulations, item.rawValue, productFiltered)
            : filteredManipulationsForContributor(manipulations, item.rawValue)

        case .custom: print("custom")

        default:
            dateFiltered = item.rawValue
            rootView.manipulations = averageType == .byProduct
            ? filteredManipulations(manipulations, item.rawValue, productFiltered)
            : filteredManipulationsForContributor(manipulations, item.rawValue)
        }
    }

    private func filteredManipulations(
        _ manipulations: [Manipulation],
        _ date: String? = nil,
        _ productFiltered: String? = nil
    ) -> [Manipulation] {
        let all = "Todos"
        let hasFilterAndNotAll = date != nil && date != all
        var mergedByDateManipulations: [Manipulation] = []
        var mergedAllManipulations: [Manipulation] = []

        let groupedManipulationsByDate = Dictionary(grouping: manipulations) {
            GroupedProductByDate(product: $0.product, date: String($0.date.suffix(4)))
        }

        let groupedAllManipulations = Dictionary(grouping: manipulations) {
            GroupedProduct(product: $0.product)
        }

        for (_, manipulations) in groupedManipulationsByDate {
            var mergedManipulation = manipulations[0]
            for i in 1..<manipulations.count {
                mergedManipulation.grossWeight += manipulations[i].grossWeight
                mergedManipulation.cleanWeight += manipulations[i].cleanWeight
            }
            mergedByDateManipulations.append(mergedManipulation)
        }

        for (_, manipulations) in groupedAllManipulations {
            var mergedManipulation = manipulations[0]
            for i in 1..<manipulations.count {
                mergedManipulation.grossWeight += manipulations[i].grossWeight
                mergedManipulation.cleanWeight += manipulations[i].cleanWeight
            }
            mergedAllManipulations.append(
                .init(
                    product: mergedManipulation.product,
                    date: "",
                    responsibleName: mergedManipulation.responsibleName,
                    grossWeight: mergedManipulation.grossWeight,
                    cleanWeight: mergedManipulation.cleanWeight
                )
            )
        }

        if date == all {
            return mergedAllManipulations.sorted(by: { $0.product < $1.product })
        }

        if hasFilterAndNotAll {
            return mergedByDateManipulations
                .filter({ $0.date.contains(date.orEmpty) })
                .sorted(by: { $0.product < $1.product })
        }

        return mergedByDateManipulations
            .filter({ $0.date.contains(date.orEmpty) })
            .sorted(by: { $0.product < $1.product })
    }

    private func filteredManipulationsForContributor(
        _ manipulations: [Manipulation],
        _ date: String? = nil
    ) -> [Manipulation] {
        let all = "Todos"
        let hasFilterAndNotAll = date != nil && date != all
        var mergedByDateManipulations: [Manipulation] = []
        var mergedAllManipulations: [Manipulation] = []

        let groupedManipulations = Dictionary(grouping: manipulations) {
            GroupedByDateContributorsManipulations(responsibleName: $0.responsibleName, date: String($0.date.suffix(4)))
        }

        let groupedAllManipulations = Dictionary(grouping: manipulations) {
            GroupedByContributorsManipulations(responsibleName: $0.responsibleName)
        }

        for (_, manipulations) in groupedManipulations {
            var mergedManipulation = manipulations[0]
            for i in 1..<manipulations.count {
                mergedManipulation.grossWeight += manipulations[i].grossWeight
                mergedManipulation.cleanWeight += manipulations[i].cleanWeight
            }
            mergedByDateManipulations.append(mergedManipulation)
        }

        for (_, manipulations) in groupedAllManipulations {
            var mergedManipulation = manipulations[0]

            for i in 1..<manipulations.count {
                mergedManipulation.grossWeight += manipulations[i].grossWeight
                mergedManipulation.cleanWeight += manipulations[i].cleanWeight
            }
            mergedAllManipulations.append(
                .init(
                    product: mergedManipulation.product,
                    date: "",
                    responsibleName: mergedManipulation.responsibleName,
                    grossWeight: mergedManipulation.grossWeight,
                    cleanWeight: mergedManipulation.cleanWeight
                )
            )
        }

        if date == all {
            return mergedAllManipulations.sorted(by: { $0.responsibleName < $1.responsibleName })
        }

        if hasFilterAndNotAll {
            return mergedByDateManipulations
                .filter({ $0.date.contains(date.orEmpty) })
                .sorted(by: { $0.responsibleName < $1.responsibleName })
        }

        return mergedByDateManipulations
            .filter({ $0.date.contains(date.orEmpty) })
            .sorted(by: { $0.responsibleName < $1.responsibleName })
    }

    private func didSelectFilterDatePicker(_ date: String) {
        dateFiltered = date
        let all = "Todos"
        let manipulationsFiltered = manipulations.filter { $0.date == date }

        self.rootView.manipulations = productFiltered == all
        ? manipulationsFiltered
        : manipulations.filter { $0.date == date && $0.product == productFiltered }
    }
}

struct GroupedProductByDate: Hashable {
    let product: String
    let date: String
}

struct GroupedProduct: Hashable {
    let product: String
}

struct GroupedByContributorsManipulations: Hashable {
    let responsibleName: String
}

struct GroupedByDateContributorsManipulations: Hashable {
    let responsibleName: String
    let date: String
}
