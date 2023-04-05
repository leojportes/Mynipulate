//
//  RoundedStepView.swift
//  Manipulations
//
//  Created by Leonardo Portes on 28/02/23.
//

import UIKit

public class RoundedStepView: UIView {
    
    public enum Step {
        case first
        case second
        case third
    }
    
    init(step: Step) {
        super.init(frame: .zero)
        setupView()
        configureStep(step)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var firstStep = UIView() .. {
        $0.heightAnchor(10)
        $0.widthAnchor(10)
        $0.backgroundColor = .neutralLow
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.roundCorners(cornerRadius: 5)
        $0.layer.borderColor = UIColor.neutral.cgColor
        $0.layer.borderWidth = 1
    }

    private lazy var secondStep = UIView() .. {
        $0.heightAnchor(10)
        $0.widthAnchor(10)
        $0.backgroundColor = .neutralLow
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.roundCorners(cornerRadius: 5)
        $0.layer.borderColor = UIColor.neutral.cgColor
        $0.layer.borderWidth = 1
    }

    private lazy var thirdStep = UIView() .. {
        $0.heightAnchor(10)
        $0.widthAnchor(10)
        $0.backgroundColor = .neutralLow
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.roundCorners(cornerRadius: 5)
        $0.layer.borderColor = UIColor.neutral.cgColor
        $0.layer.borderWidth = 1
    }

    func setupView() {
        addSubview(firstStep)
        addSubview(secondStep)
        addSubview(thirdStep)
        
        firstStep
            .topAnchor(in: self, padding: .xSmall2)
            .leftAnchor(in: self, padding: 10)
        
        secondStep
            .topAnchor(in: self, padding: .xSmall2)
            .leftAnchor(in: firstStep, attribute: .right, padding: 10)

        thirdStep
            .topAnchor(in: self, padding: .xSmall2)
            .leftAnchor(in: secondStep, attribute: .right, padding: 10)

    }
    
    private func configureStep(_ step: Step) {
        switch step {
        case .first: firstStep.backgroundColor = .purpleLight
        case .second: secondStep.backgroundColor = .purpleLight
        case .third: thirdStep.backgroundColor = .purpleLight
        }
    }
}
