//
//  ManipulationsService.swift
//  Manipulations
//
//  Created by Leonardo Portes on 17/09/23.
//

import Foundation

protocol ManipulationsServiceProtocol {
    func getManipulationList(completion: @escaping ([Manipulation]) -> Void)
}

class ManipulationsService: ManipulationsServiceProtocol {
    private let apiClient = APIClient()

    func getManipulationList(completion: @escaping ([Manipulation]) -> Void) {
        let endpoint = "\(Current.shared.localhost):3000/manipulation/\(Current.shared.email)"
        apiClient.performRequest(
            method: .get,
            endpoint: endpoint
        ) { (result: Result<[Manipulation], Error>) in
            switch result {
            case .success(let manipulations):
                completion(manipulations)
            case .failure(let error):
                // Lide com o erro
                print(error)
            }
        }
    }
}
