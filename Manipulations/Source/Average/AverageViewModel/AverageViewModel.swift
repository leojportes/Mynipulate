//
//  AverageViewModel.swift
//  Manipulations
//
//  Created by Leonardo Portes on 22/01/23.
//

import UIKit

protocol AverageViewModelProtocol: AnyObject {
    var input: AverageViewModelInputProtocol { get }
    var output: AverageViewModelOutputProtocol { get }

    func openAverageList(averageType: UseAveragesType, _ products: [Product], _ contributors: [Contributor], _ manipulations: [Manipulation])

    func openManipulationList(for item: String)
}

// MARK: - Protocols
protocol AverageViewModelOutputProtocol {
    var products: Bindable<[Product]> { get }
    var contributors: Bindable<[Contributor]> { get }
}

protocol AverageViewModelInputProtocol {
    func viewDidLoad()
}

class AverageViewModel: AverageViewModelProtocol, AverageViewModelOutputProtocol {

    var input: AverageViewModelInputProtocol { self }
    var output: AverageViewModelOutputProtocol { self }

    var products: Bindable<[Product]> = .init([])
    var contributors: Bindable<[Contributor]> = .init([])

    // MARK: - Properties
    private var coordinator: UseAveragesCoordinator?
    private let service: AverageServiceProtocol

    // MARK: - Init
    init(service: AverageServiceProtocol = AverageService(), coordinator: UseAveragesCoordinator?) {
        self.coordinator = coordinator
        self.service = service
    }

    func getContributors() {
        service.getContributorList { result in
            DispatchQueue.main.async {
                self.contributors.value = result
            }
        }
    }

    private func getProductItems() {
        service.getProductList { result in
            DispatchQueue.main.async {
                self.products.value = result
            }
        }
    }

    // MARK: Routes
    func openAverageList(
        averageType: UseAveragesType,
        _ products: [Product] = [],
        _ contributors: [Contributor] = [],
        _ manipulations: [Manipulation]
    ) {
        coordinator?.openAverageList(
            averageType: averageType,
            products,
            contributors,
            manipulations
        )
    }

    func openManipulationList(for item: String) {

    }
}

extension AverageViewModel: AverageViewModelInputProtocol {
    func viewDidLoad() {
        getContributors()
        getProductItems()
    }
}

struct AverageModel {
    let useAveragesType: UseAveragesType
    let productName: String
    let date: String
    let contributor: String
    //    let grossWeight: String
    //    let cleanWeight: String
    //
    //    let contributorName: String

    private let manipulations: [Manipulation]

    var isProductAverage: Bool {
        useAveragesType == .byProduct
    }

    var title: String {
        isProductAverage
            ? ""
            : ""
    }

    func manipulationsFilteredForProduct() -> [Manipulation] {
        manipulations.filter { $0.product == productName }
    }

    func manipulationsFilteredForContributor() -> [Manipulation] {
        manipulations.filter { $0.responsibleName == contributor }
    }

    func manipulationsFilteredForDate() -> [Manipulation] {
        manipulations.filter { $0.date == date }
    }

    var productTotalAverage: String {
    //    manipulationsFiltered(for: <#T##String#>)
        ""
    }

    // MARK: - Init

    init(
        manipulations: [Manipulation],
        useAveragesType: UseAveragesType,
        date: String = "",
        product: String = "",
        contributor: String = ""
    ) {
        self.manipulations = manipulations
        self.useAveragesType = useAveragesType
        self.productName = product
        self.contributor = contributor
        self.date = date
    }
}
