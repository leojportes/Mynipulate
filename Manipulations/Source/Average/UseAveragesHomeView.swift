//
//  UseAveragesHomeView.swift
//  Manipulations
//
//  Created by Leonardo Portes on 31/12/22.
//

import UIKit

final class UseAveragesHomeView: UIView {
    
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
    // MARK: - Init
    init(
        didTapByProductItem: @escaping Action,
        didTapByContributorsItem: @escaping Action
    ) {
        self.didTapByProductItem = didTapByProductItem
        self.didTapByContributorsItem = didTapByContributorsItem
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
    }
   
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .back
    }
}
