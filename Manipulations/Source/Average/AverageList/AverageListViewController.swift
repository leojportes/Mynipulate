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
    private lazy var contributorFiltered: String = "Todos"

    private var averageType: UseAveragesType
    private let contributors: [Contributor]
    private let products: [Product]
    private let manipulations: [Manipulation]

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
        let hasFilterAndNotAll = productFiltered != nil && date != nil && productFiltered != all && date != all
        let hasProductFilterAndNotAll = productFiltered != nil && productFiltered != all
        let AllProductFilterAndHasSomeFilterDate = productFiltered == all && date != nil

        if productFiltered == all && date == all {
            return manipulations
        }

        if hasFilterAndNotAll {
            return manipulations.filter({ $0.date.contains(date.orEmpty) && $0.product == productFiltered })
        }

        if hasProductFilterAndNotAll {
            return manipulations.filter({ $0.product == productFiltered })
        }

        if AllProductFilterAndHasSomeFilterDate {
           return manipulations.filter({ $0.date.contains(date.orEmpty) })
        }

        return manipulations.filter({ $0.date.contains(date.orEmpty) })
    }

    private func filteredManipulationsForContributor(
            _ manipulations: [Manipulation],
            _ date: String? = nil
    ) -> [Manipulation] {
        let all = "Todos"
        let hasFilterAndNotAll = date != nil && date != all
        let dateIsNotNil = date != nil

        if date == all {
            return manipulations
        }

        if hasFilterAndNotAll {

            let item = manipulations.filter { $0.responsibleName == $0.responsibleName && $0.date.contains(date.orEmpty) }

            return manipulations.filter({ $0.date.contains(date.orEmpty) })

        }

        return manipulations.filter({ $0.date.contains(date.orEmpty) })
    }

    private func didSelectFilterDatePicker(_ date: String) {
        dateFiltered = date
        let all = "Todos"
        let manipulationsFiltered = manipulations.filter { $0.date == date }

        if productFiltered == all {
            self.rootView.manipulations = manipulationsFiltered
        } else {
            self.rootView.manipulations = manipulations.filter { $0.date == date && $0.product == productFiltered }
        }

    }
}

extension Sequence {
    func grouped<T: Equatable>(by block: (Element) throws -> T) rethrows -> [[Element]] {
        return try reduce(into: []) { result, element in
            if let lastElement = result.last?.last, try block(lastElement) == block(element) {
                result[result.index(before: result.endIndex)].append(element)
            } else {
                result.append([element])
            }
        }
    }
}
