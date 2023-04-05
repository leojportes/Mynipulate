//
//  MNAlertView.swift
//  Manipulations
//
//  Created by Leonardo Portes on 02/03/23.
//

import UIKit

class MNAlertView: TappedView {
    
    private let title: String
    private let message: String
    
    // MARK: - Init
    init(
        title: String,
        message: String,
        onTap: @escaping Action
    ) {
        self.title = title
        self.message = message
        super.init(frame: .zero)
        setupView()
        action(onTap)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var rightIcon = UIImageView() .. {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(systemName: "exclamationmark.lock.fill")

        $0.setImageColor(color: .purpleLight.withAlphaComponent(0.8))
    }

    private lazy var titleLabel = MNLabel(text: title)
    
    private lazy var descriptionLabel = MNLabel(
        text: message,
        font: .boldSystemFont(ofSize: .small),
        textColor: .neutral
    ) .. {
        $0.numberOfLines = 3
    }

}

// MARK: - Extension Viewcode Contract
extension MNAlertView: ViewCodeContract {

    public func setupHierarchy() {
        addSubview(rightIcon)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
    }

    public func setupConstraints() {

        rightIcon
            .topAnchor(in: self, padding: .medium)
            .leftAnchor(in: self, padding: .medium)
            .heightAnchor(25)
            .widthAnchor(25)

        titleLabel
            .topAnchor(in: self, padding: .medium)
            .leftAnchor(in: rightIcon, attribute: .right, padding: .xSmall)

        descriptionLabel
            .topAnchor(in: titleLabel, attribute: .bottom, padding: .xSmall2)
            .leftAnchor(in: rightIcon, attribute: .right, padding: .xSmall)
        
    }

    public func setupConfiguration() {
        roundCorners(cornerRadius: 15)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .alertBlue.withAlphaComponent(0.4)
        layer.borderColor = UIColor.alertBlue.cgColor
        layer.borderWidth = 1
    }
}
