//
//  ProductsViewController.swift
//  Manipulations
//
//  Created by Leonardo Portes on 06/02/23.
//

import UIKit

final class ProductsViewController: CoordinatedViewController {

    // MARK: - Private properties
    private let viewModel: ProductsViewModel
    private var products: [Product] = []

    private lazy var rootView = ProductsView(didTapDelete: weakify { $0.didTapDelete(product: $1) })

    // MARK: - Init
    init(viewModel: ProductsViewModel, coordinator: CoordinatorProtocol) {
        self.viewModel = viewModel
        super.init(coordinator: coordinator)
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Produtos"
        navigationItem.rightBarButtonItem = .init(
            image: UIImage(systemName: "plus"),
            style: .plain,
            target: self,
            action: #selector(didTapInsert)
        )
        navigationItem.rightBarButtonItem?.tintColor = .purpleLight
        getProducts()
    }

    override func viewWillAppear(_ animated: Bool) {
        getProducts()
    }

    private func getProducts() {
        viewModel.input.viewDidLoad()
        viewModel.output.products.bind() { [weak self] result in
            self?.rootView.products = result
            self?.products = result
        }
        reloadData()
    }

    private func didTapDelete(product: String) {
        self.showDeleteAlert(message: "Deseja deletar este produto?\n Esta ação é irreversível.", closedScreen: true) {
            self.viewModel.deleteProduct(product) { message in
                DispatchQueue.main.async { [weak self] in
                    self?.showAlert(title: "", message: message) { [weak self] in
                        self?.getProducts()
                        return self?.dismiss()
                    }
                }
            }
        }
    }

    override func loadView() {
        super.loadView()
        view = rootView
    }

    @objc
    private func didTapInsert() {
        viewModel.registerProduct(products: products)
    }

    private func reloadData() {
        self.rootView.tableView.reloadData()
    }

    private func dismiss() {
        self.dismiss(animated: true)
    }
}
