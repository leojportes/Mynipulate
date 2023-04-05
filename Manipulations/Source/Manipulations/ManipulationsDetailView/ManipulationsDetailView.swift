//
//  ManipulationsDetailView.swift
//  Manipulations
//
//  Created by Leonardo Portes on 25/01/23.
//

import UIKit

final class ManipulationsDetailView: UIView {
    
    private let manipulation: Manipulation
    
    private let isContributorMode = MNUserDefaults.get(boolForKey: .contributorMode) ?? true
    private let showAlertAction: (String) -> Void
    private let didTapEditAction: Action
    private let didTapDeleteAction: Action
    
    // MARK: - Init
    
    init(
        item: Manipulation,
        showAlertAction: @escaping (String) -> Void,
        didTapEditAction: @escaping Action,
        didTapDeleteAction: @escaping Action
    ) {
        self.showAlertAction = showAlertAction
        self.didTapEditAction = didTapEditAction
        self.didTapDeleteAction = didTapDeleteAction
        self.manipulation = item
        super.init(frame: .zero)
        setupView()
        backgroundColor = .white
        productIcon.image = UIImage(named: item.productType)
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
    private lazy var productLabel = MNLabel(text: manipulation.product) .. {
        $0.font = .boldSystemFont(ofSize: 18)
    }

    private lazy var dateLabel = MNLabel(text: manipulation.date) .. {
        $0.textAlignment = .right
    }

    private lazy var averageView = AveragePercentView(title: "Aproveitamento", value: manipulation.avarage) .. {
        $0.backgroundColor = .neutralLow
        $0.layer.borderColor = UIColor.neutral.cgColor
        $0.layer.borderWidth = 1
    }

    private lazy var dataCardView = UIView() .. {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .neutralLow
        $0.roundCorners(cornerRadius: 15)
        $0.addShadow()
    }
    
    private lazy var supplierView = TitleAndValueView(title: "Fornecedor", value:  manipulation.supplier)
    private lazy var ownerView = TitleAndValueView(title: "Colaborador", value: manipulation.responsibleName, showSeparator: false)

    private lazy var wheightCardView = UIView() .. {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .neutralLow
        $0.roundCorners(cornerRadius: 15)
        $0.addShadow()
    }

    private lazy var grossWeightView = TitleAndValueView(title: "Peso bruto", value: manipulation.grossWeight)
    private lazy var cleanWeightView = TitleAndValueView(title: "Peso limpo", value: manipulation.cleanWeight)
    private lazy var thawedWeightView = TitleAndValueView(title: "Peso descongelado", value: manipulation.thawedWeight.orEmpty)
    private lazy var headlessWeightView = TitleAndValueView(title: "Peso sem cabeça", value: manipulation.headlessWeight.orEmpty)
    private lazy var skinWeightView = TitleAndValueView(title: "Peso da pele", value: manipulation.skinWeight.orEmpty)
    private lazy var cookedWeightView = TitleAndValueView(title: "Peso cozido", value: manipulation.cookedWeight.orEmpty)
    private lazy var discardWeightView = TitleAndValueView(title: "Peso descarte", value: manipulation.discardWeight.orEmpty, showSeparator: false)
    
    private lazy var editButton = CustomSubmitButton(
        title: "Editar",
        colorTitle: .purpleLight,
        radius: 25,
        background: .clear,
        borderColorCustom: UIColor.purpleLight.cgColor,
        borderWidthCustom: 1
    ) .. {
        $0.addTarget(nil, action: #selector(didTapEditButton), for: .touchUpInside)
        $0.showLockView = isContributorMode
    }

    private lazy var deleteButton = CustomSubmitButton(
        title: "Deletar",
        colorTitle: .systemRed,
        radius: 25,
        background: .systemRed.withAlphaComponent(0.3),
        borderColorCustom: UIColor.systemRed.cgColor,
        borderWidthCustom: 1
    ) .. {
        $0.addTarget(nil, action: #selector(didTapDeleteButton), for: .touchUpInside)
        $0.showLockView = isContributorMode
    }
    
    // MARK: - Methods
    @objc func didTapDeleteButton() {
        if isContributorMode {
            showAlertAction("Deletar")
        } else {
            print("delete")
        }
    }

    @objc func didTapEditButton() {
        isContributorMode ? showAlertAction("Editar") : didTapEditAction()
    }

}

extension ManipulationsDetailView: ViewCodeContract {
    
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
        

        // addSubview(editButton)
        addSubview(deleteButton)
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
            .heightAnchor(330)
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

//        editButton
//            .bottomAnchor(in: self, padding: .medium)
//            .heightAnchor(50)
//            .widthAnchor(150)
//            .leftAnchor(in: self, padding: .medium)

        deleteButton
            .bottomAnchor(in: self, padding: .medium)
            .heightAnchor(50)
            .leftAnchor(in: self, padding: .medium)
            .rightAnchor(in: self, padding: .medium)
    }
    
}

public class TitleAndValueView: UIView, ViewCodeContract {
    
    var title: String {
        didSet {
            titleLabel.text = title
        }
    }
    
    var value: String {
        didSet {
            valueLabel.text = value
        }
    }
    
    private let showSeparator: Bool
    
    init(
        title: String,
        value: String = "",
        showSeparator: Bool = true
    ) {
        self.title = title
        self.value = value
        self.showSeparator = showSeparator
        super.init(frame: .zero)
        setupView()
        heightAnchor(50)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var titleLabel = MNLabel(text: title) .. {
        $0.font = .boldSystemFont(ofSize: .medium)
    }

    private lazy var valueLabel = MNLabel(text: value) .. {
        $0.textAlignment = .right
        $0.font = .boldSystemFont(ofSize: 15)
        $0.textColor = .neutral
    }

    private lazy var horizontalView = UIView() .. {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.heightAnchor(1)
        $0.backgroundColor = .opaqueSeparator
        $0.isHidden = showSeparator.not
    }
    
    public func setupHierarchy() {
        addSubview(titleLabel)
        addSubview(valueLabel)
        addSubview(horizontalView)
    }
    
    public func setupConstraints() {
        titleLabel
            .topAnchor(in: self, padding: 5)
            .leftAnchor(in: self)
            .bottomAnchor(in: self, padding: 5)
            .heightAnchor(20)
        
        valueLabel
            .topAnchor(in: self, padding: 6)
            .rightAnchor(in: self)
            .bottomAnchor(in: self, padding: 5)
            .heightAnchor(20)
        
        horizontalView
            .bottomAnchor(in: self, padding: 5)
            .leftAnchor(in: self)
            .rightAnchor(in: self)
    }
}


public class AveragePercentView: UIView, ViewCodeContract {
    private let title: String
    var value: String {
        didSet {
            valueLabel.text = value
        }
    }
    
    init(
        title: String,
        value: String = ""
    ) {
        self.title = title
        self.value = value
        super.init(frame: .zero)
        setupView()
        heightAnchor(70)
        backgroundColor = .neutralLow
        translatesAutoresizingMaskIntoConstraints = false
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        roundCorners(cornerRadius: 15)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var titleLabel = MNLabel(text: title) .. {
        $0.font = .boldSystemFont(ofSize: .medium)
    }
    
    private lazy var valueLabel = MNLabel(text: value) .. {
        $0.textAlignment = .right
        $0.font = .boldSystemFont(ofSize: .medium)
        $0.textColor = .neutralHigh
    }
    
    private lazy var descriptionLabel = MNLabel(text: "Peso limpo ÷ Peso bruto x 100") .. {
        $0.font = .systemFont(ofSize: 12)
        $0.textColor = .neutral
    }

    public func setupHierarchy() {
        addSubview(titleLabel)
        addSubview(valueLabel)
        addSubview(descriptionLabel)
    }

    public func setupConstraints() {
        titleLabel
            .topAnchor(in: self, padding: .medium)
            .leftAnchor(in: self, padding: .medium)
        
        valueLabel
            .topAnchor(in: self, padding: .medium)
            .rightAnchor(in: self, padding: .medium)
         
        descriptionLabel
            .topAnchor(in: titleLabel, padding: .large)
            .leftAnchor(in: self, padding: .medium)
    }

}
