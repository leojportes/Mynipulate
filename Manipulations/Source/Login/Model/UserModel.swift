//
//  UserModel.swift
//  Manipulations
//
//  Created by Leonardo Portes on 30/07/23.
//

import Foundation

public typealias UserModelList = [UserModel]

public struct UserModel: Codable {
    let id: String
    let manangerName: String
    let companyName: String
    let city: String
    let state: String
    let document: String
    let emailFirebase: String
    let streetAddress: String
    let v: Int

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case manangerName
        case companyName
        case city
        case state
        case document
        case emailFirebase
        case streetAddress
        case v = "__v"
    }

    static var empty: Self {
        .init(id: "", manangerName: "", companyName: "", city: "", state: "", document: "", emailFirebase: "", streetAddress: "", v: 0)
    }
}

struct CreateUserModel: Codable {
    let manangerName: String
    let companyName: String
    let document: String
    let city: String
    let state: String
    let streetAddress: String
    let emailFirebase: String
}
