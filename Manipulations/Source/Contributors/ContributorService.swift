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
    
    // Get contributor list
    func getContributorList(completion: @escaping ([Contributor]) -> Void) {
        // guard let email = Auth.auth().currentUser?.email else { return }
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

    /// Delete contributor
    func deleteContributor(_ contributorId: String, completion: @escaping (String) -> Void) {
        guard let url = URL(string: "\(Current.shared.localhost):3000/contributor/\(contributorId)") else {
            print("Error: cannot create URL")
            return
        }
        var urlReq = URLRequest(url: url)
        urlReq.httpMethod = "DELETE"
        URLSession.shared.dataTask(with: urlReq) { data, response, error in
            completion(error?.localizedDescription ?? "Deletado com sucesso!")
        }.resume()
    }
}
