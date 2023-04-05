//
//  ContributorsView.swift
//  Manipulations
//
//  Created by Leonardo Portes on 08/02/23.
//

import UIKit

final class ContributorsView: UIView, ViewCodeContract {
    private let didTapDelete: (String) -> Void
    
    var contributors: [Contributor] = [] {
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
            ContributorsTableViewCell.self,
            forCellReuseIdentifier: ContributorsTableViewCell.identifier
        )
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
        return contributors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView
            .dequeueReusableCell(
                withIdentifier: ContributorsTableViewCell.identifier,
                for: indexPath
            ) as? ContributorsTableViewCell else { return UITableViewCell() }
        let item = contributors[indexPath.row]
        cell.bind(title: item.name, id: item.id)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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
