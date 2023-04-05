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
        viewModel?.didTapMenuItem(
            for: item,
            products: products,
            contributors: contributors,
            manipulations: manipulations
        )
    }

}
