//
//  LoginViewModel.swift
//  Manipulations
//
//  Created by Leonardo Portes on 07/03/23.
//

import Foundation
import FirebaseAuth
import FirebaseCore
import SystemConfiguration

protocol LoginViewModelProtocol: AnyObject {
    func authLogin(_ email: String, _ password: String, resultLogin: @escaping (Bool, String) -> Void)
    func navigateToHome()
    func navigateToUserOnboarding()
    func navigateToForgotPassword(email: String)
    func navigateToRegister()
    func navigateToCheckYourAccount()
    func isInternetAvailable() -> Bool
    func fetchUser(completion: @escaping (UserModelList) -> Void)
}

class LoginViewModel: LoginViewModelProtocol {

    // MARK: - Properties
    private var coordinator: LoginCoordinator?

    // MARK: - Init
    init(coordinator: LoginCoordinator?) {
        self.coordinator = coordinator
    }

    // MARK: Routes
    func navigateToHome() {
        coordinator?.openHomeScreen()
    }

    func navigateToUserOnboarding() {
        coordinator?.showUserOnboarding()
    }

    func navigateToForgotPassword(email: String) { }
    func navigateToRegister() { }
    
    func navigateToCheckYourAccount() {
        coordinator?.checkYourAccount()
    }

    func fetchUser(completion: @escaping (UserModelList) -> Void) {
        guard let email = Auth.auth().currentUser?.email else { return }

        let urlString = "\(Current.shared.localhost):3000/profile/\(email)"
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            do {
                let result = try JSONDecoder().decode(UserModelList.self, from: data)
                completion(result)
            }
            catch {
                let error = error
                print(error)
            }
        }.resume()
    }

    func authLogin(_ email: String, _ password: String, resultLogin: @escaping (Bool, String) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { _, error in
            if error != nil {
                guard let typeError = error as? NSError else { return }
                resultLogin(false, self.descriptionError(error: typeError))
            } else {
                MNUserDefaults.set(value: true, forKey: .authenticated)
                KeychainService.saveCredentials(email: email, password: password)
                resultLogin(true, .empty)
            }
        }
    }

    private func descriptionError(error: NSError) -> String {
        var description: String = .empty
        switch error.code {
        case AuthErrorCode.userNotFound.rawValue:
            description = "Não existe uma conta com esse e-mail"
        case AuthErrorCode.wrongPassword.rawValue:
            description = "Senha incorreta"
        default:
            description = "Ocorreu um erro. Tente novamente."
        }
        return description
    }

    func isInternetAvailable() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)

        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }) else {
            return false
        }

        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }

        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)

        return isReachable && needsConnection.not
    }

}
