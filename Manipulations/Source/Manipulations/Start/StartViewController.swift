//
//  StartViewController.swift
//  Manipulations
//
//  Created by Leonardo Portes on 19/09/23.
//

import Foundation
import UIKit
import Lottie

class StartViewController: CoordinatedViewController {
    private let viewModel: StartViewModelProtocol
    private var animationView: LottieAnimationView?

    init(viewModel: StartViewModelProtocol, coordinator: CoordinatorProtocol){
        self.viewModel = viewModel
        super.init(coordinator: coordinator)
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .back
        showAnimation()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.validate()
    }

    private func showAnimation() {
        animationView = .init(name: "fishingLoading")
        animationView?.frame = view.bounds
        animationView?.contentMode = .scaleAspectFit
        animationView?.loopMode = .loop
        animationView?.animationSpeed = 1.2
        view.addSubview(animationView!)
        animationView?.play()
    }
}
