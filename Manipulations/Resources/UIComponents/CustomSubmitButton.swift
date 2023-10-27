//
//  SubmitButton.swift
//  Manipulations
//
//  Created by Leonardo Portes on 29/12/22.
//

import Foundation
import UIKit

class CustomSubmitButton: UIButton {
    private let onTap: Action
    
    var showLockView: Bool = false {
        didSet {
            lockView.isHidden = showLockView.not
        }
    }
    
    private lazy var lockView = UIImageView() .. {
        $0.translatesAutoresizingMaskIntoConstraints  = false
        $0.image = UIImage(systemName: "exclamationmark.lock.fill")
        $0.heightAnchor(.xLarge)
        $0.setImageColor(color: .purpleLight.withAlphaComponent(0.8))
        $0.widthAnchor(.xLarge)
        $0.isHidden = true
    }
    
    init(
        title: String,
        colorTitle: UIColor = .neutralHigh,
        radius: CGFloat = 10,
        background: UIColor = .clear,
        alignmentText: ContentHorizontalAlignment = .center,
        borderColorCustom: CGColor = UIColor.clear.cgColor,
        borderWidthCustom: CGFloat = CGFloat(),
        fontSize: CGFloat = 18,
        action: @escaping () -> Void = {}
    ) {
        self.onTap = action
        super.init(frame: .zero)
        self.setTitle(title, for: .normal)
        self.setTitleColor(colorTitle, for: .normal)
        self.layer.cornerRadius = radius
        self.backgroundColor = background
        self.contentHorizontalAlignment = alignmentText
        self.layer.borderColor = borderColorCustom
        self.layer.borderWidth = borderWidthCustom
        self.titleLabel?.font = .boldSystemFont(ofSize: fontSize)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addTarget(self, action: #selector(onTapAction), for: .touchUpInside)
        addSubview(lockView)
        lockView
            .centerY(in: self)
            .rightAnchor(in: self, padding: .medium)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func onTapAction() {
        onTap()
    }
}
