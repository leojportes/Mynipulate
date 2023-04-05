//
//  EmptyListViewCell.swift
//  Manipulations
//
//  Created by Leonardo Portes on 06/03/23.
//

import Foundation

import UIKit

final class EmptyListViewCell: UITableViewCell, ViewCodeContract {
    
    // MARK: - Static properties
    static let identifier = "EmptyListViewCell"
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var emptyView: ErrorView = {
        let view = ErrorView(title: "Sua lista está vazia!",
                             subTitle: "Arraste para atualizar ou adicione uma nova manipulação.",
                             imageName: "alertWarning")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    // MARK: - Viewcode

    
    // MARK: - Viewcode methods
    func setupHierarchy() {
        contentView.addSubview(emptyView)
    }

    func setupConstraints() {
        emptyView
            .topAnchor(in: contentView, attribute: .top, padding: 40)
            .leftAnchor(in: contentView)
            .rightAnchor(in: contentView)
            .bottomAnchor(in: contentView)

    }
    
    func setupConfiguration() {
        selectionStyle = .none
    }
    
    func bind(title: String, subtitle: String) {
        emptyView.titleLabel.text = title
        emptyView.subTitleLabel.text = subtitle
    }
}

