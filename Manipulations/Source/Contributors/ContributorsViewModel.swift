//
//  ContributorsViewModel.swift
//  Manipulations
//
//  Created by Leonardo Portes on 08/02/23.
//

import Foundation

protocol ContributorsViewModelProtocol: AnyObject {
    func registerContributors(contributors: [Contributor])
    var input: ContributorsViewModelInputProtocol { get }
    var output: ContributorsViewModelOutputProtocol { get }
}

// MARK: - Protocols
protocol ContributorsViewModelOutputProtocol {
    var contributors: Bindable<[Contributor]> { get }
}

protocol ContributorsViewModelInputProtocol {
    func viewDidLoad()
}

class ContributorsViewModel: ContributorsViewModelProtocol, ContributorsViewModelOutputProtocol {

    // MARK: - Properties
    private var coordinator: ContributorsCoordinator?
    var service: ContributorsService
    
    var contributors: Bindable<[Contributor]> = .init([])
    
    var input: ContributorsViewModelInputProtocol { self }
    var output: ContributorsViewModelOutputProtocol { self }

    // MARK: - Init
    init(service: ContributorsService = .init(), coordinator: ContributorsCoordinator?) {
        self.service = service
        self.coordinator = coordinator
    }

    // MARK: Routes
    func registerContributors(contributors: [Contributor]) {
        coordinator?.registerContributors(contributors: contributors)
    }

    func getContributors() {
        service.getContributorList { result in
            DispatchQueue.main.async {
                self.contributors.value = result
            }
        }
    }

    func deleteContributor(_ contributor: String, completion: @escaping (String) -> Void) {
        service.deleteContributor(contributor) { message in
            completion(message)
        }
    }

}

extension ContributorsViewModel: ContributorsViewModelInputProtocol {
    func viewDidLoad() {
        getContributors()
    }
}
