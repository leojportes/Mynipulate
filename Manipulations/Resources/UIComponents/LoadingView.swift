//
//  LoadingView.swift
//  Manipulations
//
//  Created by Leonardo Portes on 17/09/23.
//

import UIKit

final class LoadingView: MNView {
    var isLoading: Bool = false {
        didSet {
            if isLoading {
                activityIndicator.startAnimating()
            } else {
                activityIndicator.stopAnimating()
            }
        }
    }

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.center = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        indicator.color = .darkGray
        indicator.layer.opacity = 0.5
        indicator.startAnimating()
        return indicator
    }()

    override init() {
        super.init()
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        activityIndicator.startAnimating()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .neutralLow
    }
}
