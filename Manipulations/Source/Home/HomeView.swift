//
//  HomeView.swift
//  Manipulations
//
//  Created by Leonardo Portes on 29/12/22.
//

import UIKit

public enum MenuCollectionType: String {
    case manipulations = "Manipulações"
    case products = "Produtos"
    case contributors = "Colaboradores"
    case averages = "Médias"
    case discarts = "Descartes"
    case profile = "Perfil"
}

struct MenuItems {
    let title: String
    let icon: UIImage
}

final class HomeView: UIView {

    // MARK: - Private properties
    private let didTapItem: (MenuCollectionType) -> Void?
    private let didTapProfileView: Action
    private let didTapAddManipulation: Action
    private let didTapAddProduct: Action
    private let isContributorMode: Bool

    private let items: [MenuItems] = [
        .init(title: "Manipulações", icon: .icon(for: .manipulations)),
        .init(title: "Produtos", icon: UIImage(systemName: "shippingbox") ?? .icon(for: .product)),
        .init(title: "Colaboradores", icon: .icon(for: .employees)),
        .init(title: "Médias", icon: .icon(for: .averages)),
        .init(title: "Descartes", icon: .icon(for: .discarts)),
        .init(title: "Perfil", icon: UIImage(systemName: "person") ?? .actions)
    ]

    // MARK: - View code

    private lazy var profileView = ProfileHeaderView(
        onTap: weakify { $0.didTapProfileView() }
    ) .. { $0.set(company: "Mirante da Ilha Restaurante", document: "00.323.323/0001-84") }

    private let baseView = UIView() .. {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .back
        $0.roundCorners(cornerRadius: 15, typeCorners: [.topLeft, .topRight])
    }

    private lazy var addManipulationMenuItem = MenuItemView(
        onTap: weakify { $0.didTapAddManipulation() }
    ) .. {
        $0.addShadow()
        $0.set(title: "Adicionar manipulação", message: "Adicione uma manipulação de forma simples.")
        $0.layer.cornerRadius = .medium
    }

    private lazy var addProductMenuItem = MenuItemView(
        onTap: weakify { $0.didTapAddProduct() }
    ) .. {
        $0.addShadow()
        $0.set(title: "Adicionar produto", message: "Adicione um produto do seu estoque.")
        $0.layer.cornerRadius = .medium
    }

    private lazy var eventsMenuItem = MenuItemView(
        onTap: weakify { $0.didTapAddProduct() }
    ) .. {
        $0.addShadow()
        $0.set(title: "Eventos", message: "Obtenha métricas dos seus eventos.", isBlock: true)
        $0.layer.cornerRadius = .medium
    }

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSize(width: 110, height: 85)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.isUserInteractionEnabled = true
        collection.register(MenuCollectionCell.self, forCellWithReuseIdentifier: MenuCollectionCell.identifier)
        collection.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 0, right: 5)
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = .clear
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()

    // MARK: - Init

    init(
        didTapMenuItem: @escaping (MenuCollectionType) -> Void,
        didTapAddManipulation: @escaping Action,
        didTapAddProduct: @escaping Action,
        didTapProfileView: @escaping Action,
        isContributorMode: Bool
    ) {
        didTapItem = didTapMenuItem
        self.didTapAddManipulation = didTapAddManipulation
        self.didTapAddProduct = didTapAddProduct
        self.didTapProfileView = didTapProfileView
        self.isContributorMode = isContributorMode
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var alertView = MNAlertView(
        title: "Modo colaborador ativo",
        message: "Algumas funções estão indisponíveis.\nAcesse Perfil para desativar o modo colaborador.",
        onTap: { }
    ) .. {
        $0.heightAnchor(80)
        $0.isHidden = isContributorMode.not
    }

}

// MARK: - View code contract
extension HomeView: ViewCodeContract {
    func setupHierarchy() {
        addSubview(profileView)
        addSubview(baseView)
        addSubview(collectionView)
        addSubview(addManipulationMenuItem)
        addSubview(addProductMenuItem)
        addSubview(eventsMenuItem)
        addSubview(alertView)
    }
    
    func setupConstraints() {
        profileView
            .topAnchor(in: self, padding: 20)
            .leftAnchor(in: self)
            .rightAnchor(in: self)
            .heightAnchor(65)

        baseView
            .topAnchor(in: profileView, attribute: .bottom, padding: 30)
            .leftAnchor(in: self)
            .rightAnchor(in: self)
            .bottomAnchor(in: self, layoutOption: .useMargins)
        
        alertView
            .topAnchor(in: baseView, padding: .xLarge2)
            .leftAnchor(in: baseView, padding: .medium)
            .rightAnchor(in: baseView, padding: .medium)
        
        collectionView
            .topAnchor(in: baseView, padding: isContributorMode ? 130 : .xLarge2)
            .leftAnchor(in: baseView, padding: .xSmall)
            .rightAnchor(in: baseView, padding: .medium)
            .heightAnchor(200)
    
        addManipulationMenuItem
            .topAnchor(in: collectionView, attribute: .bottom, padding: .medium)
            .leftAnchor(in: self, padding: .medium)
            .rightAnchor(in: self, padding: .medium)

        addProductMenuItem
            .topAnchor(in: addManipulationMenuItem, attribute: .bottom, padding: .medium)
            .leftAnchor(in: self, padding: .medium)
            .rightAnchor(in: self, padding: .medium)
        
        eventsMenuItem
            .topAnchor(in: addProductMenuItem, attribute: .bottom, padding: .medium)
            .leftAnchor(in: self, padding: .medium)
            .rightAnchor(in: self, padding: .medium)
    }
   
    override func layoutSubviews() {
        super.layoutSubviews()
        self.addGradientColor()
    }
}

// MARK: - MenuCollectionView Delegate & Data source
extension HomeView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: MenuCollectionCell.identifier, for: indexPath) as? MenuCollectionCell else {
            return UICollectionViewCell()
        }

        let item = items[indexPath.row]

        if isContributorMode {
            if item.title == MenuCollectionType.averages.rawValue {
                cell.bind(title: item.title, image: item.icon, isBlock: true)
                return cell
            }
        }

        cell.bind(title: item.title, image: item.icon)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = items[indexPath.row].title
        guard let selectedItem = MenuCollectionType(rawValue: item) else { return }

        if isContributorMode {
            if selectedItem == .averages { return }
        }

        didTapItem(selectedItem)
    }
    
}
