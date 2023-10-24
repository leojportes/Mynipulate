//
//  UINavigationController+Ext.swift
//  Manipulations
//
//  Created by Leonardo Portes on 07/09/23.
//

import UIKit

extension UINavigationController {
    func removeViewController(_ controller: UIViewController.Type) {
        if let viewController = viewControllers.first(where: { $0.isKind(of: controller.self) }) {
            viewController.willMove(toParent: nil)
            viewController.removeFromParent()
            viewController.view.removeFromSuperview()
        }
    }
}
