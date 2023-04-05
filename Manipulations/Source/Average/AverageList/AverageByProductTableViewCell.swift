//
//  AverageByProductTableViewCell.swift
//  Manipulations
//
//  Created by Leonardo Portes on 24/01/23.
//

import UIKit

final class AverageByProductTableViewCell: UITableViewCell, ViewCodeContract {

    // MARK: - Static properties
    static let identifier = "AverageByProductTableViewCell"

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

    private lazy var grossWeightLabel = MNLabel(text: "Peso bruto") .. {
        $0.font = .systemFont(ofSize: 14)
    }

    private lazy var grossWeightValueLabel = MNLabel(text: "189,96Kg", textColor: .neutral) .. {
        $0.textAlignment = .right
        $0.font = .systemFont(ofSize: 13)
    }

    private lazy var horizontalLine3 = UIView() .. {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .opaqueSeparator
        $0.heightAnchor(1)
    }
    
    private lazy var cleanWeightLabel = MNLabel(text: "Peso limpo") .. {
        $0.font = .systemFont(ofSize: 14)
    }
    
    private lazy var cleanWeightValueLabel = MNLabel(text: "167,54Kg", textColor: .neutral) .. {
        $0.textAlignment = .right
        $0.font = .systemFont(ofSize: 13)
    }

    func bind(
        productTitle: String,
        dateRange: String,
        averagePorcent: String,
        grossWeight: String,
        cleanWeight: String
    ) {
        productTitleLabel.text = productTitle
        dateRangeLabel.text = dateRange
        averagePorcentValueLabel.text = averagePorcent
        grossWeightValueLabel.text = grossWeight
        cleanWeightValueLabel.text = cleanWeight
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
        
        baseView.addSubview(grossWeightLabel)
        baseView.addSubview(grossWeightValueLabel)
        baseView.addSubview(horizontalLine3)
        
        baseView.addSubview(cleanWeightLabel)
        baseView.addSubview(cleanWeightValueLabel)
    }

    func setupConstraints() {
        baseView.pin(toEdgesOf: self, padding: .all(.medium))
        
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
        
        grossWeightLabel
            .topAnchor(in: horizontalLine2, attribute: .bottom, padding: .xSmall)
            .leftAnchor(in: baseView, padding: .medium)
            .heightAnchor(.large)
            .widthAnchor(100)
        
        grossWeightValueLabel
            .topAnchor(in: horizontalLine2, attribute: .bottom, padding: .xSmall)
            .rightAnchor(in: baseView, padding: .medium)
            .heightAnchor(.large)
            .widthAnchor(100)
        
        horizontalLine3
            .topAnchor(in: grossWeightLabel, attribute: .bottom, padding: .xSmall)
            .leftAnchor(in: baseView, padding: .medium)
            .rightAnchor(in: baseView, padding: .medium)
        
        cleanWeightLabel
            .topAnchor(in: horizontalLine3, attribute: .bottom, padding: .xSmall)
            .leftAnchor(in: baseView, padding: .medium)
            .heightAnchor(.large)
            .widthAnchor(100)
        
        cleanWeightValueLabel
            .topAnchor(in: horizontalLine3, attribute: .bottom, padding: .xSmall)
            .rightAnchor(in: baseView, padding: .medium)
            .heightAnchor(.large)
            .widthAnchor(100)
    }

    func setupConfiguration() {
        self.backgroundColor = .clear
        self.roundCorners(cornerRadius: 10)
        self.addShadow()
        self.selectionStyle = .none
    }
}
