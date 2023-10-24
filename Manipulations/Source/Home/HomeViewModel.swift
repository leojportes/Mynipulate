//
//  HomeViewModel.swift
//  Manipulations
//
//  Created by Leonardo Portes on 29/12/22.
//

import UIKit

protocol HomeViewModelProtocol: AnyObject {
    var input: HomeViewModelInputProtocol { get }
    var output: HomeViewModelOutputProtocol { get }
    var isContributorsMode: Bool { get }

    func didTapMenuItem(for item: MenuCollectionType, products: [Product], contributors: [Contributor], manipulations: [Manipulation])
    func openProfile()
    func openRegisterManipulation(products: [Product], contributors: [Contributor])
    func openAddProduct(products: [Product])
}

// MARK: - Protocols
protocol HomeViewModelOutputProtocol {
    var products: Bindable<[Product]> { get }
    var contributors: Bindable<[Contributor]> { get }
    var manipulations: Bindable<[Manipulation]> { get }
}

protocol HomeViewModelInputProtocol {
    func viewDidLoad()
}

class HomeViewModel: HomeViewModelProtocol, HomeViewModelOutputProtocol {
    
    // MARK: - Properties to bind
    var products: Bindable<[Product]> = .init([])
    var contributors: Bindable<[Contributor]> = .init([])
    var manipulations: Bindable<[Manipulation]> = .init([])

    private let service: HomeServiceProtocol

    var input: HomeViewModelInputProtocol { self }
    var output: HomeViewModelOutputProtocol { self }

    // MARK: - Properties
    private var coordinator: HomeCoordinator?

    // MARK: - Init
    init(service: HomeServiceProtocol = HomeService(), coordinator: HomeCoordinator?) {
        self.coordinator = coordinator
        self.service = service
    }

    var isContributorsMode: Bool {
        Current.shared.isContributorMode
    }

    private func fetchProductItems() {
        service.getProductList { result in
            DispatchQueue.main.async {
                self.products.value = result
            }
        }
    }

    private func fetchContributors() {
        service.getContributorList { result in
            DispatchQueue.main.async {
                self.contributors.value = result
            }
        }
    }

    func fetchManipulationItems() {
        service.getManipulationList { result in
            DispatchQueue.main.async {
                self.manipulations.value = result
            }
        }
    }

    // MARK: Routes

    func didTapMenuItem(
        for item: MenuCollectionType,
        products: [Product],
        contributors: [Contributor],
        manipulations: [Manipulation]
    ) {
        coordinator?.didTapMenuItem(item, products: products, contributors: contributors, manipulations: manipulations)
    }

    func openProfile() {
        coordinator?.openProfile()
    }

    func openRegisterManipulation(products: [Product], contributors: [Contributor]) {
        coordinator?.openRegisterManipulation(products: products, contributors: contributors)
    }
    
    func openAddProduct(products: [Product]) {
        coordinator?.openAddProduct(products: products)
    }

}

extension HomeViewModel: HomeViewModelInputProtocol {
    func viewDidLoad() {
        fetchProductItems()
        fetchContributors()
        fetchManipulationItems()
    }
}
