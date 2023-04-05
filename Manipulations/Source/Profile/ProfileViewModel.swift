//
//  ProfileViewModel.swift
//  Manipulations
//
//  Created by Leonardo Portes on 09/02/23.
//

import Foundation

protocol ProfileViewModelProtocol: AnyObject {
    var input: ProfileViewModelInputProtocol { get }
    var output: ProfileViewModelOutputProtocol { get }
//    func registerContributors()
    func openContributors()
}

// MARK: - Protocols
protocol ProfileViewModelOutputProtocol {
    var numberOfContributors: Bindable<Int> { get }
}

protocol ProfileViewModelInputProtocol {
    func viewDidLoad()
}


class ProfileViewModel: ProfileViewModelProtocol, ProfileViewModelOutputProtocol {
    var input: ProfileViewModelInputProtocol { self }
    var output: ProfileViewModelOutputProtocol { self }
    
    private let service: ProfileServiceProtocol
    
    var numberOfContributors: Bindable<Int> = .init(0)
    
    // MARK: - Properties
    private var coordinator: ProfileCoordinator?

    // MARK: - Init
    init(service: ProfileServiceProtocol = ProfileService(), coordinator: ProfileCoordinator?) {
        self.coordinator = coordinator
        self.service = service
    }

    private func getNumberOfContributors() {
        service.getContributorList { result in
            DispatchQueue.main.async {
                self.numberOfContributors.value = result.count
            }
        }
    }
    
    // MARK: Routes
    func openContributors() {
        coordinator?.openContributors()
    }
}

extension ProfileViewModel: ProfileViewModelInputProtocol {
    func viewDidLoad() {
        getNumberOfContributors()
    }
}

