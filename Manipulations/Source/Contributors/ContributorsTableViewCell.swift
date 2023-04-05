//
//  ContributorsTableViewCell.swift
//  Manipulations
//
//  Created by Leonardo Portes on 15/02/23.
//

import UIKit

final class ContributorsTableViewCell: UITableViewCell, ViewCodeContract {

    // MARK: - Static properties
    static let identifier = "ContributorsTableViewCell"

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
    
    private lazy var contributorsTitleLabel = MNLabel(text: "Leonardo Portes") .. {
        $0.font = .boldSystemFont(ofSize: 15)
    }
    
    private lazy var contributorsIDLabel = MNLabel(text: "#0043240443", textColor: .neutral) .. {
        $0.font = .boldSystemFont(ofSize: 13)
    }

    private let contributorsIcon = UIImageView() .. {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(systemName: "person.circle.fill")
        $0.setImageColor(color: .neutral)
    }
    
    func setupHierarchy() {
        addSubview(baseView)
        baseView.addSubview(contributorsIcon)
        baseView.addSubview(contributorsTitleLabel)
        baseView.addSubview(contributorsIDLabel)
    }

    func setupConstraints() {
        baseView
            .pin(toEdgesOf: self)
        
        contributorsIcon
            .centerY(in: baseView)
            .leftAnchor(in: baseView, padding: .medium)
            .heightAnchor(30)
            .widthAnchor(30)
        
        contributorsTitleLabel
            .topAnchor(in: baseView, padding: .medium)
            .leftAnchor(in: contributorsIcon, attribute: .right, padding: .medium)
            .heightAnchor(20)
            .widthAnchor(250)
        
        contributorsIDLabel
            .topAnchor(in: contributorsTitleLabel, attribute: .bottom)
            .leftAnchor(in: contributorsIcon, attribute: .right, padding: .medium)
            .heightAnchor(20)
            .widthAnchor(130)

    }

    func bind(title: String, id: String) {
        contributorsTitleLabel.text = title
        contributorsIDLabel.text = id
    }
}
