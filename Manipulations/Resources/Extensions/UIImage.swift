//
//  UIImage.swift
//  Manipulations
//
//  Created by Leonardo Portes on 31/12/22.
//

import UIKit

extension UIImage {

    enum Icon: String {
        case manipulations = "manipulations"
        case arrowRight = "arrowRight"
        case product = "product"
        case employees = "peoples"
        case averages = "report"
        case discarts = "trash_ic"
        case institution = "institution"
        case alertWarning = "alertWarning"
    }

    static func icon(for icon: Icon) -> UIImage {
        return UIImage(named: icon.rawValue) ?? .add
    }
}
