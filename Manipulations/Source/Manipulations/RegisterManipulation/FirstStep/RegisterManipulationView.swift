//
//  RegisterManipulationView.swift
//  Manipulations
//
//  Created by Leonardo Portes on 28/02/23.
//

public struct RegisterManipulationFirstStep {
    let productName: String
    let productType: ProductType
    let responsible: String
    let supply: String
    let date: String
}

import UIKit

final class RegisterManipulationView: MNView, ViewCodeContract {
    
    private let showAlertAction: Action
    private let didTapContinue: (RegisterManipulationFirstStep) -> Void
    private var date: String? = nil
    // List of contributors
    private let contributors: [Contributor]
    
    // List of products
    private let products: [Product]
    
    // MARK: - Init
    init(
        showAlertAction: @escaping Action,
        didTapContinue: @escaping (RegisterManipulationFirstStep) -> Void,
        contributors: [Contributor],
        products: [Product]
    ) {
        self.showAlertAction = showAlertAction
        self.didTapContinue = didTapContinue
        self.products = products
        self.contributors = contributors
        super.init()
        setupView()
        configureDatePickerView()
        backgroundColor = .back
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var productNameLabel = MNLabel(text: "Produto")
    private lazy var productNameTextField = CustomTextField(
        titlePlaceholder: "Ex: Salmão",
        radius: 10,
        borderColor: UIColor.opaqueSeparator.cgColor,
        borderWidth: 1
    ) .. {
        $0.delegate = self
        $0.inputView = productPickerView
    }
    
    private lazy var productPickerView = UIPickerView() .. {
        $0.delegate = self
        $0.dataSource = self
        $0.backgroundColor = .neutralLow
        $0.frame = .init(x: 0, y: 0, width: 0, height: 180)
    }
    
    private lazy var responsibleLabel = MNLabel(text: "Responsável")
    private lazy var responsibleTextField = CustomTextField(
        titlePlaceholder: "Ex: João da Silva",
        radius: 10,
        borderColor: UIColor.opaqueSeparator.cgColor,
        borderWidth: 1
    ) .. {
        $0.delegate = self
        $0.inputView = responsiblePickerView
    }
    
    private lazy var responsiblePickerView = UIPickerView() .. {
        $0.delegate = self
        $0.dataSource = self
        $0.backgroundColor = .neutralLow
        $0.frame = .init(x: 0, y: 0, width: 0, height: 180)
    }
    
    private lazy var dateLabel = MNLabel(text: "Data")
    
    private lazy var supplierLabel = MNLabel(text: "Fornecedor")
    private lazy var supplierTextField = CustomTextField(
        titlePlaceholder: "Ex: Pescados Silva LTDA",
        radius: 10,
        borderColor: UIColor.opaqueSeparator.cgColor,
        borderWidth: 1
    ) .. {
        $0.delegate = self
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
    
    private lazy var datePicker = UIDatePicker() .. {
        $0.datePickerMode = .date
        $0.locale = Locale(identifier: "pt-BR")
        $0.calendar = Calendar(identifier: .gregorian)
        $0.timeZone = TimeZone(identifier: "pt-BR")
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private func configureDatePickerView() {
        datePicker.tintColor = .neutralHigh
        datePicker.isUserInteractionEnabled = true
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let minimumDate = formatter.date(from: "01/09/2022")
        datePicker.minimumDate = minimumDate
        datePicker.calendar.locale = Locale(identifier: "pt-BR")
        datePicker.timeZone = TimeZone(identifier: "America/Sao_Paulo")
        datePicker.addTarget(self, action: #selector(editingDidEndPicker), for: .editingDidEnd)
        
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yyyy"
        let dateString = df.string(from: datePicker.date)
        date = dateString
    }

    @objc func editingDidEndPicker(_ sender: UIDatePicker) {
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yyyy"
        let dateString = df.string(from: sender.date)
        date = dateString
    }
    
    private lazy var stepsView = RoundedStepView(step: .first)
    
    func setupHierarchy() {
        addSubview(stepsView)

        addSubview(productNameLabel)
        addSubview(productNameTextField)

        addSubview(responsibleLabel)
        addSubview(responsibleTextField)

        addSubview(dateLabel)
        addSubview(datePicker)
        
        addSubview(supplierLabel)
        addSubview(supplierTextField)
        
       
        addSubview(registerButton)
    }

    func setupConstraints() {
        
        stepsView
            .topAnchor(in: self, padding: .medium)
            .centerX(in: self)
            .heightAnchor(25)
            .widthAnchor(70)

        productNameLabel
            .topAnchor(in: self, padding: .xLarge4)
            .heightAnchor(22)
            .leftAnchor(in: self, padding: .medium)
            .rightAnchor(in: self, padding: .medium)
        
        productNameTextField
            .topAnchor(in: productNameLabel, attribute: .bottom, padding: .xSmall2)
            .heightAnchor(45)
            .leftAnchor(in: self, padding: .medium)
            .rightAnchor(in: self, padding: .medium)
        
        responsibleLabel
            .topAnchor(in: productNameTextField, attribute: .bottom, padding: .medium)
            .heightAnchor(22)
            .leftAnchor(in: self, padding: .medium)
            .rightAnchor(in: self, padding: .medium)
    
        responsibleTextField
            .topAnchor(in: responsibleLabel, attribute: .bottom, padding: .xSmall2)
            .heightAnchor(45)
            .leftAnchor(in: self, padding: .medium)
            .rightAnchor(in: self, padding: .medium)
        
        supplierLabel
            .topAnchor(in: responsibleTextField, attribute: .bottom, padding: .medium)
            .heightAnchor(22)
            .leftAnchor(in: self, padding: .medium)
            .rightAnchor(in: self, padding: .medium)
        
        supplierTextField
            .topAnchor(in: supplierLabel, attribute: .bottom, padding: .xSmall2)
            .heightAnchor(45)
            .leftAnchor(in: self, padding: .medium)
            .rightAnchor(in: self, padding: .medium)
        
        dateLabel
            .topAnchor(in: supplierTextField, attribute: .bottom, padding: .medium)
            .heightAnchor(22)
            .leftAnchor(in: self, padding: .medium)
        
        datePicker
            .topAnchor(in: dateLabel, attribute: .bottom, padding: .xSmall2)
            .leftAnchor(in: self, padding: .medium)
        
        registerButton
            .heightAnchor(50)
            .leftAnchor(in: self, padding: 20)
            .rightAnchor(in: self, padding: 20)
            .bottomAnchor(in: self, padding: 20)
    }

    private func isSomeEmptyField() -> Bool {
        var result: Bool = false
        let productText = productNameTextField.text ?? ""
        let responsibleText = responsibleTextField.text ?? ""
        let supplyerText = supplierTextField.text ?? ""

        let someAreEmpty = productText.isEmpty || responsibleText.isEmpty || supplyerText.isEmpty

        result = someAreEmpty ? true : false

        return result
    }
    

    @objc func didTapRegisterAction() {
        
        let product = products.filter { $0.name == productNameTextField.text.orEmpty }.first
        
        configureMandatoryTextInTextFields()
        let model = RegisterManipulationFirstStep(
            productName: productNameTextField.text.orEmpty,
            productType: product?.type ?? .fish,
            responsible: responsibleTextField.text.orEmpty,
            supply: supplierTextField.text.orEmpty,
            date: date.orEmpty
        )

        isSomeEmptyField()
            ? showAlertAction()
            : didTapContinue(model)
    }

    private func configureMandatoryTextInTextFields() {
        let listTextField: [UITextField] = [productNameTextField, responsibleTextField, supplierTextField]
        
        listTextField.forEach { textfield in
            if let text = textfield.text {
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
extension RegisterManipulationView: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerView == productPickerView ? products.count + 1 : contributors.count + 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let isFirstRow = row == 0
        if isFirstRow {
            return pickerView == productPickerView ? retrieveProductPickerViewLegend() : retrieveContributorsPickerViewLegend()
        }
        return pickerView == productPickerView ? products[row - 1].name : contributors[row - 1].name
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let notFirstRow = row != 0
        if notFirstRow {
            if pickerView == productPickerView {
                productNameTextField.text = products[row - 1].name
                productNameTextField.resignFirstResponder()
            } else if pickerView == responsiblePickerView {
                responsibleTextField.text = contributors[row - 1].name
                responsibleTextField.resignFirstResponder()
            }
        }
    }

    private func retrieveProductPickerViewLegend() -> String {
        products.isEmpty ? "Nenhum produto cadastrado" : "Escolha um produto abaixo"
    }

    private func retrieveContributorsPickerViewLegend() -> String {
        contributors.isEmpty ? "Nenhum colaborador cadastrado" : "Escolha um colaborador"
    }

}

extension RegisterManipulationView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var maxLength: Int = 18
        let currentString = (textField.text.orEmpty) as NSString
        let newString = currentString.replacingCharacters(in: range, with: string)

        if textField == supplierTextField {
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
