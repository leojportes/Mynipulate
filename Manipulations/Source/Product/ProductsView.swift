//
//  ProductsView.swift
//  Manipulations
//
//  Created by Leonardo Portes on 06/02/23.
//

import Foundation
import UIKit

final class ProductsView: UIView, ViewCodeContract {
    private let didTapDelete: (String) -> Void
    
    var products: [Product] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    // MARK: - Init
    init(didTapDelete: @escaping (String) -> Void) {
        self.didTapDelete = didTapDelete
        super.init(frame: .zero)
        setupView()
        backgroundColor = .back
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private(set) lazy var tableView = UITableView() .. {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.delegate = self
        $0.dataSource = self
        $0.backgroundColor = .back
        $0.separatorColor = .opaqueSeparator
        $0.register(
            ProductsTableViewCell.self,
            forCellReuseIdentifier: ProductsTableViewCell.identifier
        )
        $0.register(EmptyListViewCell.self, forCellReuseIdentifier: EmptyListViewCell.identifier)
    }

    // MARK: - Methods
    func setupHierarchy() {
        addSubview(tableView)
    }
    
    func setupConstraints() {
        tableView
            .pin(toEdgesOf: self)
    }
    
}

extension ProductsView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  products.isEmpty ? 1 : products.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if products.isEmpty && indexPath.row == 0 {
            guard let cell = tableView
                .dequeueReusableCell(
                    withIdentifier: EmptyListViewCell.identifier,
                    for: indexPath
                ) as? EmptyListViewCell else { return UITableViewCell() }
            cell.separatorInset = .zero
            cell.bind(title: "Nenhum produto cadastrado!", subtitle: "Cadastre um novo produto no ícone +")
            return cell
        } else {
            guard let cell = tableView
                .dequeueReusableCell(
                    withIdentifier: ProductsTableViewCell.identifier,
                    for: indexPath
                ) as? ProductsTableViewCell else { return UITableViewCell() }
            let item = products[indexPath.row]
            
            cell.bind(title: item.name, type: item.type)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        products.isEmpty && indexPath.row == 0 ? 0 : 70
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
   
        if editingStyle == .delete {
            didTapDelete(products[indexPath.row]._id)
            if products.count == 0 {
                UIViewController.findCurrentController()?.navigationController?.popViewController(animated: true)
            }
        }
    }

}
