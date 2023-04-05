//
//  Product.swift
//  Manipulations
//
//  Created by Leonardo Portes on 28/02/23.
//

import Foundation

struct Products: Decodable {
    let items: [Product]
}

struct Product: Codable {
    let _id: String
    let emailFirebase: String
    let name: String
    let type: ProductType
}

struct RegisterProduct: Codable {
    let emailFirebase: String
    let name: String
    let type: String
}
