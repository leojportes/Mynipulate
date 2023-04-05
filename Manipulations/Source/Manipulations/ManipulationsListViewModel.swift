//
//  ManipulationsListViewModel.swift
//  Manipulations
//
//  Created by Leonardo Portes on 31/01/23.
//

import Foundation

protocol ManipulationsListViewModelProtocol: AnyObject {
    func openManipulationDetail(_ item: Manipulation, products: [Product], contributors: [Contributor])
    func openRegisterManipulation(products: [Product], contributors: [Contributor])
    func fetchProcedureItems()
    
    var input: ManipulationsListViewModelInputProtocol { get }
    var output: ManipulationsListViewModelOutputProtocol { get }
}

// MARK: - Protocols
protocol ManipulationsListViewModelOutputProtocol {
    var manipulations: Bindable<[Manipulation]> { get }
}

protocol ManipulationsListViewModelInputProtocol {
    func viewDidLoad()
}


class ManipulationsListViewModel: ManipulationsListViewModelProtocol, ManipulationsListViewModelOutputProtocol {

    // MARK: - Properties
    private var coordinator: ManipulationsCoordinator?
    var manipulations: Bindable<[Manipulation]> = .init([])
    private let service: ManipulationsService
    
    var input: ManipulationsListViewModelInputProtocol { self }
    var output: ManipulationsListViewModelOutputProtocol { self }

    // MARK: - Init
    init(service: ManipulationsService = .init(), coordinator: ManipulationsCoordinator?) {
        self.service = service
        self.coordinator = coordinator
    }

    // MARK: Routes
    func openManipulationDetail(_ item: Manipulation, products: [Product], contributors: [Contributor]) {
        coordinator?.openManipulationDetail(item, products: products, contributors: contributors)
    }

    func openRegisterManipulation(products: [Product], contributors: [Contributor]) {
        coordinator?.openRegisterManipulation(products: products, contributors: contributors)
    }
    
    func fetchProcedureItems() {
        service.getManipulationList { result in
            DispatchQueue.main.async {
                self.manipulations.value = result
            }
        }
    }

}

extension ManipulationsListViewModel: ManipulationsListViewModelInputProtocol {
    func viewDidLoad() {
        fetchProcedureItems()
    }
}

protocol ManipulationsServiceProtocol {
    func getManipulationList(completion: @escaping ([Manipulation]) -> Void)
}

class ManipulationsService: ManipulationsServiceProtocol {

    func getManipulationList(completion: @escaping ([Manipulation]) -> Void) {
       // guard let email = Auth.auth().currentUser?.email else { return }

        let urlString = "http://192.168.0.2:3000/manipulation/leojportes@gmail.com"
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            do {
                let result = try JSONDecoder().decode([Manipulation].self, from: data)
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
