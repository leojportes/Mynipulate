//
//  ProfileService.swift
//  Manipulations
//
//  Created by Leonardo Portes on 29/03/23.
//

import Foundation
import UIKit

protocol ProfileServiceProtocol {
    func getContributorList(completion: @escaping ([Contributor]) -> Void)
}

class ProfileService: ProfileServiceProtocol {
    private let apiClient = APIClient()

    func getContributorList(completion: @escaping ([Contributor]) -> Void) {
        let endpoint = "\(Current.shared.localhost):3000/contributor/\(Current.shared.email)"
        apiClient.performRequest(
            method: .get,
            endpoint: endpoint
        ) { (result: Result<[Contributor], Error>) in
            switch result {
            case .success(let contributors):
                completion(contributors)
            case .failure(let error):
                // Lide com o erro
                print(error)
            }
        }
    }
}
