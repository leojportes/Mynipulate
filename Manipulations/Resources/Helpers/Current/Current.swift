//
//  Current.swift
//  Manipulations
//
//  Created by Leonardo Portes on 30/07/23.
//

import Foundation
import FirebaseAuth
import SafariServices

public struct Current {
    static let shared: Self = .init()

    init() { /* empty init */ }

    let localhost = "http://192.168.0.2"

    var isEmailVerified: Bool {
        Auth.auth().currentUser?.isEmailVerified ?? false
    }
    
    var email: String {
        Auth.auth().currentUser?.email ?? ""
    }

    var user: UserModel {
        guard let model = MNUserDefaults.get(modelForKey: .currentUser) else { return .empty }
        return model
    }

    var isContributorMode: Bool {
        MNUserDefaults.get(boolForKey: .contributorMode) ?? true
    }

    var requestData: [RequestData] {
        MNUserDefaults.getRequestDataList(forKey: .requestData) ?? []
    }
}
