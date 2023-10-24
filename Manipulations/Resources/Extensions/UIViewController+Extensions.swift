//
//  UIViewController+Extensions.swift
//  Manipulations
//
//  Created by Leonardo Portes on 29/12/22.
//

import UIKit

extension UIViewController {
    func showAlert(
        title: String = "Funcionalidade não disponível!",
        message: String = "Estamos trabalhando nisso.",
        leftButtonTitle: String = "Ok",
        rightButtonTitle: String = "",
        completion: @escaping () -> Void? = { nil }
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let rightButton = UIAlertAction(title: rightButtonTitle, style: .destructive) { _ in completion() }
        let leftButton = UIAlertAction(title: leftButtonTitle, style: .default) { _ in
            if rightButtonTitle == "" { completion() }
        }

        if rightButtonTitle != "" {
            alert.addAction(rightButton)
        }
        alert.addAction(leftButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func showDeleteAlert(
        title: String = "Atenção!",
        message: String = "Deseja deletar?\n Esta ação é irreversível.",
        closedScreen: Bool = false,
        completion: @escaping () -> Void? = { nil }
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancelar", style: .cancel) { _ in
            if closedScreen {
                self.dismiss(animated: true)
            }
        }
        let confirm = UIAlertAction(title: "Deletar", style: .destructive) { _ in completion() }
        alert.addAction(cancel)
        alert.addAction(confirm)
        self.present(alert, animated: true, completion: nil)
    }

    func showAlertWithTextField(
        okCompletion: @escaping (String) -> Void,
        cancelCompletion: @escaping () -> Void
    ) {
        // Crie um UIAlertController
        let alertController = UIAlertController(
            title: "Modo colaborador",
            message: "Após alterar o status do modo colaborador, você será deslogado para surgir efeito.",
            preferredStyle: .alert
        )
        
        alertController.setAttributedTitle("Modo colaborador", color: .misteryGreen, font: UIFont.boldSystemFont(ofSize: .medium))
        
        // Adicione um campo de texto ao alerta
        alertController.addTextField { (textField) in
            textField.placeholder = "digite sua senha"
            textField.isSecureTextEntry = true
            textField.autocapitalizationType = .none
        }

        // Adicione um botão "Cancelar"
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel) { (_) in
            cancelCompletion()
        }

        alertController.addAction(cancelAction)

        // Adicione um botão "OK"
        let okAction = UIAlertAction(title: "Alterar", style: .default) { (_) in
            // Ação a ser executada quando o botão "OK" for pressionado

            if let textFields = alertController.textFields,
               let textField = textFields.first,
               let text = textField.text {

                okCompletion(text)
            }
        }
        alertController.addAction(okAction)

        // Apresente o alerta na tela
        present(alertController, animated: true, completion: nil)
    }


    func showAlertToSettings() {
        let alertController = UIAlertController (
            title: "Oops!",
            message: "Parece que você está sem internet.\n Verifique sua conexão em Ajustes.",
            preferredStyle: .alert
        )
        let settingsAction = UIAlertAction(title: "Ajustes", style: .default) { (_) -> Void in

            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }

            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }

}

public extension UIViewController {
    static func findCurrentController(file: String = #file, line: Int = #line) -> UIViewController? {
        let window = UIWindow.keyWindow
        let controller = findCurrentController(base: window?.rootViewController)

        if controller == nil {
            // log.error("Unable to find current controller: \(file):\(line)")
        }

        return controller
    }

    static func findCurrentController(base: UIViewController?) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return findCurrentController(base: nav.visibleViewController)
        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return findCurrentController(base: selected)
        } else if let presented = base?.presentedViewController {
            return findCurrentController(base: presented)
        }
        return base
    }

}

extension UIWindow {
    public static var keyWindow: UIWindow? {
        UIApplication.shared.windows.first(where: { $0.isKeyWindow })
    }
}

extension UIViewController {
    /// We apply it to the viewDidLoad that receives a bottomSheet, so that when we click outside the bottomsheet, it is dismissed.
    public func tappedOutViewBottomSheetDismiss() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleDismiss))
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc
    private func handleDismiss() {
        self.dismiss(animated: true)
    }
}

extension UIAlertController {
    func setAttributedTitle(_ title: String, color: UIColor, font: UIFont) {
        let titleString = NSAttributedString(string: title, attributes: [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: color
        ])
        self.setValue(titleString, forKey: "attributedTitle")
    }
}
