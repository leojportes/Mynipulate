//
//  AverageByCollaboratorTableViewCell.swift
//  Manipulations
//
//  Created by Leonardo Portes on 25/01/23.
//

import UIKit

final class AverageByCollaboratorTableViewCell: UITableViewCell, ViewCodeContract {

    // MARK: - Static properties
    static let identifier = "AverageByCollaboratorTableViewCell"

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    private lazy var baseView = UIView() .. {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .back
        $0.roundCorners(cornerRadius: 15)
    }
    
    private lazy var contributorTitleLabel = MNLabel() .. {
        $0.font = .boldSystemFont(ofSize: 15)
    }
    
    private lazy var dateRangeLabel = MNLabel() .. {
        $0.textAlignment = .right
        $0.font = .systemFont(ofSize: 14)
    }
    
    private lazy var horizontalLine1 = UIView() .. {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .neutralLow
        $0.heightAnchor(1)
    }
    
    private lazy var averagePorcentLabel = MNLabel(text: "Aproveitamento médio") .. {
        $0.font = .systemFont(ofSize: 14)
    }

    private lazy var averagePorcentValueLabel = MNLabel(textColor: .neutral) .. {
        $0.textAlignment = .right
        $0.font = .systemFont(ofSize: 13)
    }

    private lazy var horizontalLine2 = UIView() .. {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .neutralLow
        $0.heightAnchor(1)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind(
        contributor: String,
        dateRange: String,
        averagePorcent: String
    ) {
        contributorTitleLabel.text = contributor
        dateRangeLabel.text = dateRange
        averagePorcentValueLabel.text = averagePorcent
    }

    func setupHierarchy() {
        addSubview(baseView)

        baseView.addSubview(contributorTitleLabel)
        baseView.addSubview(dateRangeLabel)
        baseView.addSubview(horizontalLine1)
        baseView.addSubview(averagePorcentLabel)
        baseView.addSubview(averagePorcentValueLabel)
        baseView.addSubview(horizontalLine2)
    }

    func setupConstraints() {
        baseView.pin(toEdgesOf: self, padding: .all(.medium))
        
        contributorTitleLabel
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
            .topAnchor(in: contributorTitleLabel, attribute: .bottom, padding: .xSmall)
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
    }

    func setupConfiguration() {
        backgroundColor = .clear
        roundCorners(cornerRadius: 10)
        addShadow()
        selectionStyle = .none
    }
}
