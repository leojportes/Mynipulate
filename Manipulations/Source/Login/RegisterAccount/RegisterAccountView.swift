//
//  RegisterAccountView.swift
//  Manipulations
//
//  Created by Leonardo Portes on 02/05/23.
//

import UIKit

class RegisterAccountView: UIView {

    private var isSecureTextEntry: Bool = false
    var createAccount: ((String, String) -> Void)?

    init() {
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var gripView = GripView()

    private lazy var eyeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "eye"), for: .normal)
        button.tintColor = .darkGray
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleEyeButton), for: .touchUpInside)
        return button
    }()

    private lazy var titleLabel: MNLabel = {
        let label = MNLabel(
            text: "Criar Conta",
            font: UIFont.boldSystemFont(ofSize: 20),
            textColor: .misteryGreen
        )
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()


    private lazy var subtitleLabel: MNLabel = {
        let label = MNLabel(
            text: "Informe um e-mail válido e uma senha com\nno minimo 8 caracteres para criar a sua conta.",
            font: UIFont.systemFont(ofSize: 16),
            textColor: .darkGray
        )
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private lazy var usernameTextField = CustomTextField(
            titlePlaceholder: "Informe um e-mail válido",
            colorPlaceholder: .neutral,
            textColor: .neutralHigh,
            radius: 10,
            borderColor: .neutral.cgColor,
            borderWidth: 1,
            keyboardType: .emailAddress
    )

    private lazy var passwordTextField = CustomTextField(
        titlePlaceholder: "Informe uma senha",
        colorPlaceholder: .neutral,
        textColor: .neutralHigh,
        radius: 10,
        borderColor: .neutral.cgColor,
        borderWidth: 1,
        isSecureTextEntry: true
    ) .. {
        $0.textContentType = .oneTimeCode
    }

    lazy var createAccountButton = CustomSubmitButton(
        title: "Criar conta",
        colorTitle: .back,
        radius: 25,
        background: .misteryGreen,
        borderColorCustom: UIColor.misteryGreen.cgColor,
        borderWidthCustom: 1
    ) .. {
        $0.addTarget(self, action: #selector(handleCreateAccountButton), for: .touchUpInside)
    }

    func isEnabledButtonCreateAccount(_ isEnabled: Bool) {
        if isEnabled {
            createAccountButton.backgroundColor = .misteryGreen
            createAccountButton.isEnabled = true
        } else {
            createAccountButton.backgroundColor = .misteryGreen.withAlphaComponent(0.7)
            createAccountButton.isEnabled = false
        }
    }

    // MARK: - Action Buttons
    @objc
    func handleCreateAccountButton() {
        guard let email = usernameTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        let isValidPassword = password.count > 7
        let isValidUsername = email.isValidEmail()

        setTextFieldValidationStates(isValidUsername, isValidPassword)
        if isValidUsername && isValidPassword {
            createAccountButton.loadingIndicator(show: true)
            createAccount?(usernameTextField.text.orEmpty, passwordTextField.text.orEmpty)
        }
    }

    private func setTextFieldValidationStates(_ isValidUsername: Bool, _ isValidPassword: Bool) {
        if isValidPassword.not && isValidUsername.not {
            usernameTextField.layer.borderColor = UIColor.orange.cgColor
            passwordTextField.layer.borderColor = UIColor.orange.cgColor
            obrigatoryFieldsLabel.isHidden = false
            shake(views: [usernameTextField, passwordTextField, eyeButton])
            return
            //     return showAlert(title: "Oops!", message: "E-mail e senha com formato inválido.\nPor favor, digite um e-mail válido e senha com no mínimo 8 caracteres.")
        }

        if isValidUsername.not {
            shake(views: [usernameTextField])
            obrigatoryFieldsLabel.isHidden = false
            usernameTextField.layer.borderColor = UIColor.orange.cgColor
            passwordTextField.layer.borderColor = .neutral.cgColor
            return
            // return showAlert(title: "Oops!", message: "E-mail com formato inválido.\nPor favor, digite um e-mail válido.")
        }

        if isValidPassword.not {
            usernameTextField.layer.borderColor = .neutral.cgColor
            passwordTextField.layer.borderColor = UIColor.orange.cgColor
            obrigatoryFieldsLabel.isHidden = false
            shake(views: [passwordTextField, eyeButton])
            return
            //  return showAlert(title: "Oops!", message: "A senha deve ser igual ou maior que 8 caracteres.")
        }
        obrigatoryFieldsLabel.isHidden = true
    }

    private let obrigatoryFieldsLabel = MNLabel(
        text: "Campo obrigatório",
        font: .systemFont(ofSize: .small),
        textColor: .orange
    ) .. {
        $0.isHidden = true
    }

    @objc
    func handleEyeButton() {
        if isSecureTextEntry {
            isSecureTextEntry = false
            eyeButton.setImage(UIImage(systemName: "eye"), for: .normal)
            passwordTextField.isSecureTextEntry = true
        } else {
            isSecureTextEntry = true
            eyeButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
            passwordTextField.isSecureTextEntry = false
        }
    }

    // MARK: - Aux methods
    private func shake(views: [UIView]) {
        views.forEach { view in
            view.transform = CGAffineTransform(translationX: 25, y: 0)
        }

        UIView.animate(
            withDuration: 0.4,
            delay: 0,
            usingSpringWithDamping: 0.2,
            initialSpringVelocity: 1,
            options: .curveEaseInOut,
            animations: {
                views.forEach { view in
                    view.transform = CGAffineTransform.identity
                }
            },
            completion: nil
        )
    }
}

extension RegisterAccountView: ViewCodeContract {
    func setupHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(gripView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(usernameTextField)
        contentView.addSubview(passwordTextField)
        contentView.addSubview(createAccountButton)
        contentView.addSubview(eyeButton)
        contentView.addSubview(obrigatoryFieldsLabel)
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

        gripView
            .topAnchor(in: self, attribute: .top, padding: 11)
            .centerX(in: self)
            .widthAnchor(32)
            .heightAnchor(4)

        titleLabel
            .topAnchor(in: gripView, attribute: .bottom, padding: 44)
            .centerX(in: self)

        subtitleLabel
            .topAnchor(in: titleLabel, attribute: .bottom, padding: 16)
            .centerX(in: self)

        usernameTextField
            .topAnchor(in: subtitleLabel, attribute: .bottom, padding: .xLarge5)
            .leftAnchor(in: contentView, attribute: .left, padding: 16)
            .rightAnchor(in: contentView, attribute: .right, padding: 16)
            .heightAnchor(48)

        passwordTextField
            .topAnchor(in: usernameTextField, attribute: .bottom, padding: 24)
            .leftAnchor(in: contentView, attribute: .left, padding: 16)
            .rightAnchor(in: contentView, attribute: .right, padding: 16)
            .heightAnchor(48)

        obrigatoryFieldsLabel
            .topAnchor(in: passwordTextField, attribute: .bottom, padding: .xMedium)
            .leftAnchor(in: contentView, attribute: .left, padding: 16)
            .rightAnchor(in: contentView, attribute: .right, padding: 16)

        eyeButton
            .topAnchor(in: usernameTextField, attribute: .bottom, padding: 24)
            .rightAnchor(in: passwordTextField)
            .widthAnchor(48)
            .heightAnchor(48)

        createAccountButton
            .bottomAnchor(in: contentView, padding: .large)
            .leftAnchor(in: contentView, attribute: .left, padding: 16)
            .rightAnchor(in: contentView, attribute: .right, padding: 16)
            .heightAnchor(48)

    }

    func setupConfiguration() {
        backgroundColor = .white
    }

}
