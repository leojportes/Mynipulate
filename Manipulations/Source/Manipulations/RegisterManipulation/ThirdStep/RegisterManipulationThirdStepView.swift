//
//  RegisterManipulationThirdStepView.swift
//  Manipulations
//
//  Created by Leonardo Portes on 01/03/23.
//

import UIKit

public struct RegisterManipulationThirdStep {
    let cookedWeight: String
    let headlessWeight: String
    let discardWeight: String
}

final class RegisterManipulationThirdStepView: MNView, ViewCodeContract {
    
    private let showAlertAction: Action
    private let didTapContinue: (RegisterManipulationThirdStep) -> Void

    // MARK: - Init
    init(
        showAlertAction: @escaping Action,
        didTapContinue: @escaping (RegisterManipulationThirdStep) -> Void
    ) {
        self.showAlertAction = showAlertAction
        self.didTapContinue = didTapContinue

        super.init()
        setupView()
        backgroundColor = .back
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var scrollView = UIScrollView() .. {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var contentView = UIView() .. {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    // OPICIONAL
    private lazy var cookedWeightLabel = MNLabel(text: "Peso cozido")
    private lazy var cookedWeightTextField = CustomTextField(
        titlePlaceholder: "Ex: 4,00 Kg (opcional)",
        radius: 10,
        borderColor: UIColor.opaqueSeparator.cgColor,
        borderWidth: 1
    ) .. {
        $0.keyboardType = .numberPad
        $0.delegate = self
        $0.cleanTextWhenBeginEditing()
    }

    // OPICIONAL
    private lazy var headlessWeightLabel = MNLabel(text: "Peso sem cabeça")
    private lazy var headlessWeightTextField = CustomTextField(
        titlePlaceholder: "Ex: 4,00 Kg (opcional)",
        radius: 10,
        borderColor: UIColor.opaqueSeparator.cgColor,
        borderWidth: 1
    ) .. {
        $0.keyboardType = .numberPad
        $0.delegate = self
        $0.cleanTextWhenBeginEditing()
    }

    private lazy var discardWeightLabel = MNLabel(text: "Peso descarte")
    private lazy var discardWeightTextField = CustomTextField(
        titlePlaceholder: "Ex: 4,00 Kg (opcional)",
        radius: 10,
        borderColor: UIColor.opaqueSeparator.cgColor,
        borderWidth: 1
    ) .. {
        $0.keyboardType = .numberPad
        $0.delegate = self
        $0.cleanTextWhenBeginEditing()
    }
    
    private lazy var registerButton = CustomSubmitButton(
        title: "Continuar",
        colorTitle: .purpleLight,
        radius: 25,
        background: .clear,
        borderColorCustom: UIColor.purpleLight.cgColor,
        borderWidthCustom: 1
    ) .. {
        $0.addTarget(self, action: #selector(didTapRegisterAction), for: .touchUpInside)
    }

    private lazy var stepsView = RoundedStepView(step: .third)

    func setupHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(stepsView)

        contentView.addSubview(cookedWeightLabel)
        contentView.addSubview(cookedWeightTextField)

        contentView.addSubview(headlessWeightLabel)
        contentView.addSubview(headlessWeightTextField)

        contentView.addSubview(discardWeightLabel)
        contentView.addSubview(discardWeightTextField)
      
        contentView.addSubview(registerButton)
    }

    func setupConstraints() {
        
        scrollView
            .topAnchor(in: self)
            .leftAnchor(in: self)
            .rightAnchor(in: self)
            .bottomAnchor(in: self, layoutOption: .useSafeArea)
        
        contentView
            .pin(toEdgesOf: scrollView)
        contentView
            .widthAnchor(in: scrollView, 1)
            .heightAnchor(in: scrollView, 1, withLayoutPriorityValue: 250)
        
        stepsView
            .topAnchor(in: contentView, padding: .medium)
            .centerX(in: contentView)
            .heightAnchor(25)
            .widthAnchor(70)

        cookedWeightLabel
            .topAnchor(in: contentView, padding: .xLarge4)
            .heightAnchor(22)
            .leftAnchor(in: contentView, padding: .medium)
        
        cookedWeightTextField
            .topAnchor(in: cookedWeightLabel, attribute: .bottom, padding: .xSmall2)
            .heightAnchor(45)
            .leftAnchor(in: contentView, padding: .medium)
            .rightAnchor(in: contentView, padding: .medium)
        
        headlessWeightLabel
            .topAnchor(in: cookedWeightTextField, attribute: .bottom, padding: .medium)
            .heightAnchor(22)
            .leftAnchor(in: contentView, padding: .medium)
            .rightAnchor(in: contentView, padding: .medium)
    
        headlessWeightTextField
            .topAnchor(in: headlessWeightLabel, attribute: .bottom, padding: .xSmall2)
            .heightAnchor(45)
            .leftAnchor(in: contentView, padding: .medium)
            .rightAnchor(in: contentView, padding: .medium)
        
        discardWeightLabel
            .topAnchor(in: headlessWeightTextField, attribute: .bottom, padding: .medium)
            .heightAnchor(22)
            .leftAnchor(in: contentView, padding: .medium)
            .rightAnchor(in: contentView, padding: .medium)
        
        discardWeightTextField
            .topAnchor(in: discardWeightLabel, attribute: .bottom, padding: .xSmall2)
            .heightAnchor(45)
            .leftAnchor(in: contentView, padding: .medium)
            .rightAnchor(in: contentView, padding: .medium)
        
        registerButton
            .heightAnchor(50)
            .leftAnchor(in: contentView, padding: 20)
            .rightAnchor(in: contentView, padding: 20)
            .bottomAnchor(in: contentView, padding: 20)
    }

    @objc func didTapRegisterAction() {
        let model = RegisterManipulationThirdStep(
            cookedWeight: cookedWeightTextField.text.orEmpty,
            headlessWeight: headlessWeightTextField.text.orEmpty,
            discardWeight: discardWeightTextField.text.orEmpty
        )

        didTapContinue(model)
    }

    public func formatWeight(weightInKgs: Double) -> String {
        let mformatter = MeasurementFormatter()
        mformatter.locale = Locale(identifier: "pt_BR")
        mformatter.unitOptions = .naturalScale
        mformatter.unitStyle = .medium
        let weight = Measurement(value: weightInKgs, unit: UnitMass.grams)
        return mformatter.string(from: weight)
    }
}

extension RegisterManipulationThirdStepView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength: Int = 20
        let currentString = (textField.text.orEmpty) as NSString
        let newString = currentString.replacingCharacters(in: range, with: string)
     
        return newString.count <= maxLength
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
        textField.selectedTextRange = textField.textRange(from: textField.beginningOfDocument, to: textField.endOfDocument)
        self.activeTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        guard let doubleValue = Double(text) else { return }
        textField.text = formatWeight(weightInKgs: doubleValue)
        
        self.activeTextField = nil
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
        return false
    }
}
