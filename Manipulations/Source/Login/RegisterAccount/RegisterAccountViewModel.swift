//
//  RegisterAccountViewModel.swift
//  Manipulations
//
//  Created by Leonardo Portes on 02/05/23.
//

//import FirebaseAuth
import Foundation

protocol RegisterAccountViewModelProtocol: AnyObject {
    func createAccount(_ email: String, _ password: String, resultCreateUser: @escaping (Bool, String) -> Void)
    func closed()
}

class RegisterAccountViewModel: RegisterAccountViewModelProtocol {

    // MARK: - Properties
    private var coordinator: RegisterAccountCoordinator?

    // MARK: - Init
    init(coordinator: RegisterAccountCoordinator?) {
        self.coordinator = coordinator
    }

    func createAccount(_ email: String, _ password: String, resultCreateUser: @escaping (Bool, String) -> Void) {
//        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
//            if error != nil {
//                guard let typeError = error as? NSError else { return }
//                resultCreateUser(false, self.descriptionError(error: typeError))
//            } else {
//                resultCreateUser(true, .stringEmpty)
//            }
//        }
    }

    private func descriptionError(error: NSError) -> String {
//        var description: String = .stringEmpty
//
//        switch error.code {
//        case AuthErrorCode.invalidEmail.rawValue:
//            description = "E-mail invalido"
//        case AuthErrorCode.emailAlreadyInUse.rawValue:
//            description = "Já existe uma conta com esse e-mail"
//        case AuthErrorCode.weakPassword.rawValue:
//            description = "Adicione uma senha com no mínimo 6 digitos"
//        default:
//            description = "Tente novamente mais tarde"
//        }
//
//        return description
        return ""
    }

    // MARK: - Routes
    func closed() {
        coordinator?.closed()
    }

}
