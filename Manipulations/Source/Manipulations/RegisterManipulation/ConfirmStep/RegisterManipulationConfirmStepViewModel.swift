//
//  RegisterManipulationConfirmStepViewModel.swift
//  Manipulations
//
//  Created by Leonardo Portes on 01/03/23.
//

import Foundation

protocol RegisterManipulationConfirmStepViewModelProtocol: AnyObject {
    func registerManipulation(manipulation: Manipulation, completion: @escaping (Bool) -> Void)
}

class RegisterManipulationConfirmStepViewModel: RegisterManipulationConfirmStepViewModelProtocol {

    // MARK: - Properties
    private var coordinator: RegisterManipulationConfirmStepCoordinator?

    // MARK: - Init
    init(coordinator: RegisterManipulationConfirmStepCoordinator?) {
        self.coordinator = coordinator
    }

    func registerManipulation(manipulation: Manipulation, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "http://192.168.0.2:3000/manipulation") else {
            print("Error: cannot create URL")
            return
        }

        /// Convert model to JSON data
        guard let jsonData = try? JSONEncoder().encode(manipulation) else {
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
    
    
    // MARK: Routes
    func pop() {
        coordinator?.pop()
    }

}
