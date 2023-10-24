//
//  HomeService.swift
//  Manipulations
//
//  Created by Leonardo Portes on 29/12/22.
//

import Foundation

protocol HomeServiceProtocol {
    func getProductList(completion: @escaping ([Product]) -> Void)
    func getContributorList(completion: @escaping ([Contributor]) -> Void)
    func getManipulationList(completion: @escaping ([Manipulation]) -> Void)
}

class HomeService: HomeServiceProtocol {
    private let apiClient = APIClient()

    /// Get product list
    func getProductList(completion: @escaping ([Product]) -> Void) {
        let endpoint = "\(Current.shared.localhost):3000/product/\(Current.shared.email)"
        apiClient.performRequest(
            method: .get,
            endpoint: endpoint
        ) { (result: Result<[Product], Error>) in
            switch result {
            case .success(let products):
                completion(products)
            case .failure(let error):
                // Lide com o erro
                print(error)
            }
        }
    }

    /// Get contributor list
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

    /// Get manipulation list
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
