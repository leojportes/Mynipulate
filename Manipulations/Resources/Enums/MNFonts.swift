//
//  MNFonts.swift
//  Manipulations
//
//  Created by Leonardo Portes on 25/10/23.
//

import Foundation
import UIKit

public extension UIFont {

    static let fontDefaultGeorgia = UIFont(name: "Georgia", size: 15) ?? UIFont()

    static var semiBold: UIFont {
        return UIFont(name: "Spartan-SemiBold", size: 16) ?? fontDefaultGeorgia
    }
}
