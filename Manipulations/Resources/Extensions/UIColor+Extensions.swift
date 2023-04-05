//
//  UIColor+Extensions.swift
//  Manipulations
//
//  Created by Leonardo Portes on 29/12/22.
//

import UIKit

public extension UIColor {
    static var back = UIColor(named: "back") ?? UIColor.lightGray
    static var separator = UIColor(named: "separator") ?? UIColor.systemGray
    static var neutral = UIColor(named: "neutral") ?? UIColor.darkGray
    static var neutralHigh = UIColor(named: "neutralHigh") ?? UIColor.darkGray
    static var neutralLow = UIColor(named: "neutralLow") ?? UIColor.opaqueSeparator
    static var purpleHigh = UIColor(named: "purpleHigh") ?? UIColor.purple
    static var purpleLight = UIColor(named: "purpleLight") ?? UIColor.systemPurple
    static var blackHigh = UIColor(named: "blackHigh") ?? UIColor.black
    static var alertBlue = UIColor(named: "alertBlue") ?? UIColor.black
}
