//
//  AverageService.swift
//  Manipulations
//
//  Created by Leonardo Portes on 22/01/23.
//

import Foundation

protocol AverageServiceProtocol {
    func getProductList(completion: @escaping ([Product]) -> Void)
    func getContributorList(completion: @escaping ([Contributor]) -> Void)
}

class AverageService: AverageServiceProtocol {

    // Get contributor list
    func getContributorList(completion: @escaping ([Contributor]) -> Void) {
        let urlString = "\(Current.shared.localhost):3000/contributor/\(Current.shared.email)"
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            do {
                let result = try JSONDecoder().decode([Contributor].self, from: data)
                DispatchQueue.main.async {
                    completion(result)
                }
            }
            catch {
                let error = error
                print(error)
            }
        }.resume()
    }

    // Get procedure list
    func getProductList(completion: @escaping ([Product]) -> Void) {
        let urlString = "\(Current.shared.localhost):3000/product/\(Current.shared.email)"
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            do {
                let result = try JSONDecoder().decode([Product].self, from: data)
                DispatchQueue.main.async {
                    completion(result)
                }
            }
            catch {
                let error = error
                print(error)
            }
        }.resume()
    }

}
