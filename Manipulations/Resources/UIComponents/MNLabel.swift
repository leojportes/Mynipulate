//
//  BarberLabel.swift
//  Manipulations
//
//  Created by Leonardo Portes on 29/12/22.
//

import UIKit

class MNLabel: UILabel {
    init(
        text: String = "",
        font: UIFont = UIFont.boldSystemFont(ofSize: 14),
        textColor: UIColor = .neutralHigh
    ) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.font = font
        self.text = text
        self.textColor = textColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
