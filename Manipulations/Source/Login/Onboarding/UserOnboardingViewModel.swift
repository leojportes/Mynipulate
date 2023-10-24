//
//  UserOnboardingViewModel.swift
//  Manipulations
//
//  Created by Leonardo Portes on 07/09/23.
//

import Foundation

protocol UserOnboardingViewModelProtocol {
    func createUser(userModel: CreateUserModel, completion: @escaping (Bool) -> Void)
    func navigateToHome()
}

class UserOnboardingViewModel: UserOnboardingViewModelProtocol {

    // MARK: - Properties
    private var coordinator: UserOnboardingCoordinator?

    // MARK: - Init
    init(coordinator: UserOnboardingCoordinator?) {
        self.coordinator = coordinator
    }

    func createUser(userModel: CreateUserModel, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "\(Current.shared.localhost):3000/profile") else {
            print("Error: cannot create URL")
            return
        }

        /// Convert model to JSON data
        guard let jsonData = try? JSONEncoder().encode(userModel) else {
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

    // MARK: - Routes
    func navigateToHome() {
        coordinator?.navigateToHome()
    }

}
