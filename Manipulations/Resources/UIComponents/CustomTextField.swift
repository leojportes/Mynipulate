//
//  UITextFieldBarber.swift
//  Manipulations
//
//  Created by Leonardo Portes on 29/12/22.
//

import Foundation
import UIKit

class CustomTextField: UITextField {
    
    private lazy var baseLineview = UIView() .. {
        $0.backgroundColor = .neutral
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.isHidden = true
    }
    
    init(
        titlePlaceholder: String = "",
        colorPlaceholder: UIColor = .lightGray,
        textColor: UIColor = .neutralHigh,
        radius: CGFloat = 0,
        borderColor: CGColor = UIColor.clear.cgColor,
        borderWidth: CGFloat = 0,
        keyboardType: UIKeyboardType = .default,
        isSecureTextEntry: Bool = false,
        showBaseLine: Bool = false
    ) {
        super.init(frame: .zero)
        let placeholderFont = UIFont.systemFont(ofSize: .medium)
        self.attributedPlaceholder = NSAttributedString(
            string: titlePlaceholder,
            attributes: [
                NSAttributedString.Key.foregroundColor: colorPlaceholder,
                NSAttributedString.Key.font: placeholderFont
            ]
        )
        self.textColor = textColor
        self.layer.cornerRadius = radius
        self.layer.borderColor = borderColor
        self.layer.borderWidth = borderWidth
        self.translatesAutoresizingMaskIntoConstraints = false
        self.keyboardType = keyboardType
        self.isSecureTextEntry = isSecureTextEntry
        self.setPaddingLeft()

        self.addSubview(baseLineview)
        baseLineview
            .bottomAnchor(in: self)
            .heightAnchor(1)
            .leftAnchor(in: self)
            .rightAnchor(in: self)
        
        baseLineview.isHidden = !showBaseLine
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
