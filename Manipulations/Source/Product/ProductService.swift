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
//    func deleteProcedure(_ procedure: String, completion: @escaping () -> Void)
//    func fetchUser(completion: @escaping (UserModelList) -> Void)
}

class ProductService: ProductServiceProtocol {

    // Get procedure list
    func getProductList(completion: @escaping ([Product]) -> Void) {
       // guard let email = Auth.auth().currentUser?.email else { return }
        let urlString = "http://192.168.0.2:3000/product/leojportes@gmail.com"
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

    /// Delete product
    func deleteProduct(_ productId: String, completion: @escaping (String) -> Void) {
        guard let url = URL(string: "http://192.168.0.2:3000/product/\(productId)") else {
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
