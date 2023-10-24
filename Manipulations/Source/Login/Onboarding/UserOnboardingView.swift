//
//  UserOnboardingView.swift
//  Manipulations
//
//  Created by Leonardo Portes on 05/04/23.
//

import UIKit
import FirebaseAuth

class UserOnboardingView: MNView {
    // MARK: - Private properties
    private let addUserOnboarding: (CreateUserModel) -> Void
    private let alertEmptyField: () -> Void

    // MARK: - Init
    init(
        addUserOnboarding: @escaping (CreateUserModel) -> Void,
        alertEmptyField: @escaping () -> Void
    ) {
        self.addUserOnboarding = addUserOnboarding
        self.alertEmptyField = alertEmptyField
        super.init()
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View
    lazy var titleLabel: MNLabel = {
        let label = MNLabel(
            text: "Olá, seja bem-vindo(a)!",
            font: UIFont.boldSystemFont(ofSize: 28),
            textColor: .darkGray
        )
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    lazy var subTitleLabel: MNLabel = {
        let label = MNLabel(
            text: "Preencha os dados abaixo para \n personalizarmos a sua experiência.",
            font: UIFont.systemFont(ofSize: 16),
            textColor: .lightGray
        )
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    lazy var containerStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nameTextField, barbershopTextField, cityTextField, stateTextField])
        stack.axis = .vertical
        stack.spacing = 24
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    lazy var nameTextField: CustomTextField = {
        let textField = CustomTextField(
            titlePlaceholder: "Digite seu nome",
            colorPlaceholder: .lightGray,
            textColor: .neutralHigh,
            radius: 5,
            borderColor: UIColor.systemGray.cgColor,
            borderWidth: 0.5
        )
        textField.delegate = self
        textField.heightAnchor(48)
        return textField
    }()


    lazy var barbershopTextField: CustomTextField = {
        let textField = CustomTextField(
            titlePlaceholder: "Digite o nome da sua empresa",
            colorPlaceholder: .lightGray,
            textColor: .neutralHigh,
            radius: 5,
            borderColor: UIColor.systemGray.cgColor,
            borderWidth: 0.5
        )
        textField.delegate = self
        textField.heightAnchor(48)
        return textField
    }()

    lazy var cityTextField: CustomTextField = {
        let textField = CustomTextField(
            titlePlaceholder: "Digite o nome da sua cidade",
            colorPlaceholder: .lightGray,
            textColor: .neutralHigh,
            radius: 5,
            borderColor: UIColor.systemGray.cgColor,
            borderWidth: 0.5
        )
        textField.delegate = self
        textField.heightAnchor(48)
        return textField
    }()

    lazy var stateTextField: CustomTextField = {
        let textField = CustomTextField(
            titlePlaceholder: "Digite o nome do seu estado. ex: SC",
            colorPlaceholder: .lightGray,
            textColor: .neutralHigh,
            radius: 5,
            borderColor: UIColor.systemGray.cgColor,
            borderWidth: 0.5
        )
        textField.delegate = self
        textField.heightAnchor(48)
        return textField
    }()

    lazy var continueButton: CustomSubmitButton = {
        let button = CustomSubmitButton(
            title: "Continuar",
            radius: 10,
            background: .neutralHigh
        )
        button.addTarget(self, action: #selector(handleButtonContinue), for: .touchUpInside)
        return button
    }()

    // MARK: - Actions

//    func checkIfItIsAppleLogin() {
//        let name = MNUserDefaults.get(stringForKey: MNKeys.nameAppleID) ?? .empty
//        let isLoginApple = MNUserDefaults.get(boolForKey: MNKeys.loginWithApple) ?? false
//        if isLoginApple {
//            titleLabel.text = "Olá \(name), \n seja bem-vindo(a)!"
//            nameTextField.text = name
//            nameTextField.isHidden = true
//        } else {
//            titleLabel.text = "Olá, seja bem-vindo(a)!"
//            nameTextField.text = .stringEmpty
//            nameTextField.isHidden = false
//        }
//    }

    func isSomeEmptyField() -> Bool {
        var result: Bool = false
        let name = nameTextField.text ?? .empty
        let typeJob = barbershopTextField.text ?? .empty
        let payment = cityTextField.text ?? .empty
        let value = stateTextField.text ?? .empty

        let someAreEmpty = name.isEmpty || typeJob.isEmpty || payment.isEmpty || value.isEmpty

        result = someAreEmpty ? true : false

        return result
    }

    @objc func handleButtonContinue() {
        if isSomeEmptyField() {
            alertEmptyField()
        } else {
            addUserOnboarding(
                CreateUserModel(
                    manangerName: nameTextField.text ?? .empty,
                    companyName: barbershopTextField.text ?? .empty,
                    document: "12393149000132",
                    city: cityTextField.text ?? .empty,
                    state: stateTextField.text ?? .empty,
                    streetAddress: "",
                    emailFirebase: Current.shared.email
                )
            )
        }
    }
}

extension UserOnboardingView: ViewCodeContract {
    func setupHierarchy() {
        addSubview(titleLabel)
        addSubview(subTitleLabel)
        addSubview(containerStack)
        addSubview(continueButton)
    }

    func setupConstraints() {
        titleLabel
            .topAnchor(in: self, attribute: .top, padding: 90)
            .leftAnchor(in: self, attribute: .left, padding: 16)
            .rightAnchor(in: self, attribute: .right, padding: 16)

        subTitleLabel
            .topAnchor(in: titleLabel, attribute: .bottom, padding: 16)
            .leftAnchor(in: self, attribute: .left, padding: 16)
            .rightAnchor(in: self, attribute: .right, padding: 16)

        containerStack
            .topAnchor(in: subTitleLabel, attribute: .bottom, padding: 30)
            .leftAnchor(in: self, attribute: .left, padding: 16)
            .rightAnchor(in: self, attribute: .right, padding: 16)

        continueButton
            .topAnchor(in: containerStack, attribute: .bottom, padding: 48)
            .leftAnchor(in: self, attribute: .left, padding: 16)
            .rightAnchor(in: self, attribute: .right, padding: 16)
            .heightAnchor(48)

    }

    func setupConfiguration() {
        backgroundColor = .white
        //        checkIfItIsAppleLogin()
    }

}

extension UserOnboardingView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var maxLength: Int = 32
        let currentString = (textField.text.orEmpty) as NSString
        let newString = currentString.replacingCharacters(in: range, with: string)

        if textField == stateTextField {
            maxLength = 2
        }
        return newString.count <= maxLength
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        self.activeTextField = nil
    }
}
