//
//  RegisterContributorsViewModel.swift
//  Manipulations
//
//  Created by Leonardo Portes on 15/02/23.
//

import Foundation

protocol RegisterContributorsViewModelProtocol: AnyObject {
    func registerContributor(contributor: RegisterContributor, completion: @escaping (Bool) -> Void)
}

class RegisterContributorsViewModel: RegisterContributorsViewModelProtocol {

    // MARK: - Properties
    private var coordinator: RegisterContributorsCoordinator?

    // MARK: - Init
    init(coordinator: RegisterContributorsCoordinator?) {
        self.coordinator = coordinator
    }

    // MARK: Routes
    func registerContributor(contributor: RegisterContributor, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "\(Current.shared.localhost):3000/contributor") else {
            print("Error: cannot create URL")
            return
        }

        /// Convert model to JSON data
        guard let jsonData = try? JSONEncoder().encode(contributor) else {
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

    func pop() {
        coordinator?.pop()
    }
}
