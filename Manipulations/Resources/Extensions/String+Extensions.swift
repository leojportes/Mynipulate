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

    public var formatWeight: String {
        guard let doubleValue = Double(self) else { return "" }
        let mformatter = MeasurementFormatter()
        mformatter.locale = Locale(identifier: "pt_BR")
        mformatter.unitOptions = .naturalScale
        mformatter.unitStyle = .medium
        let weight = Measurement(value: doubleValue, unit: UnitMass.grams)
        return mformatter.string(from: weight)
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

public extension String {
    func countOccurrences(of string: String) -> Int {
        components(separatedBy: string).count - 1
    }
}

public extension String {

    var isCNPJ: Bool {
        let numbers = compactMap({ Int(String($0)) })
        guard numbers.count == 14 && Set(numbers).count != 1 else { return false }
        let sum1 = 11 - ( numbers[11] * 2 +
            numbers[10] * 3 +
            numbers[9] * 4 +
            numbers[8] * 5 +
            numbers[7] * 6 +
            numbers[6] * 7 +
            numbers[5] * 8 +
            numbers[4] * 9 +
            numbers[3] * 2 +
            numbers[2] * 3 +
            numbers[1] * 4 +
            numbers[0] * 5 ) % 11
        let dv1 = sum1 > 9 ? 0 : sum1
        let sum2 = 11 - ( numbers[12] * 2 +
            numbers[11] * 3 +
            numbers[10] * 4 +
            numbers[9] * 5 +
            numbers[8] * 6 +
            numbers[7] * 7 +
            numbers[6] * 8 +
            numbers[5] * 9 +
            numbers[4] * 2 +
            numbers[3] * 3 +
            numbers[2] * 4 +
            numbers[1] * 5 +
            numbers[0] * 6 ) % 11
        let dv2 = sum2 > 9 ? 0 : sum2
        guard dv1 == numbers[12] && dv2 == numbers[13] else { return false }
        return true
    }

    var isCPF: Bool {
        let invalidDocuments = [
            "00000000000",
            "11111111111",
            "22222222222",
            "33333333333",
            "44444444444",
            "55555555555",
            "66666666666",
            "77777777777",
            "88888888888",
            "99999999999",
            "12345678909",
        ]

        guard
            count == 11,
            rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil,
            !invalidDocuments.contains(self)
        else {
            return false
        }

        let tenthDigitIndex = index(startIndex, offsetBy: 9)
        let eleventhDigitIndex = index(startIndex, offsetBy: 10)

        let d10 = Int(String(self[tenthDigitIndex]))
        let d11 = Int(String(self[eleventhDigitIndex]))

        var resultModuleOne = 0, resultModuleTwo = 0

        for i in 0...8 {
            let charIndex = index(startIndex, offsetBy: i)
            let char = Int(String(self[charIndex]))

            resultModuleOne += (char ?? 0) * (10 - i)
            resultModuleTwo += (char ?? 0) * (11 - i)
        }

        resultModuleOne %= 11
        resultModuleOne = (resultModuleOne < 2) ? 0 : (11 - resultModuleOne)

        resultModuleTwo += resultModuleOne * 2
        resultModuleTwo %= 11
        resultModuleTwo = (resultModuleTwo < 2) ? 0 : (11 - resultModuleTwo)

        guard resultModuleOne == d10 && resultModuleTwo == d11 else { return false }
        return true
    }

    func format(mask: MaskFormat) -> String? {
        let formatter = MaskFormatter()
        formatter.masks = mask.rawValues
        return formatter.formatText(self)
    }

    var isPhoneNumber: Bool {
        let validDDD: [String] = [
            Array(11...19),
            [21, 22],
            [24],
            [27, 28],
            Array(31...35),
            [37, 38],
            Array(41...49),
            [51],
            Array(53...55),
            Array(61...69),
            [71],
            Array(73...75),
            [77, 79],
            Array(81...89),
            Array(91...99),
        ]
        .flatMap { $0 }
        .map(String.init)

        let valueDecimalsOnly = decimalsOnly
        let ddd = String(valueDecimalsOnly.prefix(2))
        return validDDD.contains(ddd) && Array(valueDecimalsOnly)[safeIndex: 2] == "9" && valueDecimalsOnly.count == 11
    }
}

public extension StringProtocol {
    /// Formats the string similarly to `.capitalized` method, but capitalizes only
    /// the first letter of the string.
    ///
    /// Example:
    ///
    ///     "LOREM IPSUM DOLOR SIT AMET".firstUppercased
    ///     "Lorem Ipsum Dolor Sit Amet".firstUppercased
    ///     "LoReM IpSuM DoLoR SiT AmEt".firstUppercased
    ///     // all return "Lorem ipsum dolor sit amet"
    ///
    var firstUppercased: String {
        lowercased().prefix(1).uppercased() + dropFirst().lowercased()
    }
}
