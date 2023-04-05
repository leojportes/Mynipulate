//
//  MenuItemView.swift
//  Manipulations
//
//  Created by Leonardo Portes on 31/12/22.
//

import Foundation
import UIKit

final class MenuItemView: TappedView, ViewCodeContract {
    
    private var onTap: Action
    
    init(
        onTap: @escaping Action
    ) {
        self.onTap = onTap
        super.init(frame: .zero)
        setupView()
        layer.masksToBounds = false
    }

    private let titleLabel = MNLabel(
        text: "",
        font: .boldSystemFont(ofSize: .medium)
    )

    private lazy var lockView = UIImageView() .. {
        $0.translatesAutoresizingMaskIntoConstraints  = false
        $0.image = UIImage(systemName: "exclamationmark.lock.fill")
        $0.heightAnchor(.xLarge)
        $0.setImageColor(color: .purpleLight.withAlphaComponent(0.8))
        $0.widthAnchor(.xLarge)
    }

    private let descriptionLabel = MNLabel(
        text: "",
        font: .boldSystemFont(ofSize: .small),
        textColor: .neutral
    )

    private let rightIcon = UIImageView() .. {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = .icon(for: .arrowRight)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup methods
    func setupHierarchy() {
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(rightIcon)
        addSubview(lockView)
    }
    
    func setupConstraints() {
        
        titleLabel
            .topAnchor(in: self, padding: .medium)
            .leftAnchor(in: self, padding: .medium)
        
        descriptionLabel
            .topAnchor(in: titleLabel, attribute: .bottom, padding: .xSmall2)
            .leftAnchor(in: self, padding: .medium)
        
        rightIcon
            .heightAnchor(.large)
            .widthAnchor(.large)
            .rightAnchor(in: self, padding: .medium)
            .centerY(in: self)
        
        lockView
            .topAnchor(in: self, padding: -8)
            .rightAnchor(in: self, padding: -8)
    }

    func setupConfiguration() {
        backgroundColor = .white
        roundCorners(cornerRadius: 10)
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor(.xLarge7)
    }

    func set(
        title: String,
        message: String = "",
        isBlock: Bool = false
    ) {
        titleLabel.text = title
        descriptionLabel.text = message
        lockView.isHidden = isBlock.not
        if isBlock.not {
            action(onTap)
        }
    }
}
