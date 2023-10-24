//
//  ProductService.swift
//  Manipulations
//
//  Created by Leonardo Portes on 27/03/23.
//

import Foundation

protocol ProductServiceProtocol {
    func getProductList(completion: @escaping ([Product]) -> Void)
    func deleteProduct(_ productId: String, completion: @escaping (String) -> Void)
}

class ProductService: ProductServiceProtocol {
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
                print(error)
            }
        }
    }

    func deleteProduct(_ productId: String, completion: @escaping (String) -> Void) {
        let endpoint = "\(Current.shared.localhost):3000/product/\(productId)"
        apiClient.performDeleteRequest(endpoint: endpoint) { (result: Result<String, Error>) in
            switch result {
            case .success(let result):
                completion(result)
            case .failure(let error):
                print(error)
            }
        }
    }

}
