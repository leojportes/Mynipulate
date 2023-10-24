//
//  ManipulationsDetailCoordinator.swift
//  Manipulations
//
//  Created by Leonardo Portes on 25/01/23.
//

import Foundation

final class ManipulationsDetailCoordinator: BaseCoordinator {
    private var products: [Product] = []
    private var contributors: [Contributor] = []
    
    func start(_ item: Manipulation, products: [Product], contributors: [Contributor]) {
        self.products = products
        self.contributors = contributors
        let viewModel = ManipulationsDetailViewModel(coordinator: self)
        let controller = ManipulationsDetailViewController(item: item, coordinator: self, viewModel: viewModel)
        configuration.navigationController?.navigationBar.topItem?.backButtonTitle = ""
        configuration.navigationController?.navigationBar.tintColor = .blackHigh
        configuration.navigationController?.pushViewController(controller, animated: true)
    }

    // MARK: - Routes

    func openRegisterManipulation() {
        configuration.navigationController?.dismiss(animated: true)
        let coordinator = RegisterManipulationCoordinator(with: configuration)
        coordinator.start(products: products, contributors: contributors)
    }

}

class ManipulationsDetailViewModel {

    // MARK: - Properties

    private let coordinator: ManipulationsDetailCoordinator

    // MARK: - Init

    init(coordinator: ManipulationsDetailCoordinator) {
        self.coordinator = coordinator
    }

    // MARK: - Methods

    func openRegisterManipulation() {
        coordinator.openRegisterManipulation()
    }

    func deleteManipulation(_ manipulationId: String, completion: @escaping (String) -> Void) {
        guard let url = URL(string: "\(Current.shared.localhost):3000/manipulation/delete/\(manipulationId)") else {
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
