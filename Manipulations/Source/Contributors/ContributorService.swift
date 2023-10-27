//
//  ContributorService.swift
//  Manipulations
//
//  Created by Leonardo Portes on 29/03/23.
//

import Foundation

protocol ContributorsServiceProtocol {
    func getContributorList(completion: @escaping ([Contributor]) -> Void)
    func deleteContributor(_ contributorId: String, completion: @escaping (String) -> Void)
}

class ContributorsService: ContributorsServiceProtocol {
    private let apiClient = APIClient()

    /// Get contributor list.
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
                print(error)
            }
        }
    }

    /// Delete contributor by Id.
    func deleteContributor(_ contributorId: String, completion: @escaping (String) -> Void) {
        let endpoint = "\(Current.shared.localhost):3000/contributor/\(contributorId)"
        apiClient.performRequestToDelete(endpoint: endpoint) { (result: Result<String, Error>) in
            switch result {
            case .success(let result):
                completion(result)
            case .failure(let error):
                print(error)
            }
        }
    }
}
