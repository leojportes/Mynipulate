//
//  ProfileService.swift
//  Manipulations
//
//  Created by Leonardo Portes on 29/03/23.
//

import Foundation

import Foundation

protocol ProfileServiceProtocol {
    func getContributorList(completion: @escaping ([Contributor]) -> Void)
}

class ProfileService: ProfileServiceProtocol {
    // Get contributor list
    func getContributorList(completion: @escaping ([Contributor]) -> Void) {
        // guard let email = Auth.auth().currentUser?.email else { return }
        let urlString = "http://192.168.0.2:3000/contributor/leojportes@gmail.com"
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
}
