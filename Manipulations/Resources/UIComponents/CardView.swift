//
//  CardView.swift
//  Manipulations
//
//  Created by Leonardo Portes on 29/12/22.
//

import UIKit

class CardView: UIView {
    
    init(
        shadowColor: CGColor = UIColor.neutral.cgColor,
        shadowOpacity: Float = 0.3,
        shadowOffset: CGSize = CGSize(width: -1, height: 1),
        shadowRadius: CGFloat = 2,
        cornerRadius: CGFloat = 10,
        backgroundColor: UIColor = .neutral
    ) {
        super.init(frame: .zero)
        self.layer.shadowColor = shadowColor
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowRadius = shadowRadius
        self.layer.cornerRadius = cornerRadius
        self.backgroundColor = backgroundColor
        self.translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
