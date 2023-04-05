//
//  Contributor.swift
//  Manipulations
//
//  Created by Leonardo Portes on 28/02/23.
//

import Foundation

public struct Contributor: Codable {
    let _id: String
    let emailFirebase: String
    let documentBusiness: String
    let name: String
    let id: String
}

public struct RegisterContributor: Codable {
    let emailFirebase: String
    let documentBusiness: String
    let name: String
    let id: String
}
