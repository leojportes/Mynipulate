//
//  Manipulation.swift
//  Manipulations
//
//  Created by Leonardo Portes on 05/03/23.
//

import Foundation

public struct Manipulation: Codable {
    let emailFirebase: String
    let product: String
    let productType: String
    let date: String
    let responsibleName: String
    let supplier: String
    let grossWeight: String
    let cleanWeight: String
    let thawedWeight: String?
    let skinWeight: String?
    
    let cookedWeight: String?
    let headlessWeight: String?
    let discardWeight: String?
    
    
    var avarage: String {
        let gross = grossWeight.removingKgCharacter
        let clean = cleanWeight.removingKgCharacter
        let grossWeight = Double(gross) ?? 0.0
        let cleanWeight = Double(clean) ?? 0.0
        let avarage = (cleanWeight / grossWeight) * 100
        
        return String(format: "%.2f", avarage) + " %"
    }

    init(
        emailFirebase: String = "",
        product: String,
        productType: String = "",
        date: String,
        responsibleName: String,
        supplier: String = "",
        grossWeight: String,
        cleanWeight: String,
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
    }
}
