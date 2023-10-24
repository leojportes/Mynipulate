//
//  UseAveragesHomeView.swift
//  Manipulations
//
//  Created by Leonardo Portes on 31/12/22.
//

import UIKit

final class UseAveragesHomeView: UIView {

    var topManipulationsByContributors: [Manipulation] = [] {
        didSet {
            topContributorsCollectionView.reloadData()
        }
    }
    
    var topManipulationsByProduct: [Manipulation] = [] {
        didSet {
            topProductsCollectionView.reloadData()
        }
    }

    private var didTapTopItem: (String) -> Void

    private var didTapByProductItem: Action
    private var didTapByContributorsItem: Action

    // MARK: - View code

    private let baseView = UIView() .. {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .back
        $0.roundCorners(cornerRadius: 15, typeCorners: [.topLeft, .topRight])
    }

    private lazy var titleLabel = MNLabel(
        text: "Escolha o tipo de média",
        font: .boldSystemFont(ofSize: 20),
        textColor: .neutralHigh
    )

    private lazy var topContributorsLabel = MNLabel(
        text: "Top Colaboradores",
        font: .boldSystemFont(ofSize: 20),
        textColor: .neutralHigh
    )

    private lazy var topProductsLabel = MNLabel(
        text: "Top Produtos",
        font: .boldSystemFont(ofSize: 20),
        textColor: .neutralHigh
    )
    
    private lazy var byProductItemView = MenuItemView(
        onTap: weakify { $0.didTapByProductItem() }
    ) .. {
        $0.addShadow()
        $0.set(title: "Por produto", message: "Médias das manipulações de cada produto.")
    }
    
    private lazy var byContributorsItemView = MenuItemView(
        onTap: weakify { $0.didTapByContributorsItem() }
    ) .. {
        $0.addShadow()
        $0.set(title: "Por colaborador", message: "Médias das manipulações de cada colaborador.")
    }

    private lazy var topProductsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSize(width: 220, height: 135)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.isUserInteractionEnabled = true
        collection.register(AvaragesCollectionCell.self, forCellWithReuseIdentifier: AvaragesCollectionCell.identifier)
        collection.contentInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 5)
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = .clear
        collection.showsHorizontalScrollIndicator = false
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()

    private lazy var topContributorsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSize(width: 220, height: 135)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.isUserInteractionEnabled = true
        collection.register(AvaragesCollectionCell.self, forCellWithReuseIdentifier: AvaragesCollectionCell.identifier)
        collection.contentInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 5)
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = .clear
        collection.showsHorizontalScrollIndicator = false
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()

    // MARK: - Init
    init(
        didTapByProductItem: @escaping Action,
        didTapByContributorsItem: @escaping Action,
        didTapTopItem: @escaping (String) -> Void
    ) {
        self.didTapByProductItem = didTapByProductItem
        self.didTapByContributorsItem = didTapByContributorsItem
        self.didTapTopItem = didTapTopItem
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - View code contract
extension UseAveragesHomeView: ViewCodeContract {

    func setupHierarchy() {
        addSubview(baseView)
        addSubview(titleLabel)
        baseView.addSubview(byProductItemView)
        baseView.addSubview(byContributorsItemView)
        baseView.addSubview(topProductsCollectionView)
        baseView.addSubview(topContributorsCollectionView)
        baseView.addSubview(topContributorsLabel)
        baseView.addSubview(topProductsLabel)
    }
    
    func setupConstraints() {
        titleLabel
            .topAnchor(in: self, padding: .xLarge3)
            .leftAnchor(in: self, padding: .medium)
            .rightAnchor(in: self)

        baseView
            .topAnchor(in: titleLabel, attribute: .bottom)
            .leftAnchor(in: self)
            .rightAnchor(in: self)
            .bottomAnchor(in: self, layoutOption: .useMargins)
    
        byProductItemView
            .topAnchor(in: baseView, padding: .medium)
            .leftAnchor(in: baseView, padding: .medium)
            .rightAnchor(in: baseView, padding: .medium)
        
        byContributorsItemView
            .topAnchor(in: byProductItemView, attribute: .bottom, padding: .medium)
            .leftAnchor(in: baseView, padding: .medium)
            .rightAnchor(in: baseView, padding: .medium)

        topProductsLabel
            .topAnchor(in: byContributorsItemView, attribute: .bottom, padding: .xLarge3)
            .leftAnchor(in: baseView, padding: .medium)
            .rightAnchor(in: baseView)

        topProductsCollectionView
            .topAnchor(in: topProductsLabel, attribute: .bottom)
            .leftAnchor(in: baseView, padding: .xSmall)
            .rightAnchor(in: baseView)
            .heightAnchor(150)

        topContributorsLabel
            .topAnchor(in: topProductsCollectionView, attribute: .bottom, padding: .medium)
            .leftAnchor(in: baseView, padding: .medium)
            .rightAnchor(in: baseView)

        topContributorsCollectionView
            .topAnchor(in: topContributorsLabel, attribute: .bottom)
            .leftAnchor(in: baseView, padding: .xSmall)
            .rightAnchor(in: baseView)
            .heightAnchor(150)
    }
   
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .back
    }
}

// MARK: - MenuCollectionView Delegate & Data source
extension UseAveragesHomeView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == topContributorsCollectionView {
            return topManipulationsByContributors.count
        }
        return topManipulationsByProduct.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == topContributorsCollectionView {
            guard let cell = collectionView
                .dequeueReusableCell(withReuseIdentifier: AvaragesCollectionCell.identifier, for: indexPath) as? AvaragesCollectionCell else {
                return UICollectionViewCell()
            }
            let item = topManipulationsByContributors[indexPath.row]
            cell.bind(
                title: item.responsibleName,
                image: UIImage(systemName: "person"),
                average: item.avarageDescription,
                averageDisclamer: "De aproveitamento"
            )
            return cell
        } else {
            guard let cell = collectionView
                .dequeueReusableCell(withReuseIdentifier: AvaragesCollectionCell.identifier, for: indexPath) as? AvaragesCollectionCell else {
                return UICollectionViewCell()
            }
            let item = topManipulationsByProduct[indexPath.row]

            cell.bind(
                title: item.product,
                image: productTypeIcon(ProductType(rawValue: item.productType) ?? .fish),
                average: item.avarageDescription,
                averageDisclamer: "Aproveitado"
            )
            return cell
        }

    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == topContributorsCollectionView {
            let item = topManipulationsByContributors[indexPath.row].responsibleName
            didTapTopItem(item)
        } else {
            let item = topManipulationsByProduct[indexPath.row].product
            didTapTopItem(item)
        }
    }

    func productTypeIcon(_ productType: ProductType) -> UIImage? {
        switch productType {
        case .seafood: return UIImage(named: "seafood")
        case .meat: return UIImage(named: "meat")
        case .fish: return UIImage(named: "fish")
        case .choiceLegend: return nil
        }
    }
}

final class AvaragesCollectionCell: UICollectionViewCell, ViewCodeContract {

    // MARK: - Private properties
    private var parkingSpaceNum: String = .empty

    // MARK: - Properties
    static let identifier = "AvaragesCollectionCell"

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.cornerRadius = 5
        contentView.roundCorners(cornerRadius: 10)
        contentView.backgroundColor = .white
        contentView.addGradientColor(baseView: contentView, maxX: 100.0, maxY: 150.0)
        self.addShadow()
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Viewcode

    private lazy var titleLabel = MNLabel(
        font: .boldSystemFont(ofSize: 18),
        textColor: .neutralLow
    ) .. {
        $0.numberOfLines = 2
        $0.textAlignment = .left
    }

    private lazy var iconView = UIImageView() .. {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(systemName: "person.circle.fill")
        $0.setImageColor(color: .neutral)
    }

    private lazy var averageLabel = MNLabel(
        text: "Título",
        font: .boldSystemFont(ofSize: 35),
        textColor: .neutralLow
    ) .. {
        $0.textAlignment = .left
    }

    private lazy var averageDisclamerLabel = MNLabel(
        text: "Aproveitado",
        font: .boldSystemFont(ofSize: .small),
        textColor: .neutralLow
    ) .. {
        $0.textAlignment = .left
    }

    // MARK: - Setup viewcode
    func setupHierarchy() {
        addSubview(titleLabel)
        addSubview(iconView)
        addSubview(averageLabel)
        addSubview(averageDisclamerLabel)
    }

    func setupConstraints() {
        iconView
            .topAnchor(in: contentView, padding: .medium)
            .leftAnchor(in: contentView, padding: .medium)
            .heightAnchor(30)
            .widthAnchor(30)

        titleLabel
            .topAnchor(in: contentView, padding: .medium)
            .leftAnchor(in: iconView, attribute: .right, padding: .xSmall)
            .centerY(in: iconView)
            .rightAnchor(in: contentView, padding: .medium)

        averageLabel
            .topAnchor(in: iconView, attribute: .bottom, padding: .small)
            .leftAnchor(in: contentView, padding: .medium)
            .rightAnchor(in: contentView, padding: .medium)

        averageDisclamerLabel
            .topAnchor(in: averageLabel, attribute: .bottom)
            .leftAnchor(in: contentView, padding: .medium)
            .rightAnchor(in: contentView, padding: .medium)
    }

    func bind(title: String, image: UIImage?, average: String, averageDisclamer: String) {
        titleLabel.text = title
        iconView.image = image
        iconView.setImageColor(color: .neutral)
        averageLabel.text = average
        averageDisclamerLabel.text = averageDisclamer
        if average == "100%" {
            averageLabel.textColor = .systemGreen
        }
    }

    override func prepareForReuse() {
        titleLabel.text = nil
        iconView.image = nil
        averageDisclamerLabel.text = nil
        averageLabel.text = nil
    }
}
