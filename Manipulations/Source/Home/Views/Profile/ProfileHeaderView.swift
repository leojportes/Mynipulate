//
//  ProfileHeaderView.swift
//  Manipulations
//
//  Created by Leonardo Portes on 29/12/22.
//

import UIKit

final class ProfileHeaderView: UIView {
    
    // MARK: - Private properties
    private var openProfile: Action?
    
    // MARK: - Init
    init(
        onTap: @escaping Action
    ) {
        self.openProfile = onTap
        super.init(frame: .zero)
        setupView()
        let tapProfile = UITapGestureRecognizer(target: self, action: #selector(tappedView))
        self.addGestureRecognizer(tapProfile)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Viewcode
    lazy var containerView: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    private lazy var iconView: UIView = {
        let container = UIView()
        container.backgroundColor = .back
        container.roundCorners(cornerRadius: 24)
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    private lazy var iconImage = MNLabel(font: UIFont.boldSystemFont(ofSize: 16)) .. {
        $0.textColor = .neutralHigh
    }
    
    private lazy var companyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var documentLabel = MNLabel(font: UIFont.boldSystemFont(ofSize: 13)) .. {
        $0.textColor = .back
    }
    
    private lazy var iconArrow: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: Icon.arrowDown.rawValue)
        img.contentMode = .scaleAspectFit
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
        
    @objc private func tappedView(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            self.openProfile?()
        }
    }
    
    func set(company: String, document: String) {
        iconImage.text = "\(company.prefix(2).uppercased())"
        companyLabel.text = company
        documentLabel.text = document
    }

}

extension ProfileHeaderView: ViewCodeContract {
    func setupHierarchy() {
        addSubview(containerView)
        addSubview(iconView)
        addSubview(iconImage)
        addSubview(companyLabel)
        addSubview(documentLabel)
    }
    
    func setupConstraints() {
        containerView
            .leftAnchor(in: self, padding: .medium)
            .bottomAnchor(in: self, padding: .small)
        
        iconView
            .centerY(in: self)
            .leftAnchor(in: self, padding: .medium)
            .heightAnchor(.xLarge4)
            .widthAnchor(.xLarge4)
        
        iconImage
            .centerX(in: iconView)
            .centerY(in: iconView)
 
        companyLabel
            .leftAnchor(in: iconView, attribute: .right, padding: .medium)
            .topAnchor(in: self, padding: .xLarge4/3)
        
        documentLabel
            .topAnchor(in: companyLabel, attribute: .bottom, padding: .xSmall2)
            .leftAnchor(in: iconView, attribute: .right, padding: .medium)
    }
    
    func setupConfiguration() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
