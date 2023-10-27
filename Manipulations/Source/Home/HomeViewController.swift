//
//  HomeViewController.swift
//  Manipulations
//
//  Created by Leonardo Portes on 29/12/22.
//

import UIKit

final class HomeViewController: CoordinatedViewController {
    
    private var products: [Product] = []
    private var contributors: [Contributor] = []
    private var manipulations: [Manipulation] = []

    private lazy var rootView = HomeView(
        didTapMenuItem: weakify { $0.didTapMenuItem($1) },
        didTapAddManipulation: weakify {
            $0.viewModel?.openRegisterManipulation(products: $0.products, contributors: $0.contributors)
        },
        didTapAddProduct: weakify { $0.viewModel?.openAddProduct(products: $0.products) },
        didTapProfileView: weakify { $0.viewModel?.openProfile() },
        isContributorMode: viewModel?.isContributorsMode ?? true
    )

    private let viewModel: HomeViewModelProtocol?

    // MARK: - Init
    init(viewModel: HomeViewModelProtocol, coordinator: CoordinatorProtocol) {
        self.viewModel = viewModel
        super.init(coordinator: coordinator)
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    private func getProducts() {
        viewModel?.input.viewDidLoad()
        viewModel?.output.products.bind() { [weak self] result in
            self?.products = result
        }
    }

    private func getContributors() {
        viewModel?.input.viewDidLoad()
        viewModel?.output.contributors.bind() { [weak self] result in
            self?.contributors = result
        }
    }

    private func getManipulations() {
        viewModel?.input.viewDidLoad()
        viewModel?.output.manipulations.bind() { [weak self] result in
            self?.manipulations = result
            self?.rootView.chartData = self?.retrieveChartDataBy(manipulations: result) ?? ([], [])
        }
    }

    private func retrieveChartDataBy(manipulations: [Manipulation]) -> (dataPoints: [String], values: [Double]) {
        let grapthManipulations = mapToGraphModel(manipulations: manipulations)
        let dataPoints = retrieveYearsFromManipulations(manipulations: grapthManipulations)
        let values = retrieveAveragesByYearsOf(manipulations: grapthManipulations)
        return (dataPoints, values)
    }

    private func retrieveYearsFromManipulations(manipulations: [GraphManipulation]) -> [String] {
        var months: [String] = []
        let sortedManupulations = manipulations.sorted(by: { $0.date < $1.date })
        for manipulation in sortedManupulations {
            let month = manipulation.date.string(dateStyle: .small)
            if months.contains(month).not {
                months.append(month)
            }
        }
        let lastYear = sortedManupulations
            .last?
            .date
            .adding(component: .year, value: 1)
            .string(dateStyle: .small) ?? ""
        
        months.append(lastYear)
        return months
    }

    private func retrieveAveragesByYearsOf(manipulations: [GraphManipulation]) -> [Double] {
        let sortedManupulations = manipulations.sorted(by: { $0.date < $1.date })
        var mergedByDateManipulations: [GraphManipulation] = []
        var avaragesByYear: [Double] = []

        let groupedManipulations = Dictionary(grouping: sortedManupulations) {
            GroupedManipulationsByDate(date: $0.date.string(dateStyle: .small))
        }

        for (_, manipulations) in groupedManipulations {
            var mergedManipulation = manipulations[0]
            for i in 1..<manipulations.count {
                mergedManipulation.grossWeight += manipulations[i].grossWeight
                mergedManipulation.cleanWeight += manipulations[i].cleanWeight
            }
            mergedByDateManipulations.append(mergedManipulation)
        }

        mergedByDateManipulations
            .sorted(by: { $0.date < $1.date })
//            .sorted(by: { getMonthNumberFromDateStr($0.date) < getMonthNumberFromDateStr($1.date) })
            .forEach { item in
                avaragesByYear.append(item.avarage)
            }

        avaragesByYear.append(0.0)

        return roundDoublesToTwoDecimalPlaces(avaragesByYear)
    }

    private func roundDoublesToTwoDecimalPlaces(_ numbers: [Double]) -> [Double] {
        let roundedNumbers = numbers.map { value in
            return (value * 100).rounded() / 100
        }
        return roundedNumbers
    }

    private func mapToGraphModel(manipulations: [Manipulation]) -> [GraphManipulation] {
        manipulations.map {
            .init(
                date: .init(dateString: $0.date) ?? STNDate(),
                grossWeight: $0.grossWeight,
                cleanWeight: $0.cleanWeight
            )
        }
    }
    
    override func loadView() {
        super.loadView()
        view = rootView
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        getProducts()
        getContributors()
        getManipulations()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    // MARK: - Routes
    func didTapMenuItem(_ item: MenuCollectionType) {
        if viewModel?.isContributorsMode == true && item == .averages {
            return MNToast.show(message: "Indisponível no modo colaborador.\nAltere em Perfil.", in: self)
        }

        if item == .manipulations && products.isEmpty && manipulations.isEmpty {
            return MNToast.show(message: "Nenhum produto cadastrado!\nCadastre em Produtos", in: self)
        }

        if item == .manipulations && contributors.isEmpty && manipulations.isEmpty {
            return MNToast.show(message: "Nenhum colaborador cadastrado!\nCadastre em Colaboradores", in: self)
        }

        if item == .averages && manipulations.isEmpty {
            return MNToast.show(message: "Nenhuma manipulação cadastrada para obter média de aproveitamento!\nCadastre em Manipulações", in: self)
        }

        viewModel?.didTapMenuItem(
            for: item,
            products: products,
            contributors: contributors,
            manipulations: manipulations
        )
    }

}

struct GroupedManipulationsByDate: Hashable {
    let date: String
}

struct GraphManipulation {
    let date: STNDate
    var grossWeight: Double
    var cleanWeight: Double

    var avarage: Double {
        (cleanWeight / grossWeight) * 100
    }
}
