//
//  ErrorView.swift
//  Manipulations
//
//  Created by Leonardo Portes on 29/12/22.
//

import UIKit

class ErrorView: UIView {

    init(title: String, subTitle: String, imageName: String, backgroundView: UIColor? = .white) {
        super.init(frame: .zero)
        alertImage.image = UIImage(named: imageName)
        titleLabel.text = title
        subTitleLabel.text = subTitle
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ViewCode
    lazy var containerStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var alertImage: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
}

extension ErrorView: ViewCodeContract {
    func setupHierarchy() {
        addSubview(containerStack)
    }
    
    func setupConstraints() {
        
        containerStack.addArrangedSubview(alertImage)
        containerStack.addArrangedSubview(titleLabel)
        containerStack.addArrangedSubview(subTitleLabel)
        
        containerStack
            .topAnchor(in: self, attribute: .top, padding: 10)
            .leftAnchor(in: self, attribute: .left, padding: 10)
            .rightAnchor(in: self, attribute: .right, padding: 10)
    }
    
    
}
