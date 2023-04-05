//
//  CardSessionView.swift
//  Manipulations
//
//  Created by Leonardo Portes on 29/12/22.
//

import UIKit

class CardIconAndTitleView: UIView {
    
    var spacing: CGFloat = 8
    
    init(icon: String, title: String, titleColor: UIColor, isHiddenArrow: Bool = true, heightIcon: CGFloat = 24, spacing: CGFloat = 8) {
        super.init(frame: .zero)
        iconImageView.image = UIImage(named: icon)
        titleLabel.text = title
        titleLabel.textColor = titleColor
        iconArrow.isHidden = isHiddenArrow
        self.spacing = spacing
        iconImageView.heightAnchor(heightIcon)
        iconImageView.widthAnchor(heightIcon)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var iconImageView: UIImageView = {
        let container = UIImageView()
        container.contentMode = .scaleAspectFit
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    
    private lazy var iconArrow: UIImageView = {
        let container = UIImageView()
        container.image = UIImage(named: Icon.arrowRight.rawValue)
        container.contentMode = .scaleAspectFit
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
}

extension CardIconAndTitleView: ViewCodeContract {
    func setupHierarchy() {
        addSubview(iconImageView)
        addSubview(titleLabel)
        addSubview(iconArrow)
    }
    
    func setupConstraints() {
        iconImageView
            .topAnchor(in: self)
            .bottomAnchor(in: self)
            .leftAnchor(in: self)
        
        titleLabel
            .leftAnchor(in: iconImageView, attribute: .right, padding: spacing)
            .rightAnchor(in: self)
            .centerY(in: iconImageView)
        
        iconArrow
            .rightAnchor(in: self, attribute: .right)
            .heightAnchor(20)
            .widthAnchor(20)
            .centerY(in: iconImageView)
    }
    
    func setupConfiguration() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
}
