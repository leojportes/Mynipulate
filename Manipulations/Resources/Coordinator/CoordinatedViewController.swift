//
//  CoordinatedViewController.swift
//  Manipulations
//
//  Created by Leonardo Portes on 29/12/22.
//

import UIKit

public protocol CoordinatedProtocol: AnyObject {
    
    var coordinator: CoordinatorProtocol? { get set }
    
    func setCoordinatorDelegate(_ coordinator: CoordinatorProtocol?)
}

open class CoordinatedViewController: UIViewController, CoordinatedProtocol {
    
    public var coordinator: CoordinatorProtocol?
    
    public init(coordinator: CoordinatorProtocol,
                nibName: String? = nil,
                bundle: Bundle? = nil) {
        super.init(nibName: nibName, bundle: bundle)
        self.coordinator = coordinator
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public func setCoordinatorDelegate(_ coordinator: CoordinatorProtocol?) {
        self.coordinator = coordinator
    }
    
    deinit {
        coordinator?.removeCoordinator()
    }
}
