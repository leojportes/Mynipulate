//
//  GripView.swift
//  Manipulations
//
//  Created by Leonardo Portes on 02/02/23.
//

import UIKit

final class GripView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor(4)
        self.widthAnchor(34)
        self.backgroundColor = .neutral
        self.roundCorners(cornerRadius: 2)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
