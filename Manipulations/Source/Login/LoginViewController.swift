//
//  LoginViewController.swift
//  Manipulations
//
//  Created by Leonardo Portes on 07/03/23.
//

import UIKit
import AVFoundation
import FirebaseAuth

final class LoginViewController: CoordinatedViewController {

    // MARK: - Private properties
    private let viewModel: LoginViewModel
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    private var isSecureTextEntry: Bool = false
    private let didRegisterAccount: () -> Void?

    // MARK: - Init
    init(
        viewModel: LoginViewModel,
        coordinator: CoordinatorProtocol,
        didRegisterAccount: @escaping () -> Void
    ) {
        self.viewModel = viewModel
        self.didRegisterAccount = didRegisterAccount
        super.init(coordinator: coordinator)
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        setupHierarchy()
        setupConstraints()
        setupBackgroundVideo()

        buttonContainerView.backgroundColor = .clear
        buttonContainerView.addSubview(loginKeyboardButton)
        loginKeyboardButton.translatesAutoresizingMaskIntoConstraints = false
        loginKeyboardButton.centerX(in: buttonContainerView)
        loginKeyboardButton.leftAnchor(in: buttonContainerView, padding: .medium)
        loginKeyboardButton.rightAnchor(in: buttonContainerView, padding: .medium)
        loginKeyboardButton.bottomAnchor(in: buttonContainerView, padding: .medium)
        loginKeyboardButton.heightAnchor(50)

        baseView.backgroundColor = .blackHigh.withAlphaComponent(0.4)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        if Auth.auth().currentUser != nil && viewModel.isInternetAvailable() {
//            viewModel.navigateToHome()
//        }
    }

    @objc func playerDidReachEnd() {
        player?.seek(to: CMTime.zero)
        player?.play()
    }

    private lazy var baseView = UIView() .. {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private let buttonContainerView = UIView(
        frame: CGRect(x: 0, y: 0, width: 200, height: .xLarge6)
    )

    // MARK: - View Code

    private lazy var eyeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "eye"), for: .normal)
        button.tintColor = .neutral
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleEyeButton), for: .touchUpInside)
        return button
    }()

    private lazy var titleLabel: MNLabel = {
        let label = MNLabel(
            text: "MANIPULE",
            font: UIFont.boldSystemFont(ofSize: 28),
            textColor: .back
        )
        label.textAlignment = .center
        label.numberOfLines = 0
        label.widthAnchor(100)
        return label
    }()

    private lazy var emailTextField: CustomTextField = {
        let textField = CustomTextField(
            titlePlaceholder: "e-mail cadastrado",
            colorPlaceholder: .white,
            textColor: .white,
            radius: 10,
            borderColor: UIColor.white.cgColor,
            borderWidth: 1,
            keyboardType: .emailAddress
        )
        textField.backgroundColor = .neutralHigh.withAlphaComponent(0.5)
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.clearButtonMode = .whileEditing
        textField.inputAccessoryView = buttonContainerView
        textField.addTarget(self, action: #selector(textFieldEditingDidChange), for: .editingChanged)
        textField.addTarget(self, action: #selector(didBeginEditingTF), for: .editingDidBegin)
        textField.addTarget(self, action: #selector(didEndEditingTF), for: .editingDidEnd)
        return textField
    }()

    private lazy var passwordTextField: CustomTextField = {
        let textField = CustomTextField(
            titlePlaceholder: "senha",
            colorPlaceholder: .white,
            textColor: .white,
            radius: 10,
            borderColor: UIColor.white.cgColor,
            borderWidth: 1,
            isSecureTextEntry: true
        )
        textField.backgroundColor = .neutralHigh.withAlphaComponent(0.5)
        textField.autocapitalizationType = .none
        textField.addTarget(self, action: #selector(textFieldEditingDidChange), for: .editingChanged)
        textField.addTarget(self, action: #selector(didBeginEditingTF), for: .editingDidBegin)
        textField.addTarget(self, action: #selector(didEndEditingTF), for: .editingDidEnd)
        textField.inputAccessoryView = buttonContainerView
        return textField
    }()
    
    private lazy var loginKeyboardButton: CustomSubmitButton = {
        let button = CustomSubmitButton(
            title: "Entrar",
            colorTitle: .neutralHigh,
            radius: 25,
            background: .white.withAlphaComponent(0.7),
            borderColorCustom: UIColor.white.cgColor,
            borderWidthCustom: 1
        )
        button.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        return button
    }()

    private lazy var loginButton: CustomSubmitButton = {
        let button = CustomSubmitButton(
            title: "Entrar",
            colorTitle: .neutralHigh,
            radius: 25,
            background: .white.withAlphaComponent(0.7),
            borderColorCustom: UIColor.white.cgColor,
            borderWidthCustom: 1
        )
        button.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var forgotPasswordStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [forgotPasswordLabel, forgotPasswordButton])
        stack.axis = .horizontal
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var forgotPasswordLabel: UILabel = {
        let label = UILabel()
        label.text = "Esqueceu sua senha? "
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var forgotPasswordButton: CustomSubmitButton = {
        let button = CustomSubmitButton(
            title: "Clique aqui!",
            colorTitle: .darkGray,
            alignmentText: .left
        )
//        button.addTarget(self, action: #selector(handleForgotPasswordButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var registerStackView: UIStackView = {
        let container = UIStackView(arrangedSubviews: [registerLabel, registerButton])
        container.axis = .horizontal
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    private lazy var registerLabel: UILabel = {
        let label = UILabel()
        label.text = "Não tem uma conta? "
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var registerButton: CustomSubmitButton = {
        let button = CustomSubmitButton(
            title: "Registre-se",
            colorTitle: .systemGray
        )
        button.addTarget(self, action: #selector(didTapRegisterAccount), for: .touchUpInside)
        return button
    }()

    private func isEnabledButtonLogin(_ isEnabled: Bool) {
        loginKeyboardButton.isEnabled = isEnabled
        loginButton.isEnabled = isEnabled
    }

    @objc func didTapLoginButton(_ sender: UIButton) {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        let isInvalidPasswordFormat = (password.count > 7).not
        let invalidEmailFormat = email.isValidEmail().not

        if isInvalidPasswordFormat && invalidEmailFormat {
            return showAlert(title: "Oops!", message: "E-mail e senha com formato inválido.\nPor favor, digite um e-mail válido e senha com 7 ou mais caracteres.")
        }

        if invalidEmailFormat {
            return showAlert(title: "Oops!", message: "E-mail com formato inválido.\nPor favor, digite um e-mail válido.")
        }

        if isInvalidPasswordFormat {
            return showAlert(title: "Oops!", message: "A senha deve ter mais que 7 caracteres.")
        }

        if invalidEmailFormat.not && isInvalidPasswordFormat.not {
            if sender == loginButton {
                loginButton.loadingIndicator(show: true)
            } else {
                loginKeyboardButton.loadingIndicator(show: true)
            }
            didTapLogin()
        }

    }

    // MARK: - Actions methods

    private func didTapLogin() {
        viewModel.authLogin(emailTextField.text.orEmpty, passwordTextField.text.orEmpty) { [weak self] onSuccess, descriptionError in
            onSuccess
                ? self?.checkNewUser()
                : self?.showError(descriptionError)
        }
    }

    private func showError( _ descriptionError: String) {
        showAlert(title: "Atenção", message: descriptionError)
        loginButton.loadingIndicator(show: false)
        loginKeyboardButton.loadingIndicator(show: false)
    }

    private func checkNewUser() {
        if Current.shared.isEmailVerified.not {
            DispatchQueue.main.async {
                self.viewModel.navigateToCheckYourAccount()
            }
            return
        }
        self.loginButton.loadingIndicator(show: false)
        self.loginKeyboardButton.loadingIndicator(show: false)
        viewModel.fetchUser { [weak self] result in
            DispatchQueue.main.async {
                if result.isEmpty {
                    self?.viewModel.navigateToUserOnboarding()
                } else {
                    guard let email = Auth.auth().currentUser?.email else { return }
                    MNUserDefaults.set(model: result.first, forKey: .currentUser)
                    MNUserDefaults.set(value: true, forString: email)
                    self?.viewModel.navigateToHome()
                }
            }
        }
    }

    @objc func didTapRegisterAccount() {
        didRegisterAccount()
    }

    @objc func didBeginEditingTF(_ sender: UITextField) {
        loginButton.isHidden = true
    }

    @objc func didEndEditingTF(_ sender: UITextField) {
        loginButton.isHidden = false
    }

    func setupBackgroundVideo() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(playerDidReachEnd),
            name: .AVPlayerItemDidPlayToEndTime,
            object: player?.currentItem
        )

        // 2. Crie uma visualização de reprodução de vídeo.
        let videoURL = Bundle.main.url(forResource: "fishBackgroundHome", withExtension: "mov")!
        player = AVPlayer(url: videoURL)
        player?.actionAtItemEnd = .none
        player?.isMuted = true // desative o som se necessário
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = view.bounds
        playerLayer?.videoGravity = .resizeAspectFill

        if let playerLayer2 = playerLayer {
            view.layer.insertSublayer(playerLayer2, at: 0)
        }
    
        player?.play()
    }

}

extension LoginViewController {

    // MARK: - Action TextFields
    @objc private func textFieldEditingDidChange() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        let isValidLogin = email.isValidEmail() && password.count > 7

        isEnabledButtonLogin(isValidLogin)

    }
        
    @objc
    private func handleEyeButton() {
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

    func setupHierarchy() {
        view.addSubview(baseView)
        baseView.addSubview(titleLabel)
        baseView.addSubview(emailTextField)
        baseView.addSubview(passwordTextField)
        baseView.addSubview(eyeButton)
        baseView.addSubview(loginKeyboardButton)
        baseView.addSubview(loginButton)
        baseView.addSubview(forgotPasswordStackView)
        baseView.addSubview(registerStackView)
    }

    func setupConstraints() {
        
        baseView.pin(toEdgesOf: view)
        
        titleLabel
            .topAnchor(in: baseView, attribute: .top, padding: 80)
            .centerX(in: baseView)
            .leftAnchor(in: baseView)
            .rightAnchor(in: baseView)

        emailTextField
            .topAnchor(in: titleLabel, attribute: .bottom, padding: 50)
            .leftAnchor(in: baseView, attribute: .left, padding: 16)
            .rightAnchor(in: baseView, attribute: .right, padding: 16)
            .heightAnchor(48)

        passwordTextField
            .topAnchor(in: emailTextField, attribute: .bottom, padding: 24)
            .leftAnchor(in: baseView, attribute: .left, padding: 16)
            .rightAnchor(in: baseView, attribute: .right, padding: 16)
            .heightAnchor(48)

        eyeButton
            .topAnchor(in: emailTextField, attribute: .bottom, padding: 24)
            .rightAnchor(in: passwordTextField)
            .widthAnchor(48)
            .heightAnchor(48)

        loginButton
            .topAnchor(in: passwordTextField, attribute: .bottom, padding: 100)
            .leftAnchor(in: baseView, attribute: .left, padding: 16)
            .rightAnchor(in: baseView, attribute: .right, padding: 16)
            .heightAnchor(48)

        forgotPasswordStackView
            .topAnchor(in: loginButton, attribute: .bottom, padding: 14)
            .centerX(in: baseView)

        registerStackView
            .bottomAnchor(in: baseView, attribute: .bottom, padding: 20)
            .centerX(in: baseView)
    }

}
