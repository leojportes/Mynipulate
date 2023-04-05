//
//  IconButton.swift
//  Manipulations
//
//  Created by Leonardo Portes on 29/12/22.
//

import UIKit

public final class IconButton: UIView, ViewCodeContract {
    
    // MARK: - Private properties
    private var actionButton: Action?
    
    // MARK: - Lifecycle
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Viewcode
    private lazy var icon: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public func setupHierarchy() {
        self.addSubview(icon)
        self.addSubview(titleLabel)
        
        icon
            .center(in: self)
            .heightAnchor(40)
            .widthAnchor(40)
        
    }
    
    public func setupConstraints() {
        tapGestureRecognizer()
    }
    
    public func setup(image: UIImage? = nil,
                      backgroundColor: UIColor,
                      action: @escaping Action = { () } ) {
        icon.image = image
        self.backgroundColor = backgroundColor
        self.translatesAutoresizingMaskIntoConstraints = false
        actionButton = action
    }
    
    public func setIcon(height: CGFloat = 40,
                        width: CGFloat = 40) {
        icon
            .center(in: self)
            .heightAnchor(height)
            .widthAnchor(width)
    }
    
    // MARK: - Actions
    @objc private func tappedView(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            self.actionButton?()
        }
    }
    
    private func tapGestureRecognizer() {
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(self.tappedView))
        self.addGestureRecognizer(tapGR)
        self.isUserInteractionEnabled = true
    }
    
}
