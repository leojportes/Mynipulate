//
//  ProductsViewModel.swift
//  Manipulations
//
//  Created by Leonardo Portes on 06/02/23.
//

import Foundation

protocol ProductsViewModelProtocol: AnyObject {
    var input: ProductsViewModelInputProtocol { get }
    var output: ProductsViewModelOutputProtocol { get }
    
    func registerProduct(products: [Product])
}


// MARK: - Protocols
protocol ProductsViewModelOutputProtocol {
    var products: Bindable<[Product]> { get }
}

protocol ProductsViewModelInputProtocol {
    func viewDidLoad()
}

class ProductsViewModel: ProductsViewModelProtocol, ProductsViewModelOutputProtocol {
    
    var products: Bindable<[Product]> = .init([])
    
    var input: ProductsViewModelInputProtocol { self }
    var output: ProductsViewModelOutputProtocol { self }

    // MARK: - Properties
    private var coordinator: ProductsCoordinator?
    private var service: ProductServiceProtocol

    // MARK: - Init
    init(service: ProductServiceProtocol = ProductService(), coordinator: ProductsCoordinator?) {
        self.service = service
        self.coordinator = coordinator
    }
    
    private func fetchProductItems() {
        service.getProductList { result in
            DispatchQueue.main.async {
                self.products.value = result
            }
        }
    }

    func deleteProduct(_ product: String, completion: @escaping (String) -> Void) {
        service.deleteProduct(product) { message in
            completion(message)
        }
    }

    // MARK: Routes
    func registerProduct(products: [Product]) {
        coordinator?.registerProduct(products: products)
    }
}

extension ProductsViewModel: ProductsViewModelInputProtocol {
    func viewDidLoad() {
        fetchProductItems()
    }
}
