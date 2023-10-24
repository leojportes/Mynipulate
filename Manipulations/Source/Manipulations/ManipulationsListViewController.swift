//
//  ManipulationsListViewController.swift
//  Manipulations
//
//  Created by Leonardo Portes on 25/01/23.
//

import UIKit

final class ManipulationsListViewController: CoordinatedViewController {
    
    // MARK: - Private properties
    private let viewModel: ManipulationsListViewModel
    private lazy var dateFiltered: String = "Todos"
    private lazy var productFiltered: String = "Todos"
    private let products: [Product]
    private let contributors: [Contributor]
    private var manipulations: [Manipulation] = []

    private lazy var rootView = ManipulationsListView(
        didSelectManipulation: weakify { $0.openManipulation($1) },
        didFilterProductByDate: weakify { $0.didFilterProduct($1) },
        didFilterCustomDate: weakify {
            $0.dateFiltered = $1
            $0.didSelectFilterDatePicker($1)
        },
        didFilterProduct: weakify {
            $0.productFiltered = $1
            $0.filterByProduct($1)
        },
        products: products
    )

    private func filterByProduct(_ product: String) {
        rootView.manipulations = filteredManipulations(manipulations, dateFiltered, product)
        rootView.tableView.reloadData()
    }

    // MARK: - Init
    init(
        viewModel: ManipulationsListViewModel,
        coordinator: CoordinatorProtocol,
        products: [Product],
        contributors: [Contributor]
    ) {
        self.viewModel = viewModel
        self.products = products
        self.contributors = contributors
        super.init(coordinator: coordinator)
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Manipulações"
        navigationItem.rightBarButtonItem = .init(
            image: UIImage(systemName: "plus"),
            style: .plain,
            target: self,
            action: #selector(didTapInsert)
        )
        navigationItem.rightBarButtonItem?.tintColor = .purpleLight
        getProducts()
    }

    override func loadView() {
        super.loadView()
        view = rootView
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        rootView.tableView.reloadData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        rootView.tableView.reloadData()
    }

    // MARK: - Private methods
    private func openManipulation(_ item: Manipulation) {
        viewModel.openManipulationDetail(item, products: products, contributors: contributors)
    }

    @objc
    private func didTapInsert() {
        viewModel.openRegisterManipulation(products: products, contributors: contributors)
    }

    private func getProducts() {
        viewModel.input.viewDidLoad()
        viewModel.output.manipulations.bind() { [weak self] result in
            self?.rootView.manipulations = result
            self?.manipulations = result
        }
    }
    
    private func didFilterProduct(_ item: ButtonFilterType) {
        
        switch item {
        case .all:
            dateFiltered = item.rawValue
            rootView.manipulations = filteredManipulations(manipulations, item.rawValue, productFiltered)
        case .custom: print("custom")
        default:
            dateFiltered = item.rawValue
            rootView.manipulations = filteredManipulations(manipulations, item.rawValue, productFiltered)
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

    private func didSelectFilterDatePicker(_ date: String) {
        let all = "Todos"
        let manipulationsFiltered = manipulations.filter { $0.date == date }
        
        if productFiltered == all {
            self.rootView.manipulations = manipulationsFiltered
        } else {
            self.rootView.manipulations = manipulations.filter { $0.date == date && $0.product == productFiltered }
        }
     
    }
}
