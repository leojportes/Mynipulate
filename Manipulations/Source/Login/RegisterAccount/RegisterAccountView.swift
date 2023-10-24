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
    var closedView: Action?

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
            textColor: .darkGray
        )
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()


    private lazy var subTitleLabel: MNLabel = {
        let label = MNLabel(text: "Informe um e-mail válido e uma senha com \n no minimo 8 dígitos para criar a sua conta.",
                            font: UIFont.systemFont(ofSize: 16),
                            textColor: .darkGray)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    lazy var emailTextField: CustomTextField = {
        let textField = CustomTextField(
            titlePlaceholder: "e-mail",
            colorPlaceholder: .lightGray,
            textColor: .darkGray,
            radius: 5,
            borderColor: UIColor.systemGray.cgColor,
            borderWidth: 0.5,
            keyboardType: .emailAddress
        )
        textField.addTarget(self, action: #selector(handleTextFieldDidChange(_:)), for: .editingChanged)
        return textField
    }()

    lazy var passwordTextField: CustomTextField = {
        let textField = CustomTextField(
            titlePlaceholder: "senha",
            colorPlaceholder: .lightGray,
            textColor: .darkGray,
            radius: 5,
            borderColor: UIColor.systemGray.cgColor,
            borderWidth: 0.5,
            isSecureTextEntry: true
        )
        textField.textContentType = .oneTimeCode
        textField.addTarget(self, action: #selector(handleTextFieldDidChange(_:)), for: .editingChanged)
        return textField
    }()

    lazy var createAccountButton: CustomSubmitButton = {
        let button = CustomSubmitButton(
            title: "Criar conta",
            colorTitle: .purpleLight,
            radius: 25,
            background: .clear,
            borderColorCustom: UIColor.purpleLight.cgColor,
            borderWidthCustom: 1
        )
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleCreateAccountButton), for: .touchUpInside)
        return button
    }()

    func isEnabledButtonCreateAccount(_ isEnabled: Bool) {
        if isEnabled {
            createAccountButton.backgroundColor = .white.withAlphaComponent(0.7)
            createAccountButton.isEnabled = true
        } else {
            createAccountButton.backgroundColor = .white.withAlphaComponent(0.7)
            createAccountButton.isEnabled = false
        }
    }

    // MARK: - Action TextFields
    @objc
    func handleTextFieldDidChange(_ textField: UITextField) {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        let isInvalidPasswordFormat = (password.count > 7).not
        let isInvalidEmailFormat = email.isValidEmail().not

        emailTextField.layer.borderColor = isInvalidEmailFormat
            ? UIColor.systemRed.cgColor
            : UIColor.systemGray.cgColor

        passwordTextField.layer.borderColor = isInvalidPasswordFormat
            ? UIColor.systemRed.cgColor
            : UIColor.systemGray.cgColor

        if isInvalidEmailFormat.not && isInvalidPasswordFormat.not {
            createAccountButton.isEnabled = true
        }
    }

    // MARK: - Action Buttons
    @objc
    func handleCreateAccountButton() {
        createAccountButton.loadingIndicator(show: true)
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        let isInvalidPasswordFormat = (password.count > 7).not
        let isInvalidEmailFormat = email.isValidEmail().not

        if isInvalidEmailFormat.not && isInvalidPasswordFormat.not {
            createAccount?(emailTextField.text.orEmpty, passwordTextField.text.orEmpty)
        }

    }

    @objc
    func handleEyeButton() {
        if isSecureTextEntry {
            isSecureTextEntry = false
            eyeButton.setImage(UIImage(systemName: "eye"), for: .normal)
            passwordTextField.isSecureTextEntry = true
        }else {
            isSecureTextEntry = true
            eyeButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
            passwordTextField.isSecureTextEntry = false
        }
    }

}

extension RegisterAccountView: ViewCodeContract {
    func setupHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(gripView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(emailTextField)
        contentView.addSubview(passwordTextField)
        contentView.addSubview(createAccountButton)
        contentView.addSubview(eyeButton)
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

        subTitleLabel
            .topAnchor(in: titleLabel, attribute: .bottom, padding: 16)
            .centerX(in: self)

        emailTextField
            .topAnchor(in: subTitleLabel, attribute: .bottom, padding: .xLarge5)
            .leftAnchor(in: contentView, attribute: .left, padding: 16)
            .rightAnchor(in: contentView, attribute: .right, padding: 16)
            .heightAnchor(48)

        passwordTextField
            .topAnchor(in: emailTextField, attribute: .bottom, padding: 24)
            .leftAnchor(in: contentView, attribute: .left, padding: 16)
            .rightAnchor(in: contentView, attribute: .right, padding: 16)
            .heightAnchor(48)

        eyeButton
            .topAnchor(in: emailTextField, attribute: .bottom, padding: 24)
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
