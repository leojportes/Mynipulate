//
//  RegisterProductsViewModel.swift
//  Manipulations
//
//  Created by Leonardo Portes on 07/02/23.
//

import Foundation

protocol RegisterProductsViewModelProtocol: AnyObject {
    func registerProduct(product: RegisterProduct, completion: @escaping (Bool) -> Void)
    func pop()
}

class RegisterProductsViewModel: RegisterProductsViewModelProtocol {

    // MARK: - Properties
    private var coordinator: RegisterProductsCoordinator?

    // MARK: - Init
    init(coordinator: RegisterProductsCoordinator?) {
        self.coordinator = coordinator
    }

    // MARK: Routes
    func pop() {
        coordinator?.pop()
    }

    func registerProduct(product: RegisterProduct, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "http://192.168.0.2:3000/product") else {
            print("Error: cannot create URL")
            return
        }

        /// Convert model to JSON data
        guard let jsonData = try? JSONEncoder().encode(product) else {
            print("Error: Trying to convert model to JSON data")
            return
        }

        /// Create the url request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type") // the request is JSON
        request.setValue("application/json", forHTTPHeaderField: "Accept") // the response expected to be in JSON format
        request.httpBody = jsonData

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(false)
                return
            }
           
            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                completion(false)
                return
            }
            DispatchQueue.main.async {
                completion(true)
            }
        }.resume()
    }
}
