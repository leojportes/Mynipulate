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
    // MARK: - Dependencies
    private let viewModel: LoginViewModel

    // MARK: - Actions properties
    private let didRegisterAccount: () -> Void?
    private let didTapRecoveryPassword: (String) -> Void?

    // MARK: - Private properties
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    private var isSecureTextEntry: Bool = false

    // MARK: - Init
    init(
        viewModel: LoginViewModel,
        coordinator: CoordinatorProtocol,
        didRegisterAccount: @escaping () -> Void,
        didTapRecoveryPassword: @escaping (String) -> Void
    ) {
        self.viewModel = viewModel
        self.didRegisterAccount = didRegisterAccount
        self.didTapRecoveryPassword = didTapRecoveryPassword
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
    }

    // MARK: - View Code
    private lazy var baseView = UIView() .. {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .blackHigh.withAlphaComponent(0.4)
    }

    private lazy var buttonContainerView = UIView(
        frame: CGRect(x: 0, y: 0, width: 200, height: .xLarge6)
    ) .. {
        $0.backgroundColor = .clear
    }

    private lazy var eyeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "eye"), for: .normal)
        button.tintColor = .neutral
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleEyeButton), for: .touchUpInside)
        return button
    }()

    private lazy var titleLabel = MNLabel(
        text: "Manipule",
        font: .semiBold.withSize(.xLarge2),
        textColor: .back
    ) .. {
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }

    private let usernameLabel = MNLabel(text: "Email", font: .boldSystemFont(ofSize: .medium), textColor: .back)

    private lazy var usernameTextField = CustomTextField(
        titlePlaceholder: "Informe seu e-mail",
        colorPlaceholder: .neutralLow,
        textColor: .white,
        radius: 10,
        borderColor: UIColor.white.cgColor,
        borderWidth: 1,
        keyboardType: .emailAddress
    ) .. {
        $0.backgroundColor = .neutralHigh.withAlphaComponent(0.5)
        $0.autocapitalizationType = .none
        $0.autocorrectionType = .no
        $0.clearButtonMode = .whileEditing
        $0.inputAccessoryView = buttonContainerView
        $0.addTarget(self, action: #selector(textFieldEditingDidChange), for: .editingChanged)
        $0.addTarget(self, action: #selector(didBeginEditingTF), for: .editingDidBegin)
        $0.addTarget(self, action: #selector(didEndEditingTF), for: .editingDidEnd)
    }

    private let passwordLabel = MNLabel(text: "Senha", font: .boldSystemFont(ofSize: .medium), textColor: .back)
    private lazy var passwordTextField = CustomTextField(
        titlePlaceholder: "Informe sua senha de acesso",
        colorPlaceholder: .neutralLow,
        textColor: .white,
        radius: 10,
        borderColor: UIColor.white.cgColor,
        borderWidth: 1,
        isSecureTextEntry: true
    ) .. {
        $0.backgroundColor = .neutralHigh.withAlphaComponent(0.5)
        $0.autocapitalizationType = .none
        $0.addTarget(self, action: #selector(textFieldEditingDidChange), for: .editingChanged)
        $0.addTarget(self, action: #selector(didBeginEditingTF), for: .editingDidBegin)
        $0.addTarget(self, action: #selector(didEndEditingTF), for: .editingDidEnd)
        $0.inputAccessoryView = buttonContainerView
    }
    
    private lazy var loginKeyboardButton = CustomSubmitButton(
        title: "Entrar",
        colorTitle: .back,
        radius: 25,
        background: .misteryGreen.withAlphaComponent(0.7),
        borderColorCustom: UIColor.misteryGreen.cgColor,
        borderWidthCustom: 1
    ) .. {
        $0.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
    }

    private lazy var loginButton = CustomSubmitButton(
        title: "Entrar",
        colorTitle: .back,
        radius: 25,
        background: .misteryGreen.withAlphaComponent(0.7),
        borderColorCustom: UIColor.misteryGreen.cgColor,
        borderWidthCustom: 1
    ) .. {
        $0.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
    }
    
    private lazy var forgotPasswordStackView = UIStackView(
        arrangedSubviews: [forgotPasswordButton]
    ) .. {
        $0.axis = .horizontal
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private lazy var forgotPasswordButton = CustomSubmitButton(
        title: "Esqueci minha senha",
        colorTitle: .back,
        alignmentText: .left,
        fontSize: .xMedium,
        action: weakify { $0.handleForgotPasswordButton() }
    )
    
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

    private lazy var registerButton = CustomSubmitButton(
        title: "Registre-se",
        colorTitle: .systemGray,
        action: weakify { $0.didRegisterAccount() }
    )

    // MARK: - API methods
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

    // MARK: - Action methods
    @objc func didTapLoginButton(_ sender: UIButton) {
        guard let email = usernameTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        let isValidPassword = password.count > 7
        let isvalidUsername = email.isValidEmail()

        if isValidPassword.not && isvalidUsername.not {
            shake(views: [usernameTextField, passwordTextField, eyeButton])
            return showAlert(title: "Oops!", message: "E-mail e senha com formato inválido.\nPor favor, digite um e-mail válido e senha com no mínimo 8 caracteres.")
        }

        if isvalidUsername.not {
            shake(views: [usernameTextField])
            return showAlert(title: "Oops!", message: "E-mail com formato inválido.\nPor favor, digite um e-mail válido.")
        }

        if isValidPassword.not {
            shake(views: [passwordTextField, eyeButton])
            return showAlert(title: "Oops!", message: "A senha deve ser igual ou maior que 8 caracteres.")
        }

        if isvalidUsername && isValidPassword {
            if sender == loginButton {
                loginButton.loadingIndicator(show: true)
            } else {
                loginKeyboardButton.loadingIndicator(show: true)
            }
            didTapLogin()
        }
    }

    private func didTapLogin() {
        viewModel.authLogin(
            usernameTextField.text.orEmpty,
            passwordTextField.text.orEmpty
        ) { [weak self] onSuccess, descriptionError in
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

    @objc func didTapRegisterAccount() {
        didRegisterAccount()
    }

    @objc func didBeginEditingTF(_ sender: UITextField) {
        loginButton.isHidden = true
    }

    @objc func didEndEditingTF(_ sender: UITextField) {
        loginButton.isHidden = false
    }

    @objc
    private func handleForgotPasswordButton() {
        let email = usernameTextField.text.orEmpty
        didTapRecoveryPassword(email)
    }

    @objc func playerDidReachEnd() {
        player?.seek(to: CMTime.zero)
        player?.play()
    }

    // MARK: - Action TextFields
    @objc private func textFieldEditingDidChange() {
        guard let email = usernameTextField.text else { return }
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

    // MARK: - Aux methods
    private func isEnabledButtonLogin(_ isEnabled: Bool) {
        loginButton.backgroundColor = isEnabled ? .misteryGreen : .misteryGreen.withAlphaComponent(0.7)
        loginButton.isEnabled = isEnabled
        loginKeyboardButton.backgroundColor = isEnabled ? .misteryGreen : .misteryGreen.withAlphaComponent(0.7)
        loginKeyboardButton.isEnabled = isEnabled
    }

    private func setupBackgroundVideo() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(playerDidReachEnd),
            name: .AVPlayerItemDidPlayToEndTime,
            object: player?.currentItem
        )

        let videoURL = Bundle.main.url(forResource: "fishBackgroundHome", withExtension: "mov")!
        player = AVPlayer(url: videoURL)
        player?.actionAtItemEnd = .none
        player?.isMuted = true
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = view.bounds
        playerLayer?.videoGravity = .resizeAspectFill

        if let playerLayer2 = playerLayer {
            view.layer.insertSublayer(playerLayer2, at: 0)
        }
        player?.play()
    }

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

// MARK: - Setup view
extension LoginViewController {
    func setupHierarchy() {
        view.addSubview(baseView)
        baseView.addSubview(titleLabel)
        baseView.addSubview(usernameLabel)
        baseView.addSubview(usernameTextField)
        baseView.addSubview(passwordLabel)
        baseView.addSubview(passwordTextField)
        baseView.addSubview(eyeButton)
        baseView.addSubview(loginKeyboardButton)
        baseView.addSubview(loginButton)
        baseView.addSubview(forgotPasswordStackView)
        baseView.addSubview(registerStackView)
        buttonContainerView.addSubview(loginKeyboardButton)
    }

    func setupConstraints() {
        
        baseView.pin(toEdgesOf: view)
        
        titleLabel
            .topAnchor(in: baseView, attribute: .top, padding: .xLarge8)
            .centerX(in: baseView)
            .leftAnchor(in: baseView)
            .rightAnchor(in: baseView)
            .widthAnchor(100)

        usernameLabel
            .topAnchor(in: titleLabel, attribute: .bottom, padding: 50)
            .leftAnchor(in: baseView, attribute: .left, padding: .medium)
            .rightAnchor(in: baseView, attribute: .right, padding: .medium)

        usernameTextField
            .topAnchor(in: usernameLabel, attribute: .bottom, padding: .xSmall)
            .leftAnchor(in: baseView, attribute: .left, padding: .medium)
            .rightAnchor(in: baseView, attribute: .right, padding: .medium)
            .heightAnchor(.xLarge4)

        passwordLabel
            .topAnchor(in: usernameTextField, attribute: .bottom, padding: .xLarge)
            .leftAnchor(in: baseView, attribute: .left, padding: .medium)
            .rightAnchor(in: baseView, attribute: .right, padding: .medium)

        passwordTextField
            .topAnchor(in: passwordLabel, attribute: .bottom, padding: .xSmall)
            .leftAnchor(in: baseView, attribute: .left, padding: .medium)
            .rightAnchor(in: baseView, attribute: .right, padding: .medium)
            .heightAnchor(.xLarge4)

        eyeButton
            .centerY(in: passwordTextField)
            .rightAnchor(in: passwordTextField)
            .widthAnchor(.xLarge4)
            .heightAnchor(.xLarge4)

        loginButton
            .topAnchor(in: passwordTextField, attribute: .bottom, padding: 100)
            .leftAnchor(in: baseView, attribute: .left, padding: .medium)
            .rightAnchor(in: baseView, attribute: .right, padding: .medium)
            .heightAnchor(.xLarge4)

        forgotPasswordStackView
            .topAnchor(in: loginButton, attribute: .bottom, padding: 14)
            .centerX(in: baseView)

        registerStackView
            .bottomAnchor(in: baseView, attribute: .bottom, padding: .large)
            .centerX(in: baseView)

        loginKeyboardButton
            .centerX(in: buttonContainerView)
            .leftAnchor(in: buttonContainerView, padding: .medium)
            .rightAnchor(in: buttonContainerView, padding: .medium)
            .bottomAnchor(in: buttonContainerView, padding: .medium)
            .heightAnchor(50)
    }

}
