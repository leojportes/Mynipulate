//
//  ProductsTableViewCell.swift
//  Manipulations
//
//  Created by Leonardo Portes on 07/02/23.
//

import Foundation
import UIKit

final class ProductsTableViewCell: UITableViewCell, ViewCodeContract {

    // MARK: - Static properties
    static let identifier = "ProductsTableViewCell"

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var baseView = UIView() .. {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .back
    }
    
    private lazy var productTitleLabel = MNLabel(text: "Blue fin") .. {
        $0.font = .boldSystemFont(ofSize: 15)
    }

    private let productIcon = UIImageView() .. {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(systemName: "shippingbox")
        $0.setImageColor(color: .purpleLight)
    }
    
    func setupHierarchy() {
        addSubview(baseView)
        addSubview(productIcon)
        addSubview(productTitleLabel)
    }

    func setupConstraints() {
        baseView
            .pin(toEdgesOf: self)
        
        productIcon
            .centerY(in: baseView)
            .leftAnchor(in: baseView, padding: .medium)
            .heightAnchor(30)
            .widthAnchor(30)
        
        productTitleLabel
            .centerY(in: productIcon)
            .leftAnchor(in: productIcon, attribute: .right, padding: .medium)
            .heightAnchor(20)
            .widthAnchor(200)

    }

    func bind(title: String, type: ProductType) {
        productTitleLabel.text = title
        
        switch type {
        case .seafood: productIcon.image = UIImage(named: "seafood")
        case .meat: productIcon.image = UIImage(named: "meat")
        case .fish: productIcon.image = UIImage(named: "fish")
        case .choiceLegend: break
        }
    }
}
