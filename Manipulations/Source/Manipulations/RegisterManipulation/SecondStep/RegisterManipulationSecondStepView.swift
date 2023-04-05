//
//  RegisterManipulationSecondStepView.swift
//  Manipulations
//
//  Created by Leonardo Portes on 28/02/23.
//

import UIKit

public struct RegisterManipulationSecondStep {
    let grossWeight: String
    let cleanWeight: String
    let thawedWeight: String
    let skinWeight: String
}

final class RegisterManipulationSecondStepView: MNView, ViewCodeContract {
    
    private let showAlertAction: (String) -> Void
    private let didTapContinue: (RegisterManipulationSecondStep) -> Void
    
    // MARK: - Init
    init(
        showAlertAction: @escaping (String) -> Void,
        didTapContinue: @escaping (RegisterManipulationSecondStep) -> Void
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

    // OBRIGATORIO
    private lazy var grossWeightLabel = MNLabel(text: "Peso bruto")
    private lazy var grossWeightTextField = CustomTextField(
        titlePlaceholder: "Ex: 4,34 Kg",
        radius: 10,
        borderColor: UIColor.opaqueSeparator.cgColor,
        borderWidth: 1
    ) .. {
        $0.keyboardType = .numberPad
        $0.delegate = self
        $0.cleanTextWhenBeginEditing()
    }

    // OBRIGATORIO
    private lazy var cleanWeightLabel = MNLabel(text: "Peso limpo")
    private lazy var cleanWeightTextField = CustomTextField(
        titlePlaceholder: "Ex: 3,50 Kg",
        radius: 10,
        borderColor: UIColor.opaqueSeparator.cgColor,
        borderWidth: 1
    ) .. {
        $0.keyboardType = .numberPad
        $0.delegate = self
        $0.cleanTextWhenBeginEditing()
    }

    // OPICIONAL
    private lazy var thawedWeightLabel = MNLabel(text: "Peso descongelado")
    private lazy var thawedWeightTextField = CustomTextField(
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
    private lazy var skinWeightLabel = MNLabel(text: "Peso da pele")
    private lazy var skinWeightTextField = CustomTextField(
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
        $0.addTarget(self, action: #selector(didTapContinueAction), for: .touchUpInside)
    }

    private lazy var stepsView = RoundedStepView(step: .second)

    func setupHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(stepsView)

        contentView.addSubview(grossWeightLabel)
        contentView.addSubview(grossWeightTextField)

        contentView.addSubview(cleanWeightLabel)
        contentView.addSubview(cleanWeightTextField)

        contentView.addSubview(thawedWeightLabel)
        contentView.addSubview(thawedWeightTextField)
        
        contentView.addSubview(skinWeightLabel)
        contentView.addSubview(skinWeightTextField)
      
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

        grossWeightLabel
            .topAnchor(in: contentView, padding: .xLarge4)
            .heightAnchor(22)
            .leftAnchor(in: contentView, padding: .medium)
        
        grossWeightTextField
            .topAnchor(in: grossWeightLabel, attribute: .bottom, padding: .xSmall2)
            .heightAnchor(45)
            .leftAnchor(in: contentView, padding: .medium)
            .rightAnchor(in: contentView, padding: .medium)
        
        cleanWeightLabel
            .topAnchor(in: grossWeightTextField, attribute: .bottom, padding: .medium)
            .heightAnchor(22)
            .leftAnchor(in: contentView, padding: .medium)
            .rightAnchor(in: contentView, padding: .medium)
    
        cleanWeightTextField
            .topAnchor(in: cleanWeightLabel, attribute: .bottom, padding: .xSmall2)
            .heightAnchor(45)
            .leftAnchor(in: contentView, padding: .medium)
            .rightAnchor(in: contentView, padding: .medium)
        
        thawedWeightLabel
            .topAnchor(in: cleanWeightTextField, attribute: .bottom, padding: .medium)
            .heightAnchor(22)
            .leftAnchor(in: contentView, padding: .medium)
            .rightAnchor(in: contentView, padding: .medium)
        
        thawedWeightTextField
            .topAnchor(in: thawedWeightLabel, attribute: .bottom, padding: .xSmall2)
            .heightAnchor(45)
            .leftAnchor(in: contentView, padding: .medium)
            .rightAnchor(in: contentView, padding: .medium)
        
        skinWeightLabel
            .topAnchor(in: thawedWeightTextField, attribute: .bottom, padding: .medium)
            .heightAnchor(22)
            .leftAnchor(in: contentView, padding: .medium)
            .rightAnchor(in: contentView, padding: .medium)
        
        skinWeightTextField
            .topAnchor(in: skinWeightLabel, attribute: .bottom, padding: .xSmall2)
            .heightAnchor(45)
            .leftAnchor(in: contentView, padding: .medium)
            .rightAnchor(in: contentView, padding: .medium)
        
        registerButton
            .heightAnchor(50)
            .leftAnchor(in: contentView, padding: 20)
            .rightAnchor(in: contentView, padding: 20)
            .bottomAnchor(in: contentView, padding: 20)
    }

    private func isSomeEmptyField() -> Bool {
        var result: Bool = false
        guard let grossWeightText = grossWeightTextField.text?.replacingOccurrences(of: " ", with: "") else { return false }
        guard let cleanWeightText = cleanWeightTextField.text?.replacingOccurrences(of: " ", with: "") else { return false }
        let someAreEmpty = grossWeightText.isEmpty || cleanWeightText.isEmpty
        result = someAreEmpty ? true : false
        return result
    }
    

    @objc func didTapContinueAction() {
        
        let model = RegisterManipulationSecondStep(
            grossWeight: grossWeightTextField.text.orEmpty,
            cleanWeight: cleanWeightTextField.text.orEmpty,
            thawedWeight: thawedWeightTextField.text.orEmpty,
            skinWeight: skinWeightTextField.text.orEmpty
        )
        
        configureMandatoryTextInTextFields()
        let isSomeEmptyField = isSomeEmptyField()
        // let cleanWeightIsGreaterThanGross = cleanWeightIsGreaterThanGross()
        
        // let message = cleanWeightIsGreaterThanGross
        //    ? "O peso limpo deve ser menor ou igual que o peso bruto."
        //    : "Por favor, preencha os campos obrigatórios!"
        
        let message = "Por favor, preencha os campos obrigatórios!"
        
        let isBlockFlow =  isSomeEmptyField // || cleanWeightIsGreaterThanGross
        isBlockFlow ? showAlertAction(message) : didTapContinue(model)
    }

    private func configureMandatoryTextInTextFields() {
        let listTextField: [UITextField] = [grossWeightTextField, cleanWeightTextField]

        listTextField.forEach { textfield in
            if let text = textfield.text?.replacingOccurrences(of: " ", with: "") {
                if text.isEmpty {
                    textfield.layer.borderColor = UIColor.systemRed.cgColor
                } else {
                    textfield.layer.borderColor = UIColor.opaqueSeparator.cgColor
                }
            }
        }
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

extension RegisterManipulationSecondStepView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength: Int = 20
        let currentString = (textField.text.orEmpty) as NSString
        let newString = currentString.replacingCharacters(in: range, with: string)
     
        return newString.count <= maxLength
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
        textField.selectedTextRange = textField.textRange(from: textField.beginningOfDocument, to: textField.endOfDocument)
        
        if textField == cleanWeightTextField {
            cleanWeightTextField.layer.borderColor = UIColor.opaqueSeparator.cgColor
        }

        self.activeTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        guard let doubleValue = Double(text) else { return }
        textField.text = formatWeight(weightInKgs: doubleValue)
        
//        if textField == cleanWeightTextField {
//            if cleanWeightIsGreaterThanGross() {
//                cleanWeightTextField.layer.borderColor = UIColor.red.cgColor
//                let cleanWeightIsGreaterThanGross = cleanWeightIsGreaterThanGross()
//
//                let message = cleanWeightIsGreaterThanGross
//                    ? "O peso limpo deve ser menor ou igual que o peso bruto."
//                    : "Por favor, preencha os campos obrigatórios!"
//                showAlertAction(message)
//            }
//        }
        
        self.activeTextField = nil
    }

    private func cleanWeightIsGreaterThanGross() -> Bool {
        let cleanWeight = Double(cleanWeightTextField.text.orEmpty.nonAlphanumericsRemoved)
        let grossWeight = Double(grossWeightTextField.text.orEmpty.nonAlphanumericsRemoved)

        return cleanWeight ?? 0 > grossWeight ?? 0
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
        return false
    }

}


extension UITextField {

    func cleanTextWhenBeginEditing() {
        self.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingDidBegin)
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField.text != nil { textField.text = "" }
    }
}
