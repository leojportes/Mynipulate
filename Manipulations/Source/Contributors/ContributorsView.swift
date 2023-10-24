//
//  ContributorsView.swift
//  Manipulations
//
//  Created by Leonardo Portes on 08/02/23.
//

import UIKit

final class ContributorsView: UIView, ViewCodeContract {
    private let didTapDelete: (String) -> Void
    private let showAlert: () -> Void
    
    var contributors: [Contributor] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    // MARK: - Init
    init(didTapDelete: @escaping (String) -> Void, showAlert: @escaping () -> Void) {
        self.didTapDelete = didTapDelete
        self.showAlert = showAlert
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
            ContributorsTableViewCell.self,
            forCellReuseIdentifier: ContributorsTableViewCell.identifier
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

extension ContributorsView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  contributors.isEmpty ? 1 : contributors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if contributors.isEmpty && indexPath.row == 0 {
            guard let cell = tableView
                .dequeueReusableCell(
                    withIdentifier: EmptyListViewCell.identifier,
                    for: indexPath
                ) as? EmptyListViewCell else { return UITableViewCell() }
            cell.separatorInset = .zero
            cell.bind(title: "Nenhum colaborador cadastrado!", subtitle: "Cadastre um novo colaborador no ícone +")
            return cell
        } else {
            guard let cell = tableView
                .dequeueReusableCell(
                    withIdentifier: ContributorsTableViewCell.identifier,
                    for: indexPath
                ) as? ContributorsTableViewCell else { return UITableViewCell() }
            let item = contributors[indexPath.row]
            cell.bind(title: item.name, id: item.id)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        contributors.isEmpty && indexPath.row == 0 ? 0 : 70
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if Current.shared.isContributorMode { return showAlert() }
        if editingStyle == .delete {
            didTapDelete(contributors[indexPath.row]._id)
          //  products.remove(at: indexPath.row)
          //  tableView.deleteRows(at: [indexPath], with: .fade)
            if contributors.count == 0 {
                UIViewController.findCurrentController()?.navigationController?.popViewController(animated: true)
            }
        }
    }

}
