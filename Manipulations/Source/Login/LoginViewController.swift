//
//  LoginViewController.swift
//  Manipulations
//
//  Created by Leonardo Portes on 07/03/23.
//

import UIKit
import AVFoundation

final class LoginViewController: CoordinatedViewController {

    // MARK: - Private properties
    private let viewModel: LoginViewModel
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    private var isSecureTextEntry: Bool = false

    // MARK: - Init
    init(viewModel: LoginViewModel, coordinator: CoordinatorProtocol) {
        self.viewModel = viewModel
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
        buttonContainerView.addSubview(loginButton)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.centerX(in: buttonContainerView)
        loginButton.leftAnchor(in: buttonContainerView, padding: .medium)
        loginButton.rightAnchor(in: buttonContainerView, padding: .medium)
        loginButton.bottomAnchor(in: buttonContainerView, padding: .medium)
        loginButton.heightAnchor(50)
        
        baseView.backgroundColor = .blackHigh.withAlphaComponent(0.4)
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
    
    private lazy var myBusinessImage: UIImageView = {
        let img = UIImageView()
        img.heightAnchor(36)
        img.widthAnchor(36)
        img.image = UIImage(named: Icon.iconApp.rawValue)
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    private lazy var titleLabel: MNLabel = {
        let label = MNLabel(
            text: "MYNIPULE",
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
        textField.clearButtonMode = .whileEditing
        textField.inputAccessoryView = buttonContainerView
        textField.addTarget(self, action: #selector(textFieldEditingDidChange), for: .editingChanged)
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
        textField.inputAccessoryView = buttonContainerView
        return textField
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
//        button.addTarget(self, action: #selector(handleLoginButton), for: .touchUpInside)
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
//        button.addTarget(self, action: #selector(handlerRegisterButton), for: .touchUpInside)
        return button
    }()
    
    private func isEnabledButtonLogin(_ isEnabled: Bool) {
        if isEnabled {
            loginButton.backgroundColor = .purpleLight
            loginButton.isEnabled = true
        } else {
            loginButton.backgroundColor = .systemGray
            loginButton.isEnabled = false
        }
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
        let isValidLogin = email.isValidEmail() && password.count >= 7
        isValidLogin ? isEnabledButtonLogin(true) : isEnabledButtonLogin(false)
//        didEditingTextField(email)
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
//
//        loginButton
//            .topAnchor(in: passwordTextField, attribute: .bottom, padding: 100)
//            .leftAnchor(in: baseView, attribute: .left, padding: 16)
//            .rightAnchor(in: baseView, attribute: .right, padding: 16)
//            .heightAnchor(48)

        forgotPasswordStackView
            .topAnchor(in: loginButton, attribute: .bottom, padding: 14)
            .centerX(in: baseView)

        registerStackView
            .bottomAnchor(in: baseView, attribute: .bottom, padding: 20)
            .centerX(in: baseView)
    }

}
