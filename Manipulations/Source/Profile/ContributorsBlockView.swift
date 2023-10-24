//
//  ContributorsBlockView.swift
//  Manipulations
//
//  Created by Leonardo Portes on 17/09/23.
//

import UIKit

final class ContributorsBlockView: CardView, ViewCodeContract {
    private let isSelected: (Bool) -> Void
    private let isOn: Bool

    // MARK: - Init
    init(
        isSelected: @escaping (Bool) -> Void,
        isOn: Bool
    ) {
        self.isSelected = isSelected
        self.isOn = isOn
        super.init()
        setupView()
        backgroundColor = .white
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var titleLabel = MNLabel(text: "Modo colaborador")

    lazy var switchView = UISwitch() .. {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.isOn = self.isOn
    }

    func setupHierarchy() {
        addSubview(titleLabel)
        addSubview(switchView)
    }

    func setupConstraints() {
        switchView.addTarget(self, action: #selector(setSelection), for: .valueChanged)
        titleLabel
            .centerY(in: self)
            .leftAnchor(in: self, padding: .medium)

        switchView
            .centerY(in: self)
            .rightAnchor(in: self, padding: .medium)
    }

    @objc func setSelection(_ sender: UISwitch) {
        isSelected(sender.isOn)
    }

}
