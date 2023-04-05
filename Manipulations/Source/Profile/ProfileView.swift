//
//  ProfileView.swift
//  Manipulations
//
//  Created by Leonardo Portes on 09/02/23.
//

import UIKit

final class ProfileView: UIView, ViewCodeContract {
    
    private let didTapExitAccountClosure: Action
    private let didTapContributorClosure: Action
    private let didTapContributorModeSwitch: (Bool) -> Void
    
    // MARK: - Init
    init(
        didTapExitAccountClosure: @escaping Action,
        didTapContributorClosure: @escaping Action,
        didTapContributorModeSwitch: @escaping (Bool) -> Void
    ) {
        self.didTapExitAccountClosure = didTapExitAccountClosure
        self.didTapContributorClosure = didTapContributorClosure
        self.didTapContributorModeSwitch = didTapContributorModeSwitch
        super.init(frame: .zero)
        setupView()
        backgroundColor = .back
    }
    
    private lazy var institutionIconView = UIImageView() .. {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = .icon(for: .institution)
        $0.setImageColor(color: .neutralHigh)
    }

    private lazy var institutionLabel = MNLabel(
        text: "Nome da empresa S.A.",
        font: .boldSystemFont(ofSize: 18),
        textColor: .neutralHigh
    )

    private lazy var documentView = TitleAndValueView(
        title: "Documento",
        value: "085.334.434/0001-33"
    )

    private lazy var contributorCountView = TitleAndValueView(
        title: "N.º de colaboradores",
        value: "5"
    )
    
    private lazy var manangerView = TitleAndValueView(
        title: "Responsável geral",
        value: "Rafael Portes",
        showSeparator: false
    )
    
    private lazy var exitAccountButton = UIButton() .. {
        $0.backgroundColor = .clear
        $0.setTitle("Sair da conta", for: .normal)
        $0.setTitleColor(.neutralHigh, for: .normal)
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        $0.addTarget(nil, action: #selector(didTapExitAccount), for: .touchUpInside)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private lazy var contributorMenuItem = MenuItemView(
        onTap: weakify { $0.didTapContributorClosure() }
    ) .. {
        $0.addShadow()
        $0.set(title: "Colaboradores", message: "Veja a lista de colaboradores.")
    }

    @objc func didTapExitAccount(sender: UIButton) {
        didTapExitAccountClosure()
    }

    private lazy var cardView = CardView(cornerRadius: 20) .. {
        $0.backgroundColor = .white
    }

    private lazy var contributorModeView = ContributorsBlockView(
        isSelected: weakify { $0.didTapContributorModeSwitch($1) },
        isOn: MNUserDefaults.get(boolForKey: .contributorMode) ?? true
    )


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupHierarchy() {
        addSubview(cardView)
        addSubviews([
            institutionIconView,
            institutionLabel,
            documentView,
            contributorCountView,
            manangerView
        ])
        
        addSubview(contributorModeView)
        addSubview(contributorMenuItem)
        addSubview(exitAccountButton)
    }

    func setupConstraints() {
        cardView
            .topAnchor(in: self, padding: .xLarge2)
            .leftAnchor(in: self, padding: .medium)
            .rightAnchor(in: self, padding: .medium)
            .heightAnchor(210)
        
        institutionIconView
            .topAnchor(in: cardView, padding: .medium)
            .leftAnchor(in: cardView, padding: .medium)
            .heightAnchor(30)
            .widthAnchor(30)
        
        institutionLabel
            .centerY(in: institutionIconView)
            .leftAnchor(in: institutionIconView, attribute: .right, padding: .small)
            .widthAnchor(200)
            .heightAnchor(25)

        documentView
            .topAnchor(in: institutionLabel, attribute: .bottom, padding: .small)
            .leftAnchor(in: cardView, padding: .medium)
            .rightAnchor(in: cardView, padding: .medium)
        
        contributorCountView
            .topAnchor(in: documentView, attribute: .bottom)
            .leftAnchor(in: cardView, padding: .medium)
            .rightAnchor(in: cardView, padding: .medium)
        
        manangerView
            .topAnchor(in: contributorCountView, attribute: .bottom)
            .leftAnchor(in: cardView, padding: .medium)
            .rightAnchor(in: cardView, padding: .medium)
        
        contributorModeView
            .topAnchor(in: cardView, attribute: .bottom, padding: .large)
            .leftAnchor(in: self, padding: .medium)
            .rightAnchor(in: self, padding: .medium)
            .heightAnchor(60)
        
        contributorMenuItem
            .topAnchor(in: contributorModeView, attribute: .bottom, padding: .large)
            .leftAnchor(in: self, padding: .medium)
            .rightAnchor(in: self, padding: .medium)
        
        exitAccountButton
            .bottomAnchor(in: self, padding: .medium)
            .leftAnchor(in: self, padding: .medium)
            .rightAnchor(in: self, padding: .medium)
            .heightAnchor(45)

    }

    private func addSubviews(_ views: [UIView]) {
        views.forEach { views in
            cardView.addSubview(views)
        }
    }

    func setup(
        numberOfContributors: String
    ) {
        contributorCountView.value = numberOfContributors
    }
}

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
    
    private lazy var switchView = UISwitch() .. {
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