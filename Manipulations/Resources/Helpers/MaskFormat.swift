//
//  MaskFormat.swift
//  Manipulations
//
//  Created by Leonardo Portes on 18/09/23.
//

import Foundation

public struct MaskFormat: Equatable {
    internal let rawValues: [String]

    internal init(_ rawValues: String...) {
        self.init(rawValues)
    }

    internal init(_ rawValues: [String]) {
        self.rawValues = rawValues
    }

    public var isNone: Bool { rawValues.isEmpty }

    public static let none = MaskFormat()

    public static let phoneNumber = MaskFormat("(dd) dddd-dddd", "(dd) ddddd-dddd")
    public static let postalCode = MaskFormat("ddddd-ddd")
    public static let date = MaskFormat("dd/dd/dddd")
    public static let cpf = MaskFormat("ddd.ddd.ddd-dd")
    public static let cnpj = MaskFormat("dd.ddd.ddd/dddd-dd")
    public static let brazilianDocument = MaskFormat("ddd.ddd.ddd-dd", "dd.ddd.ddd/dddd-dd")

    public static func custom(_ values: String...) -> MaskFormat {
        MaskFormat(values)
    }
}
