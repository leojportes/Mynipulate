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

    /// True for the active contributor.
    let isActive: Bool
}

public struct RegisterContributor: Codable {
    let emailFirebase: String
    let documentBusiness: String
    let name: String
    let id: String
    let isActive: Bool

    init(
        emailFirebase: String,
        documentBusiness: String,
        name: String, id: String
    ) {
        self.emailFirebase = emailFirebase
        self.documentBusiness = documentBusiness
        self.name = name
        self.id = id
        isActive = true
    }
}
