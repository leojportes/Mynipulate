//
//  String+Extensions.swift
//  Manipulations
//
//  Created by Leonardo Portes on 29/12/22.
//

import UIKit

extension String {
    
    static var empty: String {
        return ""
    }
    
    func isValidEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }

    public var getUserPartOfEmail: String {
        let charSet = CharacterSet(charactersIn: "@")
        let v = self.components(separatedBy: charSet)
        let pos = v.count - 2
        return v[pos]
    }
    
    public static var currentDateSystem: String {
        let date = Date()
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yyyy"
        let dateString = df.string(from: date)
        return dateString
    }
}


extension String {
    
    /// formatting text for currency textField
    func currencyInputFormatting() -> String {
        
        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.currencySymbol = "Kg"
//        formatter.maximumFractionDigits = 2
//        formatter.minimumFractionDigits = 2
//
        var amountWithPrefix = self
        
        // remove from String: "$", ".", ","
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count), withTemplate: "")
        
        let double = (amountWithPrefix as NSString).doubleValue
        number = NSNumber(value: (double / 100))
        
        // if first number is 0 or all numbers were deleted
        guard number != 0 as NSNumber else { return .empty }

        let currency = formatter.string(from: number).orEmpty

        return currency
    }
    
    var decimalsOnly: String {
        removingCharacters(in: CharacterSet.decimalDigits.inverted)
    }

    func removingCharacters(in characterSet: CharacterSet) -> String {
        components(separatedBy: characterSet).joined()
    }

    
    var nonAlphanumericsRemoved: String {
        let alphanumericCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
        let resultChars: [Character] = compactMap {
            let unnaccentedChar = String($0).unnaccented
            return alphanumericCharacters.contains(unnaccentedChar) ? $0 : nil
        }
        return String(resultChars)
    }

    var unnaccented: String {
        folding(options: .diacriticInsensitive, locale: .current)
    }

    var removingKgCharacter: String {
        self.replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "kg", with: "")
            .replacingOccurrences(of: ",", with: ".")
    }

}

public extension Optional where Wrapped == String {
    var orEmpty: String { self ?? .empty }
}


extension Locale {
    var measurementSystem: String {
        (self as NSLocale).object(forKey: NSLocale.Key.measurementSystem) as! String
    }
}
