//
//  ManipulationsTableViewCell.swift
//  Manipulations
//
//  Created by Leonardo Portes on 25/01/23.
//

import Foundation
import UIKit

final class ManipulationsTableViewCell: UITableViewCell, ViewCodeContract {

    // MARK: - Static properties
    static let identifier = "ManipulationsTableViewCell"

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    private lazy var baseView = UIView() .. {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .neutralLow
        $0.roundCorners(cornerRadius: 15)
    }
    
    private lazy var productTitleLabel = MNLabel(text: "Salmão") .. {
        $0.font = .boldSystemFont(ofSize: 15)
    }
    
    private lazy var dateRangeLabel = MNLabel(text: "2022") .. {
        $0.textAlignment = .right
        $0.font = .systemFont(ofSize: 14)
    }
    
    private lazy var horizontalLine1 = UIView() .. {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .opaqueSeparator
        $0.heightAnchor(1)
    }
    
    private lazy var averagePorcentLabel = MNLabel(text: "Aproveitamento médio") .. {
        $0.font = .systemFont(ofSize: 14)
    }

    private lazy var averagePorcentValueLabel = MNLabel(text: "45,56%", textColor: .neutral) .. {
        $0.textAlignment = .right
        $0.font = .systemFont(ofSize: 13)
    }

    private lazy var horizontalLine2 = UIView() .. {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .opaqueSeparator
        $0.heightAnchor(1)
    }

    private lazy var responsibleLabel = MNLabel(text: "Responsável") .. {
        $0.font = .systemFont(ofSize: 14)
    }

    private lazy var responsibleValueLabel = MNLabel(text: "Leonardo p", textColor: .neutral) .. {
        $0.textAlignment = .right
        $0.font = .systemFont(ofSize: 13)
    }
    
    private lazy var dotsLabel = MNLabel(text: "...") .. {
        $0.textAlignment = .center
        $0.textColor = .neutral
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupHierarchy() {
        addSubview(baseView)

        baseView.addSubview(productTitleLabel)
        baseView.addSubview(dateRangeLabel)
        baseView.addSubview(horizontalLine1)

        baseView.addSubview(averagePorcentLabel)
        baseView.addSubview(averagePorcentValueLabel)
        baseView.addSubview(horizontalLine2)

        baseView.addSubview(responsibleLabel)
        baseView.addSubview(responsibleValueLabel)
        baseView.addSubview(dotsLabel)
    }

    func setupConstraints() {
        baseView.pin(toEdgesOf: self, padding: .init(top: .xSmall, left: .medium, right: .medium, bottom: .xSmall))

        productTitleLabel
            .topAnchor(in: baseView, padding: .medium)
            .leftAnchor(in: baseView, padding: .medium)
            .heightAnchor(.large)
            .widthAnchor(100)

        dateRangeLabel
            .topAnchor(in: baseView, padding: .medium)
            .rightAnchor(in: baseView, padding: .medium)
            .heightAnchor(.large)
            .widthAnchor(100)

        horizontalLine1
            .topAnchor(in: productTitleLabel, attribute: .bottom, padding: .xSmall)
            .leftAnchor(in: baseView, padding: .medium)
            .rightAnchor(in: baseView, padding: .medium)

        averagePorcentLabel
            .topAnchor(in: horizontalLine1, attribute: .bottom, padding: .xSmall)
            .leftAnchor(in: baseView, padding: .medium)
            .heightAnchor(.large)
            .widthAnchor(200)

        averagePorcentValueLabel
            .topAnchor(in: horizontalLine1, attribute: .bottom, padding: .xSmall)
            .rightAnchor(in: baseView, padding: .medium)
            .heightAnchor(.large)
            .widthAnchor(100)

        horizontalLine2
            .topAnchor(in: averagePorcentLabel, attribute: .bottom, padding: .xSmall)
            .leftAnchor(in: baseView, padding: .medium)
            .rightAnchor(in: baseView, padding: .medium)

        responsibleLabel
            .topAnchor(in: horizontalLine2, attribute: .bottom, padding: .xSmall)
            .leftAnchor(in: baseView, padding: .medium)
            .heightAnchor(.large)
            .widthAnchor(100)

        responsibleValueLabel
            .topAnchor(in: horizontalLine2, attribute: .bottom, padding: .xSmall)
            .rightAnchor(in: baseView, padding: .medium)
            .heightAnchor(.large)
            .widthAnchor(100)

        dotsLabel
            .bottomAnchor(in: baseView, padding: 10)
            .centerX(in: baseView)
            .heightAnchor(10)
            .widthAnchor(50)
    }

    func setupConfiguration() {
        self.backgroundColor = .clear
        self.roundCorners(cornerRadius: 10)
        self.addShadow()
        self.selectionStyle = .none
    }

    func bind(
        productTitle: String,
        dateRange: String,
        averagePorcent: String,
        responsible: String
    ) {
        self.productTitleLabel.text = productTitle
        self.dateRangeLabel.text = dateRange
        self.averagePorcentValueLabel.text = averagePorcent
        self.responsibleValueLabel.text = responsible
    }
}
