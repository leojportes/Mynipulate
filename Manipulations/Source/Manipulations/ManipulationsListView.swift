//
//  ManipulationsListView.swift
//  Manipulations
//
//  Created by Leonardo Portes on 25/01/23.
//

import UIKit

final class ManipulationsListView: UIView {
    
    private let didSelectManipulation: (Manipulation) -> Void
    private let didFilterProductByDate: (ButtonFilterType) -> Void
    private let didFilterCustomDate: (String) -> Void
    private let didFilterProduct: (String) -> Void
    
    var manipulations: [Manipulation] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var items: [String] = []

    // MARK: - View code

    private lazy var baseView = UIView() .. {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .white
    }
    
    private lazy var dateFilterView = FilterSegmentedControl(
        didSelectIndexClosure: weakify { $0.didFilterProductByDate($1) },
        didSelectDateClosure: weakify { $0.didFilterCustomDate($1) }
    )

    private lazy var productsFilterView = ItemsSegmentedControl(
        didSelectIndexClosure: weakify { $0.didFilterProduct($1) },
        items: items
    )
    
    private(set) lazy var tableView = UITableView() .. {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.delegate = self
        $0.dataSource = self
        $0.backgroundColor = .clear
        $0.separatorColor = .clear
        $0.register(
            ManipulationsTableViewCell.self,
            forCellReuseIdentifier: ManipulationsTableViewCell.identifier
        )
        $0.register(
            EmptyListViewCell.self,
            forCellReuseIdentifier: EmptyListViewCell.identifier
        )
    }

    private lazy var separatorView = UIView() .. {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .opaqueSeparator
        $0.isHidden = true
        $0.heightAnchor(1)
    }

    // MARK: - Init
    init(
        didSelectManipulation: @escaping (Manipulation) -> Void,
        didFilterProductByDate: @escaping (ButtonFilterType) -> Void,
        didFilterCustomDate: @escaping (String) -> Void,
        didFilterProduct: @escaping (String) -> Void,
        products: [Product]
    ) {
        self.didSelectManipulation = didSelectManipulation
        self.didFilterProductByDate = didFilterProductByDate
        self.didFilterCustomDate = didFilterCustomDate
        self.didFilterProduct = didFilterProduct
        items = products
            .uniques(by: \.name)
            .compactMap { $0.name }
    
        items.insert("Todos", at: 0)
        
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - View code contract
extension ManipulationsListView: ViewCodeContract, UITableViewDelegate, UITableViewDataSource {

    func setupHierarchy() {
        addSubview(baseView)
        baseView.addSubview(tableView)
        baseView.addSubview(dateFilterView)
        baseView.addSubview(productsFilterView)
        baseView.addSubview(separatorView)
    }

    func setupConstraints() {
        baseView
            .topAnchor(in: self)
            .leftAnchor(in: self)
            .rightAnchor(in: self)
            .bottomAnchor(in: self, layoutOption: .useMargins)
        
        productsFilterView
            .topAnchor(in: baseView, padding: .medium)
            .leftAnchor(in: baseView, padding: .medium)
            .rightAnchor(in: baseView)
            .heightAnchor(35)
        
        dateFilterView
            .topAnchor(in: productsFilterView, attribute: .bottom, padding: .xSmall3)
            .leftAnchor(in: baseView, padding: .medium)
            .rightAnchor(in: baseView)
            .heightAnchor(35)

        separatorView
            .bottomAnchor(in: dateFilterView, attribute: .bottom, padding: -.xSmall)
            .leftAnchor(in: baseView)
            .rightAnchor(in: baseView)

        tableView
            .topAnchor(in: self, padding: .xLarge5 + 40)
            .leftAnchor(in: self)
            .rightAnchor(in: self)
            .bottomAnchor(in: self)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .back
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if manipulations.isEmpty { return 1 }
        return manipulations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if manipulations.isEmpty {
            let cell = tableView.dequeueReusableCell(withIdentifier: EmptyListViewCell.identifier, for: indexPath) as? EmptyListViewCell
            cell?.isUserInteractionEnabled = false
            return cell ?? UITableViewCell()
        } else {
            guard let cell = tableView
                .dequeueReusableCell(
                    withIdentifier: ManipulationsTableViewCell.identifier,
                    for: indexPath
                ) as? ManipulationsTableViewCell else { return UITableViewCell() }

            let item = manipulations[indexPath.row]

            cell.bind(
                productTitle: item.product,
                dateRange: item.date,
                averagePorcent: item.avarage,
                responsible: item.responsibleName
            )

            return cell
        }
       
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        140
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = manipulations[indexPath.row]
        self.didSelectManipulation(item)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetY = scrollView.contentOffset.y
        
        if contentOffsetY > 10 {
            separatorView.isHidden = false
        } else {
            separatorView.isHidden = true
        }
    }

}

final class ItemsSegmentedControl: UIView, ViewCodeContract {

    private var didSelectIndexClosure: (String) -> Void?
    private let titleItems: [String]
    
    var segmentedControlButtons: [UIButton] = []
    
    var currentIndexFilter: ButtonFilterType = .all {
        didSet {
            if currentIndexFilter == .all {
                handleSegmentedControlButtons()
            }
        }
    }
    
    // MARK: - Init
    init(
        didSelectIndexClosure: @escaping (String) -> Void,
        items: [String]
    ) {
        self.didSelectIndexClosure = didSelectIndexClosure
        self.titleItems = items
        super.init(frame: .zero)
        makeItems()
        segmentedControlButtons[0].backgroundColor = .neutral
        translatesAutoresizingMaskIntoConstraints = false
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var container: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: segmentedControlButtons)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.contentSize = CGSize(width: .zero, height: 30)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()

    private lazy var datePicker: UIDatePicker = {
        let date = UIDatePicker()
        date.datePickerMode = .date
        date.locale = Locale(identifier: "pt-BR")
        date.calendar = Calendar(identifier: .gregorian)
        date.timeZone = TimeZone(identifier: "pt-BR")
        date.translatesAutoresizingMaskIntoConstraints = false
        return date
    }()

    func setupHierarchy() {
        addSubview(container)
        container.addSubview(scrollView)
        scrollView.addSubview(stackView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: topAnchor),
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor),
            container.heightAnchor.constraint(equalToConstant: 30),

            scrollView.topAnchor.constraint(equalTo: container.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            scrollView.heightAnchor.constraint(equalToConstant: 30),

            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    func setupConfiguration() {
        segmentedControlButtons.forEach {
            $0.addTarget(
                self,
                action: #selector(handleSegmentedControlButtons(sender:)),
                for: .touchUpInside
            )
        }
    }

    @objc
    func handleSegmentedControlButtons(sender: UIButton? = nil) {
        for button in segmentedControlButtons {
            if button == sender {
                button.backgroundColor = .neutral
                let title = button.titleLabel?.text ?? .empty
                self.didSelectIndexClosure(title)
            } else {
                button.backgroundColor = UIColor.init(white: 0.1, alpha: 0.1)
            }
        }
    }

    private func makeItems() {
        titleItems.forEach {
            segmentedControlButtons.append(SegmentedControlButton(title: $0))
        }
    }
}
