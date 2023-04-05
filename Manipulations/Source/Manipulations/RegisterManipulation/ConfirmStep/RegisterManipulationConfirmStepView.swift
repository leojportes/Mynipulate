//
//  RegisterManipulationConfirmStepView.swift
//  Manipulations
//
//  Created by Leonardo Portes on 01/03/23.
//

import UIKit

final class RegisterManipulationConfirmStepView: UIView {

    private let model: Manipulation
    private let onConfirm: (Manipulation) -> Void

    // MARK: - Init
    init(model: Manipulation, onConfirmTap: @escaping (Manipulation) -> Void) {
        self.model = model
        self.onConfirm = onConfirmTap
        super.init(frame: .zero)
        setupView()
        bind(model)
        backgroundColor = .white
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View
    private lazy var gripView = GripView()
    
    private lazy var productIcon = UIImageView() .. {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(systemName: "plus")
    }
    private lazy var productLabel = MNLabel(text: "Atum") .. {
        $0.font = .boldSystemFont(ofSize: 18)
    }

    private lazy var dateLabel = MNLabel(text: "20/10/2022") .. {
        $0.textAlignment = .right
    }

    private lazy var averageView = AveragePercentView(title: "Aproveitamento") .. {
        $0.backgroundColor = .neutralLow
    }

    private lazy var dataCardView = UIView() .. {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .neutralLow
        $0.roundCorners(cornerRadius: 15)
        $0.addShadow()
    }
    
    private lazy var supplierView = TitleAndValueView(title: "Fornecedor")
    private lazy var ownerView = TitleAndValueView(title: "Colaborador", showSeparator: false)

    private lazy var wheightCardView = UIView() .. {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .neutralLow
        $0.roundCorners(cornerRadius: 15)
        $0.addShadow()
    }

    private lazy var grossWeightView = TitleAndValueView(title: "Peso bruto")
    private lazy var cleanWeightView = TitleAndValueView(title: "Peso limpo")
    private lazy var thawedWeightView = TitleAndValueView(title: "Peso descongelado")
    private lazy var headlessWeightView = TitleAndValueView(title: "Peso sem cabeça")
    private lazy var skinWeightView = TitleAndValueView(title: "Peso da pele")
    private lazy var cookedWeightView = TitleAndValueView(title: "Peso cozido")
    private lazy var discardWeightView = TitleAndValueView(title: "Peso descarte", showSeparator: false)
    
    private func bind(_ model: Manipulation) {
        averageView.value = model.avarage
        
        setIcon(ProductType(rawValue: model.productType) ?? .fish)
        productLabel.text = model.product
        supplierView.value = model.supplier
        ownerView.value = model.responsibleName
        dateLabel.text = model.date
        
        grossWeightView.value = model.grossWeight
        cleanWeightView.value = model.cleanWeight
        thawedWeightView.value = model.thawedWeight ?? "0 kg"
        headlessWeightView.value = model.headlessWeight ?? "0 kg"
        skinWeightView.value = model.skinWeight ?? "0 kg"
        cookedWeightView.value = model.cookedWeight ?? "0 kg"
        discardWeightView.value = model.discardWeight ?? "0 kg"
    }
    
    private(set) lazy var registerButton = CustomSubmitButton(
        title: "Cadastrar",
        colorTitle: .back,
        radius: 25,
        background: .purpleLight
    ) .. {
        $0.addTarget(self, action: #selector(didTapRegisterAction), for: .touchUpInside)
    }
    
    // MARK: - Methods
    @objc func didTapRegisterAction() {
        registerButton.loadingIndicator(show: true)
        return onConfirm(model)
    }

    func setIcon(_ productType: ProductType) {
        switch productType {
        case .seafood: productIcon.image = UIImage(named: "seafood")
        case .meat: productIcon.image = UIImage(named: "meat")
        case .fish: productIcon.image = UIImage(named: "fish")
        case .choiceLegend: break
        }
    }
}

extension RegisterManipulationConfirmStepView: ViewCodeContract {
    
    func setupHierarchy() {
        addSubview(gripView)
        addSubview(productIcon)
        addSubview(productLabel)
        
        addSubview(dateLabel)
        addSubview(averageView)
        addSubview(dataCardView)
        dataCardView.addSubview(supplierView)
        dataCardView.addSubview(ownerView)
        
        addSubview(wheightCardView)
        wheightCardView.addSubview(grossWeightView)
        wheightCardView.addSubview(cleanWeightView)
        wheightCardView.addSubview(thawedWeightView)
        wheightCardView.addSubview(headlessWeightView)
        wheightCardView.addSubview(skinWeightView)
        wheightCardView.addSubview(cookedWeightView)
        wheightCardView.addSubview(discardWeightView)
        
        addSubview(registerButton)
    }
    
    func setupConstraints() {
        gripView
            .centerX(in: self)
            .topAnchor(in: self, padding: 10)
        
        productIcon
            .topAnchor(in: self, padding: 40)
            .leftAnchor(in: self, padding: .medium)
            .widthAnchor(40)
            .heightAnchor(40)
        
        productLabel
            .topAnchor(in: self, padding: 50)
            .leftAnchor(in: productIcon, attribute: .right, padding: .medium)
            .heightAnchor(25)
        
        dateLabel
            .topAnchor(in: self, padding: 50)
            .rightAnchor(in: self, padding: .medium)
            .widthAnchor(100)
            .heightAnchor(24)
        
        averageView
            .topAnchor(in: productIcon, attribute: .bottom, padding: .xLarge)
            .leftAnchor(in: self, padding: .medium)
            .rightAnchor(in: self, padding: .medium)
        
        dataCardView
            .heightAnchor(95)
            .topAnchor(in: averageView, attribute: .bottom, padding: .medium)
            .leftAnchor(in: self, padding: .medium)
            .rightAnchor(in: self, padding: .medium)

        supplierView
            .topAnchor(in: dataCardView)
            .leftAnchor(in: dataCardView, padding: .medium)
            .rightAnchor(in: dataCardView, padding: .medium)
        
        ownerView
            .topAnchor(in: supplierView, attribute: .bottom, padding: -5)
            .leftAnchor(in: dataCardView, padding: .medium)
            .rightAnchor(in: dataCardView, padding: .medium)
        
        wheightCardView
            .heightAnchor(320)
            .topAnchor(in: dataCardView, attribute: .bottom, padding: .medium)
            .leftAnchor(in: self, padding: .medium)
            .rightAnchor(in: self, padding: .medium)
        
        grossWeightView
            .topAnchor(in: wheightCardView)
            .leftAnchor(in: wheightCardView, padding: .medium)
            .rightAnchor(in: wheightCardView, padding: .medium)
        
        cleanWeightView
            .topAnchor(in: grossWeightView, attribute: .bottom, padding: -5)
            .leftAnchor(in: wheightCardView, padding: .medium)
            .rightAnchor(in: wheightCardView, padding: .medium)
        
        thawedWeightView
            .topAnchor(in: cleanWeightView, attribute: .bottom, padding: -5)
            .leftAnchor(in: wheightCardView, padding: .medium)
            .rightAnchor(in: wheightCardView, padding: .medium)
        
        headlessWeightView
            .topAnchor(in: thawedWeightView, attribute: .bottom, padding: -5)
            .leftAnchor(in: wheightCardView, padding: .medium)
            .rightAnchor(in: wheightCardView, padding: .medium)
        
        skinWeightView
            .topAnchor(in: headlessWeightView, attribute: .bottom, padding: -5)
            .leftAnchor(in: wheightCardView, padding: .medium)
            .rightAnchor(in: wheightCardView, padding: .medium)
        
        cookedWeightView
            .topAnchor(in: skinWeightView, attribute: .bottom, padding: -5)
            .leftAnchor(in: wheightCardView, padding: .medium)
            .rightAnchor(in: wheightCardView, padding: .medium)
        
        discardWeightView
            .topAnchor(in: cookedWeightView, attribute: .bottom, padding: -5)
            .leftAnchor(in: wheightCardView, padding: .medium)
            .rightAnchor(in: wheightCardView, padding: .medium)

        registerButton
            .bottomAnchor(in: self, padding: .medium)
            .heightAnchor(50)
            .leftAnchor(in: self, padding: .medium)
            .rightAnchor(in: self, padding: .medium)

    }
    
}
