//
//  MNToast.swift
//  Manipulations
//
//  Created by Leonardo Portes on 30/05/23.
//

import UIKit

public enum MNToast {

    public static func show(
        message: String,
        icon: Icon? = nil,
        in controller: UIViewController,
        duration: TimeInterval = 4.0
    ) {
        let toast = MNToastView(message: message)
        controller.view.addSubview(toast)
        toast.translatesAutoresizingMaskIntoConstraints = false
        toast.bottomAnchor(in: controller.view, padding: .medium, layoutOption: .useSafeArea)
        toast.leftAnchor(in: controller.view, padding: .medium)
        toast.rightAnchor(in: controller.view, padding: .medium)

        UIView.animate(
            withDuration: 0.3,
            delay: 0.2,
            options: .curveEaseInOut,
            animations: { toast.alpha = 1 },
            completion: nil
        )

        UIView.animate(
            withDuration: 0.3,
            delay: duration - 0.5,
            options: .curveEaseInOut,
            animations: { toast.alpha = 0 },
            completion: { _ in toast.removeFromSuperview() }
        )
    }
}

class MNToastView: MNView {
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var institutionIconView = UIImageView() .. {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = .icon(for: .alertWarning)
        $0.setImageColor(color: .back)
    }

    init(message: String) {
        super.init()
        setupView()
        setMessage(message)
    }

    private func setupView() {
        backgroundColor = .neutralHigh
        alpha = 0.7
        layer.cornerRadius = 12

        addSubview(messageLabel)
        addSubview(institutionIconView)

        institutionIconView.leftAnchor(in: self, padding: .medium)
        institutionIconView.heightAnchor(20)
        institutionIconView.widthAnchor(20)
        institutionIconView.centerY(in: self)

        messageLabel.pin(toEdgesOf: self, padding: .all(.medium))
    }

    private func setMessage(_ message: String) {
        messageLabel.text = message
    }
}
