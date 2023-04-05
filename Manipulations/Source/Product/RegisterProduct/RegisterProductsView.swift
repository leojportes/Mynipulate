//
//  RegisterProductsView.swift
//  Manipulations
//
//  Created by Leonardo Portes on 07/02/23.
//

import Foundation
import UIKit

final class RegisterProductsView: MNView, ViewCodeContract {
    
    private let showAlertAction: Action
    private let didTapRegister: (String, ProductType) -> Void
    private let productTypes: [ProductType] = [.choiceLegend, .fish, .meat, .seafood]
    private var productType: ProductType = .choiceLegend

    // MARK: - Init
    init(
        showAlertAction: @escaping Action,
        didTapRegister: @escaping (String, ProductType) -> Void
    ) {
        self.showAlertAction = showAlertAction
        self.didTapRegister = didTapRegister
        super.init()
        setupView()
        backgroundColor = .back
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var productNameLabel = MNLabel(text: "Nome do produto")
    private lazy var productNameTextField = CustomTextField(
        titlePlaceholder: "Ex: Blue fin",
        radius: 10,
        borderColor: UIColor.opaqueSeparator.cgColor,
        borderWidth: 1
    ) .. {
        $0.delegate = self
        $0.returnKeyType = .continue
    }

    private lazy var productTypeLabel = MNLabel(text: "Tipo do produto")
    private lazy var productTypeTextField = CustomTextField(
        titlePlaceholder: "Ex: Peixe",
        radius: 10,
        borderColor: UIColor.opaqueSeparator.cgColor,
        borderWidth: 1
    ) .. {
        $0.delegate = self
        $0.inputView = pickerView
    }

    private lazy var pickerView = UIPickerView() .. {
        $0.delegate = self
        $0.dataSource = self
        $0.backgroundColor = .neutralLow
        $0.selectRow(0, inComponent: 0, animated: true)
        $0.frame = .init(x: 0, y: 0, width: 0, height: 180)
    }
    
    private(set) lazy var registerButton = CustomSubmitButton(
        title: "Cadastrar",
        colorTitle: .white,
        radius: 25,
        background: .purpleLight,
        borderColorCustom: UIColor.green.cgColor
    ) .. {
        $0.addTarget(self, action: #selector(didTapRegisterAction), for: .touchUpInside)
    }
    
    func setupHierarchy() {
        addSubview(productNameTextField)
        addSubview(productTypeTextField)
        addSubview(productNameLabel)
        addSubview(productTypeLabel)
        
        addSubview(registerButton)
    }
    
    func setupConstraints() {

        productNameLabel
            .topAnchor(in: self, padding: .xLarge2)
            .heightAnchor(22)
            .leftAnchor(in: self, padding: .medium)
            .rightAnchor(in: self, padding: .medium)
        
        productNameTextField
            .topAnchor(in: productNameLabel, attribute: .bottom, padding: .xSmall)
            .heightAnchor(45)
            .leftAnchor(in: self, padding: .medium)
            .rightAnchor(in: self, padding: .medium)
        
        productTypeLabel
            .topAnchor(in: productNameTextField, attribute: .bottom, padding: .medium)
            .heightAnchor(22)
            .leftAnchor(in: self, padding: .medium)
            .rightAnchor(in: self, padding: .medium)
    
        productTypeTextField
            .topAnchor(in: productTypeLabel, attribute: .bottom, padding: .xSmall)
            .heightAnchor(45)
            .leftAnchor(in: self, padding: .medium)
            .rightAnchor(in: self, padding: .medium)
        
        registerButton
            .heightAnchor(50)
            .leftAnchor(in: self, padding: 20)
            .rightAnchor(in: self, padding: 20)
            .bottomAnchor(in: self, padding: 20)
    }

    private func isSomeEmptyField() -> Bool {
        var result: Bool = false
        guard let productName = productNameTextField.text?.replacingOccurrences(of: " ", with: "") else { return false }
        guard let productType = productTypeTextField.text?.replacingOccurrences(of: " ", with: "") else { return false }

        let someAreEmpty = productName.isEmpty || productType.isEmpty || productType == ProductType.choiceLegend.rawValue

        result = someAreEmpty ? true : false

        return result
    }
    

    @objc func didTapRegisterAction() {
        configureMandatoryTextInTextFields()
        isSomeEmptyField()
            ? showAlertAction()
            : register()
    }

    private func register() {
        registerButton.loadingIndicator(show: true)
        return didTapRegister(productNameTextField.text.orEmpty, productType)
    }

    private func configureMandatoryTextInTextFields() {
        let listTextField: [UITextField] = [productNameTextField, productTypeTextField]

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
}

// MARK: - UIPickerViewDelegate & UIPickerViewDataSource
extension RegisterProductsView: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return productTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return productTypes[row].rawValue
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if productTypes[row] == .choiceLegend { return }
        productTypeTextField.text = productTypes[row].rawValue
        productType = productTypes[row]
        productTypeTextField.resignFirstResponder()
    }

}

extension RegisterProductsView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var maxLength: Int = 18
        let currentString = (textField.text.orEmpty) as NSString
        let newString = currentString.replacingCharacters(in: range, with: string)

        if textField == productNameTextField {
            maxLength = 30
        }

        return newString.count <= maxLength
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.activeTextField = nil
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
        return false
    }
}
