//
//  RegisterContributorsView.swift
//  Manipulations
//
//  Created by Leonardo Portes on 15/02/23.
//

import UIKit

final class RegisterContributorsView: MNView, ViewCodeContract {
    
    private let showAlertAction: Action
    private let didTapRegister: (RegisterContributor) -> Void

    // MARK: - Init
    init(
        showAlertAction: @escaping Action,
        didTapRegister: @escaping (RegisterContributor) -> Void
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

    private lazy var nameLabel = MNLabel(text: "Nome do colaborador")
    private lazy var nameTextField = CustomTextField(
        titlePlaceholder: "Ex: José da Silva Pereira",
        radius: 10,
        borderColor: UIColor.opaqueSeparator.cgColor,
        borderWidth: 1
    ) .. {
        $0.delegate = self
        $0.returnKeyType = .continue
    }

    private lazy var idLabel = MNLabel(text: "Identificação")
    private lazy var idTextField = CustomTextField(
        titlePlaceholder: "Ex: #000049405",
        radius: 10,
        borderColor: UIColor.opaqueSeparator.cgColor,
        borderWidth: 1
    ) .. {
        $0.delegate = self
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
        addSubview(nameTextField)
        addSubview(idTextField)
        addSubview(nameLabel)
        addSubview(idLabel)
        
        addSubview(registerButton)
    }
    
    func setupConstraints() {

        nameLabel
            .topAnchor(in: self, padding: .xLarge2)
            .heightAnchor(22)
            .leftAnchor(in: self, padding: .medium)
            .rightAnchor(in: self, padding: .medium)
        
        nameTextField
            .topAnchor(in: nameLabel, attribute: .bottom, padding: .xSmall)
            .heightAnchor(45)
            .leftAnchor(in: self, padding: .medium)
            .rightAnchor(in: self, padding: .medium)
        
        idLabel
            .topAnchor(in: nameTextField, attribute: .bottom, padding: .medium)
            .heightAnchor(22)
            .leftAnchor(in: self, padding: .medium)
            .rightAnchor(in: self, padding: .medium)
    
        idTextField
            .topAnchor(in: idLabel, attribute: .bottom, padding: .xSmall)
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
        guard let name = nameTextField.text?.replacingOccurrences(of: " ", with: "") else { return false }
        guard let id = idTextField.text?.replacingOccurrences(of: " ", with: "") else { return false }
        let someAreEmpty = name.isEmpty || id.isEmpty
        result = someAreEmpty ? true : false
        return result
    }
    

    @objc func didTapRegisterAction() {
        configureMandatoryTextInTextFields()
        if isSomeEmptyField() {
            showAlertAction()
        } else {
            register()
        }
    }

    private func register() {
        let model = RegisterContributor(
            emailFirebase: Current.shared.email,
            documentBusiness: "Current.session.document",
            name: nameTextField.text.orEmpty,
            id: idTextField.text.orEmpty
        )
        registerButton.loadingIndicator(show: true)
        didTapRegister(model)
    }
    
    private func configureMandatoryTextInTextFields() {
        let listTextField: [UITextField] = [nameTextField, idTextField]
        
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

extension RegisterContributorsView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var maxLength: Int = 18
        let currentString = (textField.text.orEmpty) as NSString
        let newString = currentString.replacingCharacters(in: range, with: string)

        if textField == nameTextField {
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
