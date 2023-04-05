//
//  AverageListView.swift
//  Manipulations
//
//  Created by Leonardo Portes on 22/01/23.
//

import UIKit

final class AverageListView: UIView {
    
    private let averageType: UseAveragesType
    private let contributors: [Contributor]
    private let products: [Product]

    var manipulations: [Manipulation] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    private let didFilterProductByDate: (ButtonFilterType) -> Void
    private let didFilterCustomDate: (String) -> Void

    var items: [String] = []

    private lazy var titleLabel = MNLabel(font: .boldSystemFont(ofSize: .xLarge))

    private lazy var headerView = UIView() .. {
        let frame = UIScreen.main.bounds.width
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.heightAnchor(150)
        $0.widthAnchor(frame)
    }

    private lazy var dateFilterView = FilterSegmentedControl(
        didSelectIndexClosure: weakify { $0.didFilterProductByDate($1) },
        didSelectDateClosure: weakify { $0.didFilterCustomDate($1) }
    )

    private(set) lazy var tableView = UITableView() .. {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.delegate = self
        $0.dataSource = self
        $0.backgroundColor = .clear
        $0.separatorColor = .clear
        $0.register(
            AverageByProductTableViewCell.self,
            forCellReuseIdentifier: AverageByProductTableViewCell.identifier
        )
        $0.register(
            AverageByCollaboratorTableViewCell.self,
            forCellReuseIdentifier: AverageByCollaboratorTableViewCell.identifier
        )
    }
    
    init(
        averageType: UseAveragesType,
        products: [Product],
        contributors: [Contributor],
        manipulations: [Manipulation],
        didFilterProductByDate: @escaping (ButtonFilterType) -> Void,
        didFilterCustomDate: @escaping (String) -> Void
    ) {
        self.didFilterProductByDate = didFilterProductByDate
        self.didFilterCustomDate = didFilterCustomDate
        self.averageType = averageType
        self.contributors = contributors
        self.products = products
        self.manipulations = manipulations

        items = averageType == .byProduct
            ? products
                .uniques(by: \.name)
                .compactMap { $0.name }
            : contributors
                .uniques(by: \.name)
                .compactMap { $0.name }

        items.insert("Todos", at: 0)
        super.init(frame: .zero)
        backgroundColor = .white
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension AverageListView: ViewCodeContract, UITableViewDelegate, UITableViewDataSource {

    func setupHierarchy() {
        addSubview(tableView)
        headerView.addSubview(titleLabel)
        headerView.addSubview(dateFilterView)
    }

    func setupConstraints() {

        titleLabel
            .topAnchor(in: headerView, padding: .large)
            .leftAnchor(in: headerView, padding: .medium)
            .heightAnchor(30)

        dateFilterView
            .topAnchor(in: titleLabel, attribute: .bottom, padding: .large)
            .leftAnchor(in: headerView, padding: .medium)
            .rightAnchor(in: headerView)
            .heightAnchor(35)

        tableView.pin(toEdgesOf: self, padding: .top(.large))
    }

    func setupConfiguration() {

        titleLabel.text = averageType == .byProduct
            ? "Por produto"
            : "Por colaborador"
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        manipulations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = manipulations[indexPath.row]
        if averageType == .byProduct {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AverageByProductTableViewCell.identifier, for: indexPath) as? AverageByProductTableViewCell else { return UITableViewCell() }

            cell.bind(
                productTitle: item.product,
                dateRange: item.date,
                averagePorcent: item.avarage,
                grossWeight: item.grossWeight,
                cleanWeight: item.cleanWeight
            )
            return cell
        }

        guard let cell = tableView.dequeueReusableCell(withIdentifier: AverageByCollaboratorTableViewCell.identifier, for: indexPath) as? AverageByCollaboratorTableViewCell else { return UITableViewCell() }

        cell.bind(
            contributor: item.responsibleName,
            dateRange: item.date,
            averagePorcent: item.avarage,
            productName: item.product
        )

        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        100
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        averageType == .byProduct ? 190 : 155
    }

}
