//
//  Manipulation.swift
//  Manipulations
//
//  Created by Leonardo Portes on 05/03/23.
//

import Foundation

public struct Manipulation: Codable, Hashable {
    let _id: String
    let emailFirebase: String
    let product: String
    let productType: String
    let date: String
    let responsibleName: String
    let supplier: String
    var grossWeight: Double
    var cleanWeight: Double
    let thawedWeight: String?
    let skinWeight: String?
    
    let cookedWeight: String?
    let headlessWeight: String?
    let discardWeight: String?

    var avarage: Double {
        (cleanWeight / grossWeight) * 100
    }

    var avarageDescription: String {
        let percent = String(format: "%.2f", avarage)

        if percent == "100.00" {
            return "100%"
        }

        if percent.prefix(2).hasSuffix(".") {
            return percent.prefix(2).replacingOccurrences(of: ".", with: "") + "%"
        }

        return percent.prefix(2) + "%"
    }


    init(
        emailFirebase: String = "",
        product: String,
        productType: String = "",
        date: String,
        responsibleName: String,
        supplier: String = "",
        grossWeight: Double,
        cleanWeight: Double,
        thawedWeight: String? = "",
        skinWeight: String? = "",
        cookedWeight: String? = "",
        headlessWeight: String? = "",
        discardWeight: String? = ""
    ) {
        self.emailFirebase = emailFirebase
        self.product = product
        self.productType = productType
        self.date = date
        self.responsibleName = responsibleName
        self.supplier = supplier
        self.grossWeight = grossWeight
        self.cleanWeight = cleanWeight
        self.thawedWeight = thawedWeight
        self.skinWeight = skinWeight
        self.cookedWeight = cookedWeight
        self.headlessWeight = headlessWeight
        self.discardWeight = discardWeight
        self._id = ""
    }
}
